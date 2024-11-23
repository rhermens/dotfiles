return {
    {
        'stevearc/oil.nvim',
        opts = {
            default_file_explorer = true,
        },
        init = function ()
            vim.keymap.set('n', '<Leader>b', '<CMD>Oil<CR>', {})
        end,
    }
}
