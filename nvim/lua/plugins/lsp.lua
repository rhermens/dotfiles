return {
    { 'neovim/nvim-lspconfig' },
    {
        'nvim-lua/lsp-status.nvim',
        init = function ()
            require('lsp-status').register_progress()
        end
    },
    { 'williamboman/mason.nvim', config = true },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            { 'williamboman/mason.nvim' },
            { 'nvim-lua/lsp-status.nvim' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        opts = function ()
            local lsp_status = require('lsp-status')
            local lsp_capabilities = vim.tbl_extend('keep', require('cmp_nvim_lsp').default_capabilities(), lsp_status.capabilities)
            return {
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({
                            capabilities = lsp_capabilities,
                            on_attach = function(client)
                                lsp_status.on_attach(client)
                            end
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
