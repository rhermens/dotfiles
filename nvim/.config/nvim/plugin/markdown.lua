require('render-markdown').setup({
    latex = {
        enabled = true,
        render_modes = false,
        converter = { 'latex2text' },
        inline = true,
        block = true,
        highlight = 'RenderMarkdownMath',
        position = 'center',
        top_pad = 0,
        bottom_pad = 0,
    },
})
