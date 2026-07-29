import type {
	ExtensionAPI,
	ExtensionContext,
	SessionEntry,
} from "@earendil-works/pi-coding-agent";

const SKILL_NAME = "skill-curating";
const SKILL_COMMAND = `skill:${SKILL_NAME}`;
const SKILL_INVOCATION = `/${SKILL_COMMAND}`;
export const AUTO_CURATION_MARKER = "[pi-skill-curation:auto]";
export const MIN_CURATION_CONTEXT_TOKENS = 25_000;
const NO_RECOMMENDATION_RESPONSE = "No skill changes recommended.";

const BACKGROUND_CURATION_PROMPT = `Review the completed session for reusable improvements to the agent skill library.

Use recommendation mode. Do not edit files. Recommend only high-confidence changes supported by repeated evidence, an explicit user correction, or one clearly reusable high-impact failure.

Accept a recommendation only when it improves future behavior, is likely to recur, remains stable beyond this task, applies across projects and domains, belongs in a skill, and is not already generic agent guidance. Reject project-specific, framework-specific, language-specific, tool-specific, speculative, temporary, or duplicated guidance.

For each accepted recommendation, report the destination skill, session evidence, exact domain-neutral behavior change, expected benefit, and confidence. Limit the report to the highest-value candidates. If no candidate meets that bar, respond only: ${NO_RECOMMENDATION_RESPONSE}`;

type CommandLike = {
	name: string;
	source: string;
};

export type BackgroundCurationRunner = (
	entries: readonly SessionEntry[],
	ctx: ExtensionContext,
	signal: AbortSignal,
) => Promise<string>;

const isRecord = (value: unknown): value is Record<string, unknown> =>
	typeof value === "object" && value !== null;

const contentText = (content: unknown): string | undefined => {
	if (typeof content === "string") return content;
	if (!Array.isArray(content)) return undefined;

	const text = content
		.reduce<string[]>((parts, block) => {
			if (
				!isRecord(block) ||
				block.type !== "text" ||
				typeof block.text !== "string"
			)
				return parts;
			return [...parts, block.text];
		}, [])
		.join("\n");

	return text || undefined;
};

export const latestUserText = (
	entries: readonly unknown[],
): string | undefined => {
	for (let index = entries.length - 1; index >= 0; index -= 1) {
		const entry = entries[index];
		if (
			!isRecord(entry) ||
			entry.type !== "message" ||
			!isRecord(entry.message)
		)
			continue;
		if (entry.message.role !== "user") continue;
		return contentText(entry.message.content);
	}

	return undefined;
};

export const hasCuratingSkill = (commands: readonly CommandLike[]): boolean =>
	commands.some(
		(command) => command.source === "skill" && command.name === SKILL_COMMAND,
	);

export const isCuratingInvocation = (text: string): boolean =>
	text.trimStart().startsWith(SKILL_INVOCATION);

const serializeSession = (entries: readonly SessionEntry[]): string =>
	entries
		.reduce<string[]>((parts, entry) => {
			if (entry.type === "compaction") {
				return [...parts, `[compaction summary]\n${entry.summary}`];
			}
			if (entry.type !== "message") return parts;

			const text = contentText(entry.message.content);
			if (!text) return parts;
			const role =
				entry.message.role === "toolResult"
					? `tool:${entry.message.toolName}`
					: entry.message.role;
			return [...parts, `[${role}]\n${text}`];
		}, [])
		.join("\n\n");

