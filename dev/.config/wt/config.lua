wt.worktrees_directory("$HOME/.worktrees")

wt.copy({ glob = "**/.env", glob_ignore = "**/node_modules/**" })
wt.copy({ glob = "**/.env.test", glob_ignore = "**/node_modules/**" })
wt.copy({ glob = "**/.env.test.local", glob_ignore = "**/node_modules/**" })

wt.command("pnpm i")

-- Create a tmux session with extra windows
wt.tmux.session(true)
local ticket = wt.worktree and wt.worktree:match("^[A-Z]+%-%d+$")
if ticket then
    wt.tmux.window({ "jira-stream watch --ticket " .. ticket .. " --socket /tmp/" .. wt.worktree .. "-jira-stream.sock",
        "github-stream --socket /tmp/" ..
        wt.worktree .. "-github-stream.sock" })
else
    wt.tmux.window(nil) -- blank shell window
end
wt.tmux.window(nil)
wt.tmux.window("nvim") -- open neovim
wt.tmux.window(nil)
wt.tmux.window(wt.args[0] and string.format("claude \"%s\"", wt.args[0]) or "claude")
