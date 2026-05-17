local function buf_fmt()
    vim.lsp.buf.format({
        async = false,
        filter = function(client)
            return client.name ~= "ts_ls" and
                client.name ~= "vtsls"
        end
    })
end

vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename)
vim.keymap.set({ 'n', 'x' }, '<F3>', buf_fmt)
vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action)

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end

        if client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                buffer = event.buf,
                callback = buf_fmt,
            })
        end
    end,
})

-- mason
require('mason').setup({})

-- mason-lspconfig
require('mason-lspconfig').setup({})

-- show documentation popup for completion items
require('blink.cmp').setup({
    keymap = {
        preset = 'default',
        ['<CR>'] = { 'accept', 'fallback' },
    },
    appearance = {},
    completion = {
        accept = {
            resolve_timeout_ms = 5000,
        },
        documentation = {
            auto_show = true,
        },
    },
    sources = {
        default = { 'lsp', 'path', 'buffer' },
    },
    fuzzy = {},
    signature = {
        enabled = true,
        trigger = {
            show_on_insert = true,
        },
    },
})
