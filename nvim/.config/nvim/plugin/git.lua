require('gitsigns').setup({
    signcolumn = false,
})

vim.api.nvim_create_user_command('DiffDevelop', function()
    vim.cmd('DiffviewOpen origin/develop...HEAD --imply-local')
end, { desc = 'Compare with origin/develop, including local changes' })
