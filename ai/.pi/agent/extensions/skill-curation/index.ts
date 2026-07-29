import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const SKILL_NAME = "skill-curating";
const SKILL_COMMAND = `skill:${SKILL_NAME}`;
const SKILL_INVOCATION = `/${SKILL_COMMAND}`;
export const AUTO_CURATION_MARKER = "[pi-skill-curation:auto]";
export const MIN_CURATION_CONTEXT_TOKENS = 25_000;

const AUTO_CURATION_PROMPT =
	`${SKILL_INVOCATION} ${AUTO_CURATION_MARKER} ` +
	"Reflect on the session that settled immediately before this message. " +
	"Use recommendation mode. Do not edit files. Keep the report concise.";

type CommandLike = {
	name: string;
	source: string;
};

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

export default function skillCurationExtension(pi: ExtensionAPI) {
	let curationRunActive = false;
	let missingSkillWarningShown = false;

	pi.on("session_start", () => {
		curationRunActive = false;
		missingSkillWarningShown = false;
	});

	pi.on("input", (event) => {
		curationRunActive = isCuratingInvocation(event.text);
	});

	pi.on("agent_settled", (_event, ctx) => {
		const latestPrompt = latestUserText(ctx.sessionManager.getBranch());
		const isPersistedAutoCuration =
			latestPrompt?.includes(AUTO_CURATION_MARKER) ?? false;

		if (curationRunActive || isPersistedAutoCuration) {
			curationRunActive = false;
			return;
		}

		if (!ctx.isIdle() || !latestPrompt) return;

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

		curationRunActive = true;
		try {
			pi.sendUserMessage(AUTO_CURATION_PROMPT);
		} catch (error) {
			curationRunActive = false;
			if (ctx.hasUI) {
				const message = error instanceof Error ? error.message : String(error);
				ctx.ui.notify(`Automatic skill curation failed: ${message}`, "error");
			}
		}
	});
}
