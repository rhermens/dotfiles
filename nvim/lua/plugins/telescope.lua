
local project_files = function()
    local is_modules = vim.fn.filereadable(vim.fn.getcwd() .. '/.gitmodules') == 1
    local is_git = vim.fn.isdirectory(vim.fn.getcwd() .. '/.git') == 1

    if is_git and not is_modules then
        return require("telescope.builtin").git_files()
    else
        return require("telescope.builtin").find_files()
    end
end


return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        branch = '0.1.x',
        opts = {
            pickers = {
                git_files = {
                    use_git_root = false,
                    show_untracked = true,
                }
            }
        },
        init = function ()
            local builtin = require("telescope.builtin")

            vim.keymap.set('n', '<Leader>p', builtin.builtin, {})
            vim.keymap.set('n', '<Leader>d', builtin.diagnostics, {})
            vim.keymap.set('n', '<Leader>s', builtin.lsp_document_symbols, {})
            vim.keymap.set('n', '<Leader>c', builtin.commands, {})
            vim.keymap.set('n', '<Leader>m', builtin.marks, {})
            vim.keymap.set('n', '<Leader>j', builtin.jumplist, {})
            vim.keymap.set('n', '<C-Space>', builtin.buffers, {})
            vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
            vim.keymap.set('n', '<C-p>', project_files, {})
            vim.keymap.set('n', 'fh', builtin.help_tags, {})
            vim.keymap.set('n', '<Leader>gs', builtin.git_status, {})

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, opts)
                    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
                    vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, opts)
                    vim.keymap.set('n', 'go', require('telescope.builtin').lsp_type_definitions, opts)

                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)

                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', function () vim.lsp.buf.format({ async = true }) end, opts)
                    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
                end
            })
        end,
    }
}
