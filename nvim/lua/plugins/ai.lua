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
            config = vim.fn.expand("~/dotfiles/mcphub/servers.json"),
            extensions = {
                copilotchat = {
                    enabled = true,
                    convert_tools_to_functions = true, -- Convert MCP tools to CopilotChat functions
                    convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
                    add_mcp_prefix = false,        -- Add "mcp_" prefix to function names
                }
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
    },
    {
        "olimorris/codecompanion.nvim",
        opts = {
            strategies = {
                chat = {
                    adapter = "copilot",
                }
            },
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        -- MCP Tools
                        make_tools = true,                    -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
                        show_server_tools_in_chat = true,     -- Show individual tools in chat completion (when make_tools=true)
                        add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
                        show_result_in_chat = true,           -- Show tool results directly in chat buffer
                        format_tool = nil,                    -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
                        -- MCP Resources
                        make_vars = true,                     -- Convert MCP resources to #variables for prompts
                        -- MCP Prompts
                        make_slash_commands = true,           -- Add MCP prompts as /slash commands
                    }
                }
            }
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
