vim.opt.background = "dark"

require('tokyonight').setup({
    transparent = true,
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
