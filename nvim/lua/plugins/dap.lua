local register_pwa_node = function (dap)
    dap.adapters['pwa-node'] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            args = {
                vim.fn.stdpath('data') .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                "${port}",
            },
        },
    }

    for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {{
            type = "pwa-node",
            request = "attach",
            name = "Attach to node process",
            processId = function () require'dap.utils'.pick_process({ filter = "node" }) end,
            cwd = "${workspaceFolder}",
        }}
    end
end

return {
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
        config = function ()
            local dap = require('dap')
            register_pwa_node(dap)

            vim.keymap.set('n', '<leader>k', function ()
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
            vscode.json_decode = function (str) 
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
                function (config)
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
        config = function (_, opts)
            local dap = require('dap')
            local dapui = require('dapui')

            dapui.setup(opts)

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close({})
            end
        end,
    }
}
