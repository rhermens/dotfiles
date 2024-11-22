-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { 'folke/tokyonight.nvim', lazy = false },
        {
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
        },

        -- Git
        { 'tpope/vim-fugitive' },
        { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },

        -- Text
        { 'tpope/vim-commentary' },
        { 'windwp/nvim-autopairs' },
        { 'tpope/vim-surround' },

        -- Notes
        { 'epwalsh/obsidian.nvim', dependencies = 'nvim-lua/plenary.nvim' },
        {
            'nvim-telescope/telescope.nvim',
            dependencies = 'nvim-lua/plenary.nvim',
            branch = '0.1.x',
        },

        -- File Management
        {
            'stevearc/oil.nvim',
        },

        -- UI
        {
            'akinsho/bufferline.nvim',
            version = '*',
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = 'nvim-tree/nvim-web-devicons'
        },
        { 'lukas-reineke/indent-blankline.nvim' },
        { 'petertriho/nvim-scrollbar' },

        -- History
        { 'mbbill/undotree' },

        -- Dev
        { 'gpanders/editorconfig.nvim' },
        -- LSP
        { 'neovim/nvim-lspconfig' },
        { 'arkav/lualine-lsp-progress' },
        { 'Hoffs/omnisharp-extended-lsp.nvim', ft = 'cs' },
        -- CMP
        { 'hrsh7th/nvim-cmp' },
        { 'L3MON4D3/LuaSnip' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'FelipeLema/cmp-async-path' },
        -- Installer
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },
        -- Lint
        { 'mfussenegger/nvim-lint' },
        { 'rshkarin/mason-nvim-lint' },

        -- This is the way
        { 'github/copilot.vim' },
    },

    install = { colorscheme = { "tokyonight" } },
    checker = { enabled = true },
})
