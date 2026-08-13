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


local spider = require('spider')

spider.setup({})
vim.keymap.set({ "n", "o", "x" }, "w", function()
    spider.motion('w')
end)
vim.keymap.set({ "n", "o", "x" }, "e", function()
    spider.motion('e')
end)
vim.keymap.set({ "n", "o", "x" }, "b", function()
    spider.motion('b')
end)
vim.keymap.set({ "n", "o", "x" }, "ge", function()
    spider.motion('ge')
end)
