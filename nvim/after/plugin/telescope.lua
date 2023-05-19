
project_files = function()
    local opts = {}

    local ok = pcall(require"telescope.builtin".git_files, opts)
    if not ok then require"telescope.builtin".find_files(opts) end
end

require('telescope').setup{
    pickers = {
        git_files = {
            use_git_root = false,
            show_untracked = true
        }
    }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<C-p>', project_files, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})

vim.keymap.set('n', '<Leader>gs', builtin.git_status, {})
