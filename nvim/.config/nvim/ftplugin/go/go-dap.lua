-- dap-go
require('dap-go').setup({
    delve = {
        path = vim.fn.stdpath('data') .. "/mason/bin/dlv",
    },
})
