local telescope = require('telescope')

telescope.setup {
    extensions = {
        file_browser = {
            hijack_netrw = true,
        }
    }
}

telescope.load_extension('file_browser')

vim.keymap.set('n', '<Leader>b', telescope.extensions.file_browser.file_browser, {})
