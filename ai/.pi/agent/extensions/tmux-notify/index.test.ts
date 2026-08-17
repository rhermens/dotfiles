import { describe, expect, test } from "bun:test";
import tmuxNotifyExtension, {
	TMUX_NOTIFY_SCRIPT,
	TMUX_WINDOW_NOTIFY_SCRIPT,
	notifyWhenWaiting,
} from "./index";

type Handler = (event: unknown, context: unknown) => Promise<void> | void;

const waitingContext = {
	mode: "tui" as const,
	isIdle: () => true,
};

describe("tmux notify extension", () => {
	test("runs the session and window notification scripts after the agent settles", async () => {
		const handlers = new Map<string, Handler>();
		const calls: Array<{ command: string; args: string[]; timeout?: number }> =
			[];
		const pi = {
			on: (event: string, handler: Handler) => handlers.set(event, handler),
			exec: async (
				command: string,
				args: string[],
				options: { timeout?: number },
			) => {
				calls.push({ command, args, timeout: options.timeout });
				return { stdout: "", stderr: "", code: 0, killed: false };
			},
		};

		tmuxNotifyExtension(pi as any);
		await handlers.get("agent_settled")?.({}, waitingContext);

		expect(calls).toEqual([
			{ command: TMUX_NOTIFY_SCRIPT, args: [], timeout: 5_000 },
			{ command: TMUX_WINDOW_NOTIFY_SCRIPT, args: [], timeout: 5_000 },
		]);
	});

	test("does not notify outside the interactive TUI", async () => {
		let calls = 0;
		const exec = async () => {
			calls += 1;
			return { stdout: "", stderr: "", code: 0, killed: false };
		};

		await notifyWhenWaiting(exec as any, { mode: "print", isIdle: () => true });
		expect(calls).toBe(0);
	});

	test("does not notify before Pi is idle", async () => {
		let calls = 0;
		const exec = async () => {
			calls += 1;
			return { stdout: "", stderr: "", code: 0, killed: false };
		};

		await notifyWhenWaiting(exec as any, { mode: "tui", isIdle: () => false });
		expect(calls).toBe(0);
	});
});
