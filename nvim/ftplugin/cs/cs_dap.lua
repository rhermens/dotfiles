require('mason-nvim-dap').setup({
    handlers = {
        coreclr = function(config)
            config.adapters.coreclr = {
                type = 'executable',
                command = 'netcoredbg',
                args = {'--interpreter=vscode'},
            }
            config.configurations.cs = {
                {
                    type = "coreclr",
                    name = "Attach - netcodedbg",
                    request = "attach",
                    mode = "local",
                    processId = require('dap.utils').pick_process
                },
                {
                    type = "coreclr",
                    name = "Launch - netcodedbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                    end,
                }
            }
            require('mason-nvim-dap').default_setup(config)
        end
    }
})
