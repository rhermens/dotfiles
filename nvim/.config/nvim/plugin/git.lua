require('gitsigns').setup({
    signcolumn = false,
})

local function show_entry_path()
    local view = require('diffview.lib').get_current_view()
    local item = view and view.panel:get_item_at_cursor()
    if not item then return end
    vim.lsp.util.open_floating_preview({ item.path }, 'text', { border = 'rounded' })
end

require('diffview').setup({
    file_panel = {
        win_config = {
            position = 'right',
            width = 50
        }
    },
    keymaps = {
        file_panel = {
            { 'n', 'K', show_entry_path, { desc = 'Show the full path of the entry' } },
        },
    },
})

vim.api.nvim_create_user_command('DiffDevelop', function()
    vim.cmd('DiffviewOpen origin/develop...HEAD --imply-local')
end, { desc = 'Compare with origin/develop, including local changes' })
