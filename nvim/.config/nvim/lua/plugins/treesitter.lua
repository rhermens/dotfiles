return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = "main",
        build = ':TSUpdate',
        opts = {
            indent = {
                enable = true
            },
            highlight = {
                enable = true,
            },
        },
        config = function(_, opts)
            local treesitter = require('nvim-treesitter')

            treesitter.setup(opts)

            vim.api.nvim_create_autocmd('FileType', {
                callback = function(args)
                    if vim.list_contains(
                        treesitter.get_installed(),
                        vim.treesitter.language.get_lang(args.match)
                    ) then
                        vim.treesitter.start(args.buf)
                    end
                end,
            })

            vim.api.nvim_create_autocmd('FileType', {
                callback = function(args)
                    if not vim.list_contains(
                        treesitter.get_installed(),
                        vim.treesitter.language.get_lang(args.match)
                    ) and vim.list_contains(
                        treesitter.get_available(),
                        vim.treesitter.language.get_lang(args.match)
                    ) then
                        vim.schedule(function () 
                            treesitter.install(vim.treesitter.language.get_lang(args.match), { summary = true })
                        end)
                    end
                end,
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = "main",
        event = "VeryLazy",
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    {
        "nvim-mini/mini.ai",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({ -- code block
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
                    d = { "%f[%d]%d+" }, -- digits
                    e = { -- Word with case
                        { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
                        "^().*()$",
                    },
                    u = ai.gen_spec.function_call(), -- u for "Usage"
                    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
                },
            }
        end,
    }
}
