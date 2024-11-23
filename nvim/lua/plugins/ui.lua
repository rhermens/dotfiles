return {
    {
        'petertriho/nvim-scrollbar',
        config = true
    },
    {
        'lukas-reineke/indent-blankline.nvim',
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
