return {
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim', config = true },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            { 'williamboman/mason.nvim' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        opts = function ()
            local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
            return {
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({
                            capabilities = lsp_capabilities,
                        })
                    end,
                    lua_ls = function()
                        require('lspconfig').lua_ls.setup({
                            capabilities = lsp_capabilities,
                            settings = {
                                Lua = {
                                    runtime = {
                                        version = 'LuaJIT'
                                    },
                                    diagnostics = {
                                        globals = {'vim'},
                                    },
                                    workspace = {
                                        library = {
                                            vim.env.VIMRUNTIME,
                                        }
                                    }
                                }
                            }
                        })
                    end,
                }
            }
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependecies = {
            { 'L3MON4D3/LuaSnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'FelipeLema/cmp-async-path' },
        },
        opts = function ()
            local cmp = require('cmp')
            return {
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'async_path' },
                },
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            }
        end,
    },
}
