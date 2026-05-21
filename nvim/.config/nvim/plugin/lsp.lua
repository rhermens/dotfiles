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

        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, event.buf, {
                autotrigger = true,
            })
        end
    end,
})

-- mason
require('mason').setup({})

-- mason-lspconfig
require('mason-lspconfig').setup({})

vim.o.autocomplete = true
vim.o.completeopt = 'menuone,popup,preview'

vim.keymap.set('i', '<CR>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-Y>'
    end
    return '<CR>'
end, { expr = true })
