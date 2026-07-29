import { describe, expect, test } from "bun:test";
import skillCurationExtension, {
	AUTO_CURATION_MARKER,
	hasCuratingSkill,
	isCuratingInvocation,
	latestUserText,
} from "./index";

type Handler = (event: any, context: any) => Promise<void> | void;

const userEntry = (content: string) => ({
	type: "message",
	message: { role: "user", content },
});

const createHarness = (
	commands = [{ name: "skill:skill-curating", source: "skill" }],
	contextTokens = 25_000,
) => {
	const handlers = new Map<string, Handler>();
	const sentMessages: string[] = [];
	const notifications: Array<{ message: string; level: string }> = [];

	const pi = {
		on: (event: string, handler: Handler) => handlers.set(event, handler),
		getCommands: () => commands,
		sendUserMessage: (message: string) => sentMessages.push(message),
	};

	skillCurationExtension(pi as any);

	const context = (entries: unknown[]) => ({
		hasUI: true,
		isIdle: () => true,
		getContextUsage: () => ({ tokens: contextTokens }),
		sessionManager: { getBranch: () => entries },
		ui: {
			notify: (message: string, level: string) =>
				notifications.push({ message, level }),
		},
	});

	return { handlers, sentMessages, notifications, context };
};

describe("skill curation extension", () => {
	test("queues curation after a normal settled run", async () => {
		const harness = createHarness();

		await harness.handlers.get("agent_settled")?.(
			{},
			harness.context([userEntry("Build the feature")]),
		);

		expect(harness.sentMessages).toHaveLength(1);
		expect(harness.sentMessages[0]).toContain("/skill:skill-curating");
		expect(harness.sentMessages[0]).toContain(AUTO_CURATION_MARKER);
		expect(harness.sentMessages[0]).toContain("Do not edit files");
	});

	test("skips curation below the minimum context size", async () => {
		const harness = createHarness(undefined, 24_999);

		await harness.handlers.get("agent_settled")?.(
			{},
			harness.context([userEntry("Build the feature")]),
		);

		expect(harness.sentMessages).toHaveLength(0);
	});

	test("does not recurse after automatic curation settles", async () => {
		const harness = createHarness();
		const entries = [
			userEntry(`Expanded skill instructions ${AUTO_CURATION_MARKER}`),
		];

		await harness.handlers.get("agent_settled")?.({}, harness.context(entries));

		expect(harness.sentMessages).toHaveLength(0);
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

		expect(harness.sentMessages).toHaveLength(0);
	});

	test("warns once when the skill is unavailable", async () => {
		const harness = createHarness([]);
		const context = harness.context([userEntry("Build the feature")]);

		await harness.handlers.get("agent_settled")?.({}, context);
		await harness.handlers.get("agent_settled")?.({}, context);

		expect(harness.sentMessages).toHaveLength(0);
		expect(harness.notifications).toHaveLength(1);
		expect(harness.notifications[0]?.level).toBe("warning");
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
