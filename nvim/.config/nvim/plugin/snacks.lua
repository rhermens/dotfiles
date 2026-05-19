vim.g.snacks_animate = false

require('snacks').setup({
    bigfile = { enabled = true },
    indent = {
        enabled = true,
        indent = {
            char = '▏',
        },
        scope = { enabled = false },
    },
    input = { enabled = true },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = {
        enabled = true,
    },
    words = { enabled = true },
    statuscolumn = {
        enabled = true,
        left = { 'mark', 'sign' }
    }
})
