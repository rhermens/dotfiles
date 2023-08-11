local builtin = require("telescope.builtin")

project_files = function()
    local is_modules = vim.fn.filereadable(vim.fn.getcwd() .. '/.gitmodules') == 1
    local is_git = vim.fn.isdirectory(vim.fn.getcwd() .. '/.git') == 1

    if is_git and not is_modules then 
        require("telescope.builtin").git_files() 
    else
        require("telescope.builtin").find_files() 
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

vim.keymap.set('n', '<Leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<C-p>', project_files, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})
vim.keymap.set('n', '<Leader>gs', builtin.git_status, {})
