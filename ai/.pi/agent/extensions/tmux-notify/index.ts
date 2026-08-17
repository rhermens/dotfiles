import type {
	ExtensionAPI,
	ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { homedir } from "node:os";
import { join } from "node:path";

export const TMUX_NOTIFY_SCRIPT = join(
	homedir(),
	".config",
	"tmux",
	"session-notify.sh",
);
export const TMUX_WINDOW_NOTIFY_SCRIPT = join(
	homedir(),
	".config",
	"tmux",
	"window-notify.sh",
);

type Exec = ExtensionAPI["exec"];
type NotifyContext = Pick<ExtensionContext, "isIdle" | "mode">;

export const notifyWhenWaiting = async (
	exec: Exec,
	ctx: NotifyContext,
): Promise<void> => {
	if (ctx.mode !== "tui" || !ctx.isIdle()) return;

	await Promise.all(
		[TMUX_NOTIFY_SCRIPT, TMUX_WINDOW_NOTIFY_SCRIPT].map((script) =>
			exec(script, [], { timeout: 5_000 }),
		),
	);
};

export default function tmuxNotifyExtension(pi: ExtensionAPI) {
	pi.on("agent_settled", async (_event, ctx) => {
		await notifyWhenWaiting(pi.exec.bind(pi), ctx);
	});
}
