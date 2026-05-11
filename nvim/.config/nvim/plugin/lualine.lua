require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = ' ', right = ' ' },
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
        lualine_b = { 'branch', 'diagnostics' },
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
            'diff',
        },
        lualine_y = {
            {
                'lsp_status',
                ignore_lsp = {
                    ''
                },
            }
        },
        lualine_z = {}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
    theme = 'tokyonight'
})
