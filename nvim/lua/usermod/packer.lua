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
    use 'tpope/vim-surround'

    -- <Leader> b tree
    use { 'nvim-tree/nvim-tree.lua' }

    -- Undo tree
    use { 'mbbill/undotree' }

    -- EditorConfig
    use 'gpanders/editorconfig.nvim'

    -- C#
    use { 'Hoffs/omnisharp-extended-lsp.nvim', ft = { 'cs' } }

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'arkav/lualine-lsp-progress'
    use { 'VonHeikemen/lsp-zero.nvim', requires = {
        'neovim/nvim-lspconfig',
        -- CMP
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
        'hrsh7th/cmp-nvim-lsp',
        'FelipeLema/cmp-async-path',
        -- Installer
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim'
    } }

    -- Lint
    use 'mfussenegger/nvim-lint'

    -- DAP (Debug adapter protocol)
    use { 'mfussenegger/nvim-dap', requires = {
        'jay-babu/mason-nvim-dap.nvim',
        'rcarriga/nvim-dap-ui',
        'mxsdev/nvim-dap-vscode-js'
    } }

    -- This is the way
    use 'github/copilot.vim'
end)
