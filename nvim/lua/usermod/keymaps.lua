
vim.keymap.set('n', 'Y', 'yy')

--System clipboard
vim.keymap.set('v', '<C-c>', '"+y', { remap = true })
vim.keymap.set('v', '<C-x>', '"+c', { remap = true })
vim.keymap.set('i', '<C-v>', '<ESC>"+pa', { remap = true })
vim.keymap.set('n', '<C-v>', '"+p', { remap = true })

-- Close other buffers
vim.keymap.set('n', '<Leader>x', ':%bd|e#|bd#<CR>:CHADopen --nofocus<CR>', { remap = true })

-- Buffer nav
vim.keymap.set('n', '<C-k>', ':bnext<CR>')
vim.keymap.set('n', '<C-j>', ':bprev<CR>')

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    command = ':%s/s+$//e'
})

