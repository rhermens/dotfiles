vim.g.copilot_node_command = "/home/roy/.nvm/versions/node/v16.18.1/bin/node"
vim.g.copilot_no_tab_map = true


vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
