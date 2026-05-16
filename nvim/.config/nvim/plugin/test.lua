require('neotest').setup({
    adapters = {
        require('neotest-jest')({
            jestCommand = function(path)
                if string.find(path, "e2e-spec", 0, true) or string.find(path, "e2e-test", 0, true) then
                    return "npm run test:e2e --"
                end
                return "npm run test --"
            end,
            jestArguments = function(defaultArguments, _)
                table.remove(defaultArguments, 1)
                return defaultArguments
            end,
        }),
        require('neotest-golang')({
            runner = "gotestsum",
        }),
    },
})

vim.keymap.set('n', '<leader>ta', function() require('neotest').run.attach() end, { desc = "Attach to Test (Neotest)" })
vim.keymap.set('n', '<leader>tt', function() require('neotest').run.run(vim.fn.expand('%')) end,
    { desc = "Run File (Neotest)" })
vim.keymap.set('n', '<leader>tT', function() require('neotest').run.run(vim.uv.cwd()) end,
    { desc = "Run All Test Files (Neotest)" })
vim.keymap.set('n', '<leader>tr', function() require('neotest').run.run() end, { desc = "Run Nearest (Neotest)" })
vim.keymap.set('n', '<leader>tl', function() require('neotest').run.run_last() end, { desc = "Run Last (Neotest)" })
vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end,
    { desc = "Toggle Summary (Neotest)" })
vim.keymap.set('n', '<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end,
    { desc = "Show Output (Neotest)" })
vim.keymap.set('n', '<leader>tO', function() require('neotest').output_panel.toggle() end,
    { desc = "Toggle Output Panel (Neotest)" })
vim.keymap.set('n', '<leader>tS', function() require('neotest').run.stop() end, { desc = "Stop (Neotest)" })
vim.keymap.set('n', '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end,
    { desc = "Toggle Watch (Neotest)" })
