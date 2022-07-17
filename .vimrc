"    ___  __ __
"   / _ \/ // /
"  / , _/ _  /
" /_/|_/_//_/
"
"General
set encoding=utf-8
set fileformats=unix,dos
set path+=**
set title
set expandtab
set noerrorbells
set shiftwidth=4
set tabstop=4
set softtabstop=4
set relativenumber
set number
set termguicolors
set nowrap
set title
set splitright
set list
set listchars=tab:▸\ ,trail:·
set scrolloff=8
set sidescrolloff=8
set hidden
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set completeopt=menu,menuone,noselect

set noswapfile
set nobackup
set nowritebackup

set incsearch
set nohlsearch
set ignorecase
set smartcase

"Plugins
call plug#begin('~/.vim/plugged')

"Theme
Plug 'tomasiser/vim-code-dark'
"Status bar
Plug 'vim-airline/vim-airline'
" :Git
Plug 'tpope/vim-fugitive'
"gc commenting
Plug 'tpope/vim-commentary'

"File extension icons (coc-explorer)
Plug 'ryanoasis/vim-devicons'

"Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

"Bracket pairs ed
Plug 'jiangmiao/auto-pairs'

"Todo: Replace with LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Syntax hightlighting, should LSP replace?
Plug 'sheerun/vim-polyglot'

call plug#end()

"Colors
set t_Co=256
set t_ut=
colorscheme codedark
let mapleader = ' '

if !exists('g:vscode')
    source ~/.vim/fzf.vim
    source ~/.vim/coc.vim
    source ~/.vim/coc-explorer.vim
endif

nnoremap Y yy

"System clipboard
vmap <C-c> "+y
vmap <C-x> "+c
imap <C-v> <ESC>"+pa
nmap <C-v> "+p

autocmd BufWritePre * :%s/\s\+$//e

