local dap = require('dap')

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
            type = 'test',
            request = 'launch',
            name = "Test",
            cwd = "${workspaceFolder}",
        },
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
