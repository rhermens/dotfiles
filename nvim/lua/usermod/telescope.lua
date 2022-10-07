local M = {}

M.project_files = function()
    local opts = {}

    local ok = pcall(require"telescope.builtin".git_files, opts)
    if not ok then require"telescope.builtin".find_files(opts) end
end

require('telescope').setup{
    pickers = {
        find_files = {
            hidden = true
        },
        git_files = {
            show_untracked = true
        }
    }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', M.project_files, {})
vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})

