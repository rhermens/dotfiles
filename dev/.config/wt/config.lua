wt.copy({ src = ".env" })
wt.copy({ src = ".env.test" })
wt.link({ src = "node_modules" })

wt.command("pnpm i")

-- Create a tmux session with extra windows
wt.tmux.session(true)
wt.tmux.window("")     -- blank shell window
wt.tmux.window("nvim") -- open neovim
wt.tmux.window("")
wt.tmux.window("opencode")
