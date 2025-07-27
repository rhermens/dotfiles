return {
    {
        'petertriho/nvim-scrollbar',
        enabled = false,
        config = true
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        enabled = false,
        main = 'ibl',
        opts = {
            indent = {
                char = '▏',
            },
            scope = {
                enabled = false,
            }
        }
    },
    {
        'akinsho/bufferline.nvim',
        version = '*',
        opts = {
            options = {
                numbers = "buffer_id"
            }
        }
    }
}
