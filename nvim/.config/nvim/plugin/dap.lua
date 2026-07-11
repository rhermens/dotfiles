local dap = require('dap')
-- local dapui = require('dapui')
local dapview = require('dap-view')

-- mason-nvim-dap
require('mason-nvim-dap').setup({
    automatic_install = true,
    handlers = {
        function(config)
            require('mason-nvim-dap').default_setup(config)
        end
    }
})

dapview.setup({
    virtual_text = {
        enabled = true,
    }
})

vim.keymap.set('n', '<F12>', dapview.toggle)

-- vscode launch.json support
local vscode = require('dap.ext.vscode')
local json = require('plenary.json')
vscode.json_decode = function(str)
    return vim.json.decode(json.json_strip_comments(str))
end

-- keymaps
vim.keymap.set('n', '<leader>k', function()
    dapview.hover(nil, true, nil)
end)
vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F10>', function() require('neotest').run.run({ strategy = 'dap' }) end)
vim.keymap.set('n', '<F6>', dap.step_into)
vim.keymap.set('n', '<F7>', dap.step_over)
vim.keymap.set('n', '<F8>', dap.step_out)
vim.keymap.set('n', '<F9>', dap.step_back)
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
