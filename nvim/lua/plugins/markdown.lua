return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter'
        },
        opts = function () 
            return {
                latex = {
                    enabled = true,
                    render_modes = false,
                    converter = 'latex2text',
                    highlight = 'RenderMarkdownMath',
                    position = 'above',
                    top_pad = 0,
                    bottom_pad = 0,
                }
            }
        end,
    }
}
