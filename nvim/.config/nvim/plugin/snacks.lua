vim.g.snacks_animate = false

require('snacks').setup({
    animate = {},
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    terminal = {},
    indent = {
        enabled = true,
        indent = {
            char = '▏',
        },
        scope = { enabled = false },
    },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = {
        enabled = true,
    },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
})

-- picker keymaps
vim.keymap.set('n', '<C-p>', function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
vim.keymap.set('n', '<C-space>', function()
    Snacks.picker.buffers({
        win = {
            input = {
                keys = {
                    ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
                }
            }
        }
    })
end, { desc = "Buffers" })
vim.keymap.set('n', '<C-g>', function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set('n', '<leader>g', function() Snacks.picker.lines() end, { desc = "Grep Buffer Lines" })
vim.keymap.set('n', '<leader>n', function() Snacks.picker.notifications() end, { desc = "Notification History" })
vim.keymap.set('n', '<leader>c', function() Snacks.picker.commands() end, { desc = "Commands" })

-- git
vim.keymap.set('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
vim.keymap.set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set('n', '<leader>gL', function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set('n', '<leader>gS', function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
vim.keymap.set('n', '<leader>gd', function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
vim.keymap.set('n', '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })

-- search
vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
vim.keymap.set('n', '<leader>sj', function() Snacks.picker.jumps() end, { desc = "Jumps" })
vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set('n', '<leader>sq', function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
vim.keymap.set('n', '<leader>uC', function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

-- LSP
vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
vim.keymap.set('n', 'gi', function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set('n', '<leader>s', function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
vim.keymap.set('n', '<leader>S', function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })

-- other
vim.keymap.set('n', '<leader>n', function() Snacks.notifier.show_history() end, { desc = "Notification History" })
vim.keymap.set('n', '<leader>x', function() Snacks.bufdelete.other() end, { desc = "Delete Buffer" })
vim.keymap.set('n', '<leader>cR', function() Snacks.rename.rename_file() end, { desc = "Rename File" })
vim.keymap.set({ 'n', 'v' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = "Git Browse" })
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set('n', '<leader>un', function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
vim.keymap.set('n', '<leader>N', function()
    Snacks.win({
        file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
        width = 0.6,
        height = 0.6,
        wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
        },
    })
end, { desc = "Neovim News" })

-- oil rename integration
vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
        if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
    end,
})
