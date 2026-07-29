import { describe, expect, test } from "bun:test";
import {
	AUTO_CURATION_MARKER,
	hasCuratingSkill,
	isCuratingInvocation,
	latestUserText,
	registerSkillCurationExtension,
	type BackgroundCurationRunner,
} from "./index";

type Handler = (event: any, context: any) => Promise<any> | any;

const userEntry = (content: string) => ({
	type: "message",
	message: { role: "user", content },
});

const settleBackground = () => new Promise((resolve) => setTimeout(resolve, 0));

const createHarness = (
	commands = [{ name: "skill:skill-curating", source: "skill" }],
	contextTokens = 25_000,
	runner: BackgroundCurationRunner = async () =>
		"No skill changes recommended.",
) => {
	const handlers = new Map<string, Handler>();
	const sentMessages: string[] = [];
	const notifications: Array<{ message: string; level: string }> = [];
	const runnerCalls: Array<{
		entries: readonly unknown[];
		signal: AbortSignal;
	}> = [];
	const trackedRunner: BackgroundCurationRunner = async (
		entries,
		context,
		signal,
	) => {
		runnerCalls.push({ entries, signal });
		return runner(entries, context, signal);
	};

	const pi = {
		on: (event: string, handler: Handler) => handlers.set(event, handler),
		getCommands: () => commands,
		sendUserMessage: (message: string) => sentMessages.push(message),
	};

	registerSkillCurationExtension(pi as any, trackedRunner);

	const context = (
		entries: unknown[],
		idle: boolean | (() => boolean) = true,
	) => ({
		hasUI: true,
		isIdle: () => (typeof idle === "function" ? idle() : idle),
		getContextUsage: () => ({ tokens: contextTokens }),
		model: { provider: "test", id: "test-model" },
		modelRegistry: {},
		sessionManager: { getBranch: () => entries },
		ui: {
			notify: (message: string, level: string) =>
				notifications.push({ message, level }),
		},
	});

	return {
		handlers,
		sentMessages,
		notifications,
		runnerCalls,
		context,
	};
};

describe("skill curation extension", () => {
	test("runs automatic curation without queuing a foreground turn", async () => {
		const harness = createHarness();

		await harness.handlers.get("agent_settled")?.(
			{},
			harness.context([userEntry("Build the feature")]),
		);
		await settleBackground();

		expect(harness.runnerCalls).toHaveLength(1);
		expect(harness.sentMessages).toHaveLength(0);
		expect(harness.notifications).toHaveLength(0);
	});

	test("shows a completed background recommendation", async () => {
		const harness = createHarness(
			undefined,
			undefined,
			async () => "Improve build: add a durable verification rule.",
		);

		await harness.handlers.get("agent_settled")?.(
			{},
			harness.context([userEntry("Build the feature")]),
		);
		await settleBackground();

		expect(harness.notifications).toEqual([
			{
				message:
					"Skill curation recommendation:\nImprove build: add a durable verification rule.",
				level: "info",
			},
		]);
	});

	test("defers recommendations while the user agent is running", async () => {
		const harness = createHarness(
			undefined,
			undefined,
			async () => "Improve build with a durable verification rule.",
		);
		const entries = [userEntry("Build the feature")];
		let idle = true;
		const context = harness.context(entries, () => idle);

		await harness.handlers.get("agent_settled")?.({}, context);
		idle = false;
		await settleBackground();
		expect(harness.notifications).toHaveLength(0);

		await harness.handlers.get("agent_settled")?.({}, harness.context(entries));
		expect(harness.notifications).toHaveLength(1);
	});

	test("does not start overlapping background runs", async () => {
		let finish: ((value: string) => void) | undefined;
		const pending = new Promise<string>((resolve) => {
			finish = resolve;
		});
		const harness = createHarness(undefined, undefined, async () => pending);
		const context = harness.context([userEntry("Build the feature")]);

		await harness.handlers.get("agent_settled")?.({}, context);
		await harness.handlers.get("agent_settled")?.({}, context);

		expect(harness.runnerCalls).toHaveLength(1);
		finish?.("No skill changes recommended.");
		await settleBackground();
	});

	test("aborts background work when the session shuts down", async () => {
		let finish: ((value: string) => void) | undefined;
		const pending = new Promise<string>((resolve) => {
			finish = resolve;
		});
		const harness = createHarness(undefined, undefined, async () => pending);

		await harness.handlers.get("agent_settled")?.(
			{},
			harness.context([userEntry("Build the feature")]),
		);
		await harness.handlers.get("session_shutdown")?.({}, {});

		expect(harness.runnerCalls[0]?.signal.aborted).toBe(true);
		finish?.("A recommendation that belongs to the old session.");
		await settleBackground();
		expect(harness.notifications).toHaveLength(0);
	});

	test("skips curation below the minimum context size", async () => {
		const harness = createHarness(undefined, 24_999);

		await harness.handlers.get("agent_settled")?.(
			{},
			harness.context([userEntry("Build the feature")]),
		);

		expect(harness.runnerCalls).toHaveLength(0);
	});

	test("does not recurse from a persisted automatic curation prompt", async () => {
		const harness = createHarness();
		const entries = [
			userEntry(`Expanded skill instructions ${AUTO_CURATION_MARKER}`),
		];

		await harness.handlers.get("agent_settled")?.({}, harness.context(entries));

		expect(harness.runnerCalls).toHaveLength(0);
	});

	test("does not follow manual curation with automatic curation", async () => {
		const harness = createHarness();

		await harness.handlers.get("input")?.(
			{ text: "/skill:skill-curating review this session" },
			{},
		);
		await harness.handlers.get("agent_settled")?.(
			{},
			harness.context([userEntry("Expanded manual skill instructions")]),
		);

		expect(harness.runnerCalls).toHaveLength(0);
	});

	test("warns once when the skill is unavailable", async () => {
		const harness = createHarness([]);
		const context = harness.context([userEntry("Build the feature")]);

		await harness.handlers.get("agent_settled")?.({}, context);
		await harness.handlers.get("agent_settled")?.({}, context);

		expect(harness.runnerCalls).toHaveLength(0);
		expect(harness.notifications).toHaveLength(1);
		expect(harness.notifications[0]?.level).toBe("warning");
	});

	test("reports background failures without starting a foreground turn", async () => {
		const harness = createHarness(undefined, undefined, async () => {
			throw new Error("provider unavailable");
		});

		await harness.handlers.get("agent_settled")?.(
			{},
			harness.context([userEntry("Build the feature")]),
		);
		await settleBackground();

		expect(harness.sentMessages).toHaveLength(0);
		expect(harness.notifications).toEqual([
			{
				message: "Background skill curation failed: provider unavailable",
				level: "warning",
			},
		]);
	});
});

describe("skill curation helpers", () => {
	test("extracts the latest user text from structured content", () => {
		const entries = [
			userEntry("older"),
			{
				type: "message",
				message: {
					role: "user",
					content: [
						{ type: "text", text: "newer" },
						{ type: "image", data: "ignored" },
					],
				},
			},
		];

		expect(latestUserText(entries)).toBe("newer");
	});

	test("matches only the curating skill command", () => {
		expect(
			hasCuratingSkill([{ name: "skill:skill-curating", source: "skill" }]),
		).toBe(true);
		expect(
			hasCuratingSkill([{ name: "skill:skill-authoring", source: "skill" }]),
		).toBe(false);
		expect(isCuratingInvocation("  /skill:skill-curating now")).toBe(true);
		expect(isCuratingInvocation("/skill:skill-authoring now")).toBe(false);
	});
});
