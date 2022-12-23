require('packer').startup(function (use)
    use 'wbthomason/packer.nvim'

    -- Syntax tree hightlighting
    use { 'nvim-treesitter/nvim-treesitter' }

    -- Theme
    use {'folke/tokyonight.nvim', branch = 'main' }

    -- Status bar
    use 'nvim-lualine/lualine.nvim'

    -- :Git
    use 'tpope/vim-fugitive'
    -- gc commenting
    use 'tpope/vim-commentary'

    -- File extension icons (coc-explorer)
    use 'ryanoasis/vim-devicons'

    -- Fuzzy finder
    -- Plug 'junegunn/fzf'
    -- Plug 'junegunn/fzf.vim'
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

    -- LSP
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'

    -- DAP (Debug adapter protocol)
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'

    -- <Leader> b tree
    use { 'ms-jpq/chadtree', branch = 'chad', run = 'python3 -m chadtree deps' }
    -- This is the way
    use 'github/copilot.vim'
end)
