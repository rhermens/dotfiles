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
