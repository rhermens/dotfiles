
local Plug = vim.fn['plug#']
vim.call('plug#begin')

-- Syntax tree hightlighting
Plug 'nvim-treesitter/nvim-treesitter'

-- Theme
Plug('folke/tokyonight.nvim', { branch = 'main' })

-- Status bar
Plug 'nvim-lualine/lualine.nvim'

-- :Git
Plug 'tpope/vim-fugitive'
-- gc commenting
Plug 'tpope/vim-commentary'

-- File extension icons (coc-explorer)
Plug 'ryanoasis/vim-devicons'

-- Fuzzy finder
-- Plug 'junegunn/fzf'
-- Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })

-- Buffer tabs
Plug('akinsho/bufferline.nvim', { tag = 'v2.*' })

-- Tab lines
Plug 'lukas-reineke/indent-blankline.nvim'

-- Scrollbar
Plug 'petertriho/nvim-scrollbar'

-- Bracket pairs ed
-- Plug 'jiangmiao/auto-pairs'
Plug 'windwp/nvim-autopairs'

-- EditorConfig
Plug 'gpanders/editorconfig.nvim'

-- LSP
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

-- DAP (Debug adapter protocol)
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'

-- <Leader> b tree
Plug('ms-jpq/chadtree', { branch = 'chad', ['do'] = 'python3 -m chadtree deps' })
-- This is the way
Plug 'github/copilot.vim'

vim.call('plug#end')
