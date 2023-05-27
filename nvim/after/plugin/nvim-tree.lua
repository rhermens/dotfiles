require("nvim-tree").setup({
    on_attach = function (bufnr)
        local api = require('nvim-tree.api')

        vim.keymap.set('n', '<C-g>', function () 
            local node = require('nvim-tree.lib').get_node_at_cursor()
            if not node then return end

            require('telescope.builtin').live_grep({
                search_dirs = { node.absolute_path },
                prompt_title = "Grep at " .. node.absolute_path,
            })
        end)

        api.config.mappings.default_on_attach(bufnr)
    end
})

vim.keymap.set('n', '<Leader>b', ':NvimTreeFocus<CR>', { silent = true })
