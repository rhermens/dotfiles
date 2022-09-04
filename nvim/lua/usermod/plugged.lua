
local Plug = vim.fn['plug#']
vim.call('plug#begin')

-- Theme
Plug 'tomasiser/vim-code-dark'
-- Status bar
Plug 'vim-airline/vim-airline'
-- :Git
Plug 'tpope/vim-fugitive'
-- gc commenting
Plug 'tpope/vim-commentary'

-- File extension icons (coc-explorer)
Plug 'ryanoasis/vim-devicons'

-- Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

-- Tab lines
Plug 'Yggdroot/indentLine'

-- Bracket pairs ed
Plug 'jiangmiao/auto-pairs'

-- EditorConfig
Plug 'gpanders/editorconfig.nvim'

-- LSP
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

-- <Leader> b tree
Plug('ms-jpq/chadtree', { branch = 'chad', ['do'] = 'python3 -m chadtree deps', on = { 'CHADopen' } })
-- This is the way
-- Plug 'github/copilot.vim'
-- Syntax tree hightlighting
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = 'TSUpdate' })

vim.call('plug#end')
