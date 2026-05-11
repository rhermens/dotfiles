local treesitter = require('nvim-treesitter')

treesitter.setup({
    indent = {
        enable = true
    },
    highlight = {
        enable = true,
    },
})

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
            vim.schedule(function()
                treesitter.install(vim.treesitter.language.get_lang(args.match), { summary = true })
            end)
        end
    end,
})

-- mini.ai
local ai = require('mini.ai')
ai.setup({
    n_lines = 500,
    custom_textobjects = {
        o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        d = { "%f[%d]%d+" },
        e = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
        },
        u = ai.gen_spec.function_call(),
        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
    },
})
