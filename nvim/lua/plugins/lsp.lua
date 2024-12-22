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
        "scalameta/nvim-metals",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        ft = { "scala", "sbt", "java" },
        opts = function ()
            local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
            local metals_config = require("metals").bare_config()
            metals_config.capabilities = lsp_capabilities
            -- metals_config.on_attach = function(client, bufnr)
            --     -- your on_attach function
            -- end 
            --
            return metals_config
        end,
        config = function(self, metals_config)
            local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = self.ft,
                callback = function()
                    require("metals").initialize_or_attach(metals_config)
                end,
                group = nvim_metals_group,
            })
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
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
