-- require("nvim-tree").setup{
--     update_focused_file = {
--         enable = true
--     },
--     on_attach = function (bufnr)
--         local api = require('nvim-tree.api')
--         vim.keymap.set('n', '<C-g>', function () 
--             local search_dir;
--             local node = require('nvim-tree.lib').get_node_at_cursor()

--             if not node or node.type == 'file' or node.absolute_path == nil then
--                 search_dir = vim.fn.getcwd()
--             else
--                 search_dir = node.absolute_path
--             end

--             require('telescope.builtin').live_grep({
--                 search_dirs = { search_dir },
--                 prompt_title = "Grep at " .. search_dir,
--             })
--         end)

--         api.config.mappings.default_on_attach(bufnr)
--     end
-- }

-- vim.keymap.set('n', '<Leader>b', ':NvimTreeFocus<CR>', { silent = true })

-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = function (data) 
--     require('nvim-tree.api').tree.open()
-- end })

