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
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- gc commenting
    use 'tpope/vim-commentary'

    -- File extension icons (coc-explorer)
    use 'ryanoasis/vim-devicons'
    use 'nvim-tree/nvim-web-devicons'

    -- Obsidian
    use { 'epwalsh/obsidian.nvim', tag = "*", requires = { 'nvim-lua/plenary.nvim' }}

    -- Fuzzy finder
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' }} 

    -- File browser
    use 'stevearc/oil.nvim'

    -- Buffer tabs
    use { 'akinsho/bufferline.nvim', tag = '*' }

    -- Tab lines
    use 'lukas-reineke/indent-blankline.nvim'

    -- Scrollbar
    use 'petertriho/nvim-scrollbar'

    -- Bracket pairs ed
    use 'windwp/nvim-autopairs'
    use 'tpope/vim-surround'

    -- Undo tree
    use { 'mbbill/undotree' }

    -- EditorConfig
    use 'gpanders/editorconfig.nvim'

    -- C#
    use { 'Hoffs/omnisharp-extended-lsp.nvim', ft = { 'cs' } }

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'arkav/lualine-lsp-progress'

    -- CMP
    use 'hrsh7th/nvim-cmp'
    use 'L3MON4D3/LuaSnip'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'FelipeLema/cmp-async-path'

    -- Installer
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    -- Lint
    use 'mfussenegger/nvim-lint'

    -- This is the way
    use 'github/copilot.vim'
end)
