wt.copy({ src = ".env" })
wt.copy({ src = ".env.test" })
wt.copy({ glob = "**/.env", glob_ignore = ".worktrees/**" })
wt.copy({ glob = "**/.env.test", glob_ignore = ".worktrees/**" })

wt.command("pnpm i")

-- Create a tmux session with extra windows
wt.tmux.session(true)
wt.tmux.window("")     -- blank shell window
wt.tmux.window("nvim") -- open neovim
wt.tmux.window("")
wt.tmux.window("claude" .. (wt.args[0] or ""))
