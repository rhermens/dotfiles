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

vim.cmd([[ colorscheme tokyonight-storm ]])

require('mini.icons').setup({})
