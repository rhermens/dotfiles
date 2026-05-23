vim.opt.background = "dark"

require('tokyonight').setup({
    styles = {
        comments = {
            italic = false,
        },
        keywords = {
            italic = false,
        },
    }
})

vim.cmd([[ colorscheme tokyonight-night ]])

require('mini.icons').setup({})
