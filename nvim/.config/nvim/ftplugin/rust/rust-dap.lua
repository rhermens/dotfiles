local dap = require('dap')

-- Provided by pkgs.lldb.
dap.adapters.lldb = {
    type = "executable",
    command = "lldb-dap",
    name = "lldb",
}

dap.configurations.rust = {
    {
        type = "lldb",
        request = "launch",
        name = "Launch Rust executable",
        program = function()
            local path = vim.fn.input({
                prompt = "Path to executable: ",
                default = vim.fn.getcwd() .. "/target/debug/",
                completion = "file",
            })
            return (path and path ~= "") and path or dap.ABORT
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
    },
    {
        type = "lldb",
        request = "attach",
        name = "Attach to Rust process",
        pid = function()
            local pid = dap.utils.pick_process()
            return pid or dap.ABORT
        end,
        cwd = "${workspaceFolder}",
    },
}
