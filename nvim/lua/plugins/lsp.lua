return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {
                'folke/neoconf.nvim',
                cmd = { 'Neoconf' },
                opts = {}
            },
        },
        init = function ()
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)

            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'x' }, '<F3>', function () vim.lsp.buf.format({ async = true, filter = function (client) return client ~= "ts_ls" end }) end, opts)
            vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
        end,
    },
    { 'mason-org/mason.nvim', opts = {} },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            { 'mason-org/mason.nvim' },
            { 'neovim/nvim-lspconfig' },
        },
        opts = {},
    },
    {
        'saghen/blink.cmp',
        version = '1.*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { 
                preset = 'default',
                ['<CR>'] = { 'accept', 'fallback' },
            },
            appearance = {},
            completion = {
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
        },
        opts_extend = { "sources.default" }
    },
}
