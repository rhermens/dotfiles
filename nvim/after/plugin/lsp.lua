local lsp = require('lsp-zero').preset({
    name = 'recommended',
    float_border = 'none'
})

lsp.on_attach(function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, bufopts)

    lsp.default_keymaps({ buffer = bufnr })
end)

lsp.setup()
