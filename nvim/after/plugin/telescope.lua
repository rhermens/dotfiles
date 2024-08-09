local builtin = require("telescope.builtin")

project_files = function()
    local is_modules = vim.fn.filereadable(vim.fn.getcwd() .. '/.gitmodules') == 1
    local is_git = vim.fn.isdirectory(vim.fn.getcwd() .. '/.git') == 1

    if is_git and not is_modules then 
        return require("telescope.builtin").git_files()
    else
        return require("telescope.builtin").find_files()
    end
end

require('telescope').setup{
    pickers = {
        git_files = {
            use_git_root = false,
            show_untracked = true,
        }
    }
}

vim.keymap.set('n', '<Leader>p', builtin.builtin, {})
vim.keymap.set('n', '<Leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<Leader>s', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<Leader>c', builtin.commands, {})
vim.keymap.set('n', '<Leader>m', builtin.marks, {})
vim.keymap.set('n', '<Leader>j', builtin.jumplist, {})
vim.keymap.set('n', '<C-Space>', builtin.buffers, {})
vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
vim.keymap.set('n', '<C-p>', project_files, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})
vim.keymap.set('n', '<Leader>gs', builtin.git_status, {})


