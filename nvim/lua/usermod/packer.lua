require('packer').startup(function (use)
    use 'wbthomason/packer.nvim'

    -- Profiler
    use 'dstein64/vim-startuptime'

    -- Syntax tree hightlighting
    use { 'nvim-treesitter/nvim-treesitter' }

    -- Theme
    use {'folke/tokyonight.nvim', branch = 'main' }

    -- Status bar
    use 'nvim-lualine/lualine.nvim'

    -- :Git
    use 'tpope/vim-fugitive'
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- gc commenting
    use 'tpope/vim-commentary'

    -- File extension icons (coc-explorer)
    use 'ryanoasis/vim-devicons'
    use 'nvim-tree/nvim-web-devicons'

    -- Fuzzy finder
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' }}

    -- Buffer tabs
    use { 'akinsho/bufferline.nvim', tag = 'v2.*' }

    -- Tab lines
    use 'lukas-reineke/indent-blankline.nvim'

    -- Scrollbar
    use 'petertriho/nvim-scrollbar'

    -- Bracket pairs ed
    use 'windwp/nvim-autopairs'

    -- EditorConfig
    use 'gpanders/editorconfig.nvim'

    -- C#
    use { 'Hoffs/omnisharp-extended-lsp.nvim', ft = { 'cs' } }

    -- LSP
    use 'neovim/nvim-lspconfig'
    -- -- Snip
    use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/vim-vsnip'} }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'FelipeLema/cmp-async-path'
    
    -- -- Mason
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    -- DAP (Debug adapter protocol)
    use 'mfussenegger/nvim-dap'
    use 'jay-babu/mason-nvim-dap.nvim'
    use 'rcarriga/nvim-dap-ui'

    -- <Leader> b tree
    use { 'nvim-tree/nvim-tree.lua' }

    -- This is the way
    use 'github/copilot.vim'
end)
