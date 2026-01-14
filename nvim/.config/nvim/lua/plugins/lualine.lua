return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
            { 'arkav/lualine-lsp-progress' },
            {
                "letieu/harpoon-lualine",
                dependencies = {
                    {
                        "ThePrimeagen/harpoon",
                        branch = "harpoon2",
                    }
                },
            }
        },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '|', right = '|'},
                section_separators = { left = ' ', right = ' '},
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = { "CHADTree" },
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = {},
                lualine_b = {'branch', 'diagnostics'},
                lualine_c = {
                    {
                        "harpoon2"
                    },
                    {
                        'filename',
                        path = 1,
                    },
                },
                lualine_x = {
                    'filetype',
                    'diff',
                    'lsp_progress'
                },
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
            theme = 'tokyonight'
        }
    }
}
