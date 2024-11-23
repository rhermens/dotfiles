return {
    { 'tpope/vim-commentary' },
    { 'tpope/vim-surround' },
    {
        'windwp/nvim-autopairs',
        config = true,
        dependencies = { 'hrsh7th/nvim-cmp' },
        init = function ()
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')

            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
    },
    { 'gpanders/editorconfig.nvim' },
}