export const runBackgroundCuration: BackgroundCurationRunner = async (
	entries,
	ctx,
	signal,
) => {
	const model = ctx.model;
	if (!model) throw new Error("No model selected");

	const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
	if (!auth.ok) throw new Error(auth.error);
	if (!auth.apiKey) throw new Error(`No API key for ${model.provider}`);
	if (signal.aborted) return "";

	const conversation = serializeSession(entries);
	const { complete } = await import("@earendil-works/pi-ai/compat");
	const response = await complete(
		model,
		{
			systemPrompt: BACKGROUND_CURATION_PROMPT,
			messages: [
				{
					role: "user",
					content: [
						{
							type: "text",
							text: `<session>\n${conversation}\n</session>`,
						},
					],
					timestamp: Date.now(),
				},
			],
		},
		{
			apiKey: auth.apiKey,
			headers: auth.headers,
			env: auth.env,
			maxTokens: 2_000,
			reasoningEffort: "low",
			signal,
		},
	);

	if (response.stopReason === "aborted") return "";
	return response.content
		.filter(
			(block): block is { type: "text"; text: string } => block.type === "text",
		)
		.map((block) => block.text)
		.join("\n")
		.trim();
};

export const registerSkillCurationExtension = (
	pi: ExtensionAPI,
	runCuration: BackgroundCurationRunner = runBackgroundCuration,
) => {
	let manualCurationRunActive = false;
	let missingSkillWarningShown = false;
	let backgroundController: AbortController | undefined;
	let pendingNotice: { message: string; level: "info" | "warning" } | undefined;

	const showOrDeferNotice = (
		ctx: ExtensionContext,
		message: string,
		level: "info" | "warning",
	) => {
		if (!ctx.hasUI) return;
		if (ctx.isIdle()) {
			ctx.ui.notify(message, level);
			return;
		}
		pendingNotice = { message, level };
	};

	pi.on("session_start", () => {
		backgroundController?.abort();
		backgroundController = undefined;
		pendingNotice = undefined;
		manualCurationRunActive = false;
		missingSkillWarningShown = false;
	});

	pi.on("session_shutdown", () => {
		backgroundController?.abort();
		backgroundController = undefined;
		pendingNotice = undefined;
	});

	pi.on("input", (event) => {
		manualCurationRunActive = isCuratingInvocation(event.text);
	});

	pi.on("agent_settled", (_event, ctx) => {
		if (pendingNotice && ctx.hasUI && ctx.isIdle()) {
			ctx.ui.notify(pendingNotice.message, pendingNotice.level);
			pendingNotice = undefined;
		}

		const branch = ctx.sessionManager.getBranch();
		const latestPrompt = latestUserText(branch);
		const isPersistedAutoCuration =
			latestPrompt?.includes(AUTO_CURATION_MARKER) ?? false;

		if (manualCurationRunActive || isPersistedAutoCuration) {
			manualCurationRunActive = false;
			return;
		}

		if (!ctx.isIdle() || !latestPrompt || backgroundController) return;

		const contextTokens = ctx.getContextUsage()?.tokens;
		if (
			contextTokens === undefined ||
			contextTokens < MIN_CURATION_CONTEXT_TOKENS
		)
			return;

		if (!hasCuratingSkill(pi.getCommands())) {
			if (ctx.hasUI && !missingSkillWarningShown) {
				ctx.ui.notify(
					`Automatic skill curation is disabled because ${SKILL_NAME} is unavailable.`,
					"warning",
				);
				missingSkillWarningShown = true;
			}
			return;
		}

		const controller = new AbortController();
		backgroundController = controller;
		void runCuration([...branch], ctx, controller.signal)
			.then((result) => {
				const recommendation = result.trim();
				if (
					controller.signal.aborted ||
					!recommendation ||
					recommendation === NO_RECOMMENDATION_RESPONSE
				)
					return;
				showOrDeferNotice(
					ctx,
					`Skill curation recommendation:\n${recommendation}`,
					"info",
				);
			})
			.catch((error) => {
				if (controller.signal.aborted) return;
				const message = error instanceof Error ? error.message : String(error);
				showOrDeferNotice(
					ctx,
					`Background skill curation failed: ${message}`,
					"warning",
				);
			})
			.finally(() => {
				if (backgroundController === controller) {
					backgroundController = undefined;
				}
			});
	});
};

export default function skillCurationExtension(pi: ExtensionAPI) {
	registerSkillCurationExtension(pi);
}
