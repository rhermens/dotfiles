require('gitsigns').setup({
    signcolumn = false,
})

require('diffview').setup({
    file_panel = {
        win_config = {
            position = 'right',
            width = 50
        }
    }
})

vim.api.nvim_create_user_command('DiffDevelop', function()
    vim.cmd('DiffviewOpen origin/develop...HEAD --imply-local')
end, { desc = 'Compare with origin/develop, including local changes' })
