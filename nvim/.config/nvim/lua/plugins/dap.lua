local register_pwa_node = function(dap)
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
end

return {
    {
        'leoluz/nvim-dap-go',
        opts = {
            delve = {
                path = vim.fn.stdpath('data') .. "/mason/bin/dlv",
            },
        },
    },
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'jay-babu/mason-nvim-dap.nvim',
            'rcarriga/nvim-dap-ui',
            {
                'theHamsta/nvim-dap-virtual-text',
                opts = {},
            },
        },
        config = function()
            local dap = require('dap')
            register_pwa_node(dap)

            vim.keymap.set('n', '<leader>k', function()
                require('dapui').eval(nil, { enter = true })
            end)
            vim.keymap.set('n', '<F5>', dap.continue)
            vim.keymap.set('n', '<F6>', dap.step_into)
            vim.keymap.set('n', '<F7>', dap.step_over)
            vim.keymap.set('n', '<F8>', dap.step_out)
            vim.keymap.set('n', '<F9>', dap.step_back)
            vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)

            local vscode = require('dap.ext.vscode')
            local json = require('plenary.json')
            vscode.json_decode = function(str)
                return vim.json.decode(json.json_strip_comments(str))
            end
        end,
    },
    {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = {
            'mason-org/mason.nvim',
        },
        opts = {
            automatic_install = true,
            handlers = {
                function(config)
                    require('mason-nvim-dap').default_setup(config)
                end
            }
        }
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            'nvim-neotest/nvim-nio',
        },
        config = function(_, opts)
            local dap = require('dap')
            local dapui = require('dapui')

            dapui.setup(opts)

            vim.keymap.set('n', '<F12>', dapui.toggle)

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
        end,
    }
}
