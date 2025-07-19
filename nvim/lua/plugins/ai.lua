return {
    {
        'github/copilot.vim',
        init = function ()
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_node_command = "/home/roy/.asdf/shims/node"
            vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
        end,
    },
    {
        'yetone/avante.nvim',
        build = function ()
            return "make"
        end,
        opts = {
            provider = 'copilot',
            behaviour = {
                auto_suggestions = false,
            },
            hints = {
                enabled = false,
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
    },
}
