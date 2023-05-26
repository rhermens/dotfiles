
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

diagnostics = function ()
    require('telescope.builtin').diagnostics()
end
buffers = function ()
    require('telescope.builtin').buffers()
end
help_tags = function ()
    require('telescope.builtin').help_tags()
end
git_status = function ()
    require('telescope.builtin').git_status()
end

vim.keymap.set('n', '<Leader>d', diagnostics, {})
vim.keymap.set('n', '<C-p>', project_files, {})
vim.keymap.set('n', 'fb', buffers, {})
vim.keymap.set('n', 'fh', help_tags, {})
vim.keymap.set('n', '<Leader>gs', git_status, {})
