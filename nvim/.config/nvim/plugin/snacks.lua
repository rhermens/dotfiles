vim.g.snacks_animate = false

require('snacks').setup({
    bigfile = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = {
        enabled = true,
        left = { 'mark', 'sign' }
    }
})
