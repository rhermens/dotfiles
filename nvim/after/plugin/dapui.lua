local dap, dapui = require('dap'), require('dapui')

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
    require('nvim-tree.api').tree.close()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    require('nvim-tree.api').tree.open()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
    require('nvim-tree.api').tree.open()
end
