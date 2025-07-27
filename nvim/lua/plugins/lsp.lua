return {
    { 
        'neovim/nvim-lspconfig',
        init = function ()
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)

            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'x' }, '<F3>', function () vim.lsp.buf.format({ async = true }) end, opts)
            vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
        end,
    },
    { 'williamboman/mason.nvim', config = true },
    {
        'artemave/workspace-diagnostics.nvim',
        init = function ()
            vim.api.nvim_set_keymap('n', '<space>xx', '', {
                noremap = true,
                callback = function()
                    for _, client in ipairs(vim.lsp.get_clients()) do
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
                    end
                end
            })
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            { 'williamboman/mason.nvim' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'artemave/workspace-diagnostics.nvim' },
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
                                        globals = { 'vim' },
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
                    rust_analyzer = function()
                        require('lspconfig').rust_analyzer.setup({
                            capabilities = lsp_capabilities,
                            settings = {
                                ['rust-analyzer'] = {
                                    procMacro = {
                                        ignored = {
                                            leptos_macro = {"server"},
                                        }
                                    }
                                }
                            }
                        })
                    end,
                    -- jdtls = function()
                    --     require('lspconfig').jdtls.setup({
                    --         capabilities = lsp_capabilities,
                    --     })
                    -- end,
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
        ft = { "scala", "sbt" },
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
