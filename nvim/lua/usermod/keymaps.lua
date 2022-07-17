
vim.keymap.set('n', 'Y', 'yy')

--System clipboard
vim.keymap.set('v', '<C-c>', '"+y', { remap = true })
vim.keymap.set('v', '<C-x>', '"+c', { remap = true })
vim.keymap.set('i', '<C-v>', '<ESC>"+pa', { remap = true })
vim.keymap.set('n', '<C-v>', '"+p', { remap = true })

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    command = ':%s/s+$//e'
})

