return {
    {
        'stevearc/oil.nvim',
        opts = {
            default_file_explorer = true,
            lsp_file_methods = {
                timeout_ms = 5000,
                autosave_changes = true,
            },
        },
        init = function ()
            vim.keymap.set('n', '<Leader>b', '<CMD>Oil<CR>', {})
        end,
    }
}
