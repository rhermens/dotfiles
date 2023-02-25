local M = {}

M.project_files = function()
    local opts = {}

    local ok = pcall(require"telescope.builtin".git_files, opts)
    if not ok then require"telescope.builtin".find_files(opts) end
end

require('telescope').setup{
    defaults = {
        file_ignore_patterns = { "node_modules", "vendor", ".git" }
    },
    pickers = {
        find_files = {
            hidden = true,
            no_ignore = true,
        },
        git_files = {
            recurse_submodules = true,
        }
    }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})

vim.keymap.set('n', '<Leader>gs', builtin.git_status, {})
