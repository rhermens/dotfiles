local dap = require('dap')
local dapui = require('dapui')

-- pwa-node adapter
dap.adapters['pwa-node'] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = vim.fn.stdpath('data') .. "/mason/bin/js-debug-adapter",
        args = { "${port}" }
    },
}

for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
        {
            type = "pwa-node",
            request = "attach",
            name = "Auto Attach",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Run npm launch script",
            console = "integratedTerminal",
            runtimeExecutable = "npm",
            runtimeArgs = function()
                local co = coroutine.running()
                local res = {
                    "run",
                }

                vim.ui.input({ prompt = "script" }, function(i)
                    coroutine.resume(co, i)
                end)
                local input = coroutine.yield()

                if not input or input == "" then
                    return dap.ABORT
                end

                for p in string.gmatch(input, "([^ ]+)") do
                    table.insert(res, p)
                end
                return res
            end,
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach to node process",
            processId = function()
                local pid = dap.utils.pick_process({ filter = "node" })
                return (pid and pid ~= "") and pid or dap.ABORT
            end,
            cwd = "${workspaceFolder}",
        },
    }
end

-- dap-go
require('dap-go').setup({
    delve = {
        path = vim.fn.stdpath('data') .. "/mason/bin/dlv",
    },
})

-- mason-nvim-dap
require('mason-nvim-dap').setup({
    automatic_install = true,
    handlers = {
        function(config)
            require('mason-nvim-dap').default_setup(config)
        end
    }
})

-- dap-virtual-text
require('nvim-dap-virtual-text').setup({})

-- dap-ui
dapui.setup({})

vim.keymap.set('n', '<F12>', dapui.toggle)

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
end

-- vscode launch.json support
local vscode = require('dap.ext.vscode')
local json = require('plenary.json')
vscode.json_decode = function(str)
    return vim.json.decode(json.json_strip_comments(str))
end

-- keymaps
vim.keymap.set('n', '<leader>k', function()
    dapui.eval(nil, { enter = true })
end)
vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F10>', function() require('neotest').run.run({ strategy = 'dap' }) end)
vim.keymap.set('n', '<F6>', dap.step_into)
vim.keymap.set('n', '<F7>', dap.step_over)
vim.keymap.set('n', '<F8>', dap.step_out)
vim.keymap.set('n', '<F9>', dap.step_back)
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
