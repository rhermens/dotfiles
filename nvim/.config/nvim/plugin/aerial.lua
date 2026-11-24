require('aerial').setup({
    layout = {
        default_direction = 'float'
    }
})

vim.keymap.set('n', '<leader>ss', '<cmd>AerialToggle<CR>', { desc = "LSP Symbols" })
