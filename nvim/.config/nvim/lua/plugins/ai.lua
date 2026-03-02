return {
    {
        'github/copilot.vim',
        init = function()
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_node_command = "/home/roy/.asdf/shims/node"
            vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
        end,
    },
    {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "bundled_build.lua",
        opts = {
            use_bundled_binary = true,
            extensions = {
                copilotchat = {
                    enabled = true,
                    convert_tools_to_functions = true,     -- Convert MCP tools to CopilotChat functions
                    convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
                    add_mcp_prefix = false,                -- Add "mcp_" prefix to function names
                }
            },
            global_env = {
                "GITHUB_TOKEN",
            },
        },
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {
            -- See Configuration section for options
        },
    }
}
