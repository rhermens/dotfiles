local telescope = require('telescope')

telescope.setup {
    extensions = {
        file_browser = {
            hijack_netrw = true,
        }
    }
}

telescope.load_extension('file_browser')

vim.keymap.set('n', '<Leader>b', function () telescope.extensions.file_browser.file_browser({ path = "%:p:h", select_buffer = true }) end, {})
