
local set = vim.opt

set.encoding = 'utf-8'
set.fileformats = 'unix,dos'
-- set.path:append('**')
set.title = true
set.errorbells = false
set.termguicolors = true

set.expandtab = true
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.smartindent = true

set.relativenumber = true
set.number = true

set.splitright = true

set.wrap = false
set.list = true
set.listchars = 'tab:▸ ,trail:·'
set.signcolumn = 'yes'
set.completeopt = 'menu,menuone,noselect'

set.scrolloff = 8
set.sidescrolloff = 8

set.hidden = true
set.swapfile = false
set.backup = false
set.writebackup = false

set.cmdheight = 1
set.updatetime = 300
set.shortmess:append({ c = true })

set.incsearch = true
set.hlsearch = false
set.ignorecase = true
set.smartcase = true

set.shell = "/usr/bin/zsh"
-- set.t_Co = 256
-- set.t_ut = nil
vim.g.mapleader = ' '



-- colorscheme codedark
-- colorscheme toykonight
vim.cmd [[
    colorscheme tokyonight
]]

