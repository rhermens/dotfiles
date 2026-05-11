require('oil').setup({
    cleanup_delay_ms = 0,
    watch_for_changes = true,
    default_file_explorer = true,
    lsp_file_methods = {
        timeout_ms = 5000,
        autosave_changes = true,
    },
})

vim.keymap.set('n', '<Leader>b', '<CMD>Oil<CR>', {})
