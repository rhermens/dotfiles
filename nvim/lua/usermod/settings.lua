
local set = vim.opt

set.encoding = 'utf-8'
set.fileformats = 'unix,dos'
set.path:append('**')
set.title= true
set.expandtab = true
set.errorbells = false
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.relativenumber = true
set.number = true
set.termguicolors = true
set.wrap= false
set.splitright = true
set.list = true
set.listchars = 'tab:▸ ,trail:·'
set.scrolloff = 8
set.sidescrolloff = 8
set.hidden = true
set.cmdheight = 2
set.updatetime = 300
set.shortmess:append({ c = true })
set.signcolumn = 'yes'
set.completeopt = 'menu,menuone,noselect'

set.swapfile = false
set.backup = false
set.writebackup = false

set.incsearch = true
set.hlsearch = false
set.ignorecase = true
set.smartcase = true


-- set.t_Co = 256
-- set.t_ut = nil
vim.g.mapleader = ' '

vim.cmd [[
    colorscheme codedark
]]
