require('oil').setup({
    cleanup_delay_ms = 0,
    watch_for_changes = true,
    default_file_explorer = true,
    lsp_file_methods = {
        timeout_ms = 5000,
        autosave_changes = true,
    },
})

vim.keymap.set('n', '<Leader>o-', '<CMD>Oil<CR>', {})

-- oil rename integration
vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
        if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
    end,
})
