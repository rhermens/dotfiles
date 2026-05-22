vim.pack.add({
    -- colorscheme
    'https://github.com/folke/tokyonight.nvim',
    'https://github.com/rose-pine/neovim',

    -- lib - dev
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/nvim-neotest/nvim-nio',

    -- tmux
    'https://github.com/vimpostor/vim-tpipeline',

    -- packs
    'https://github.com/folke/snacks.nvim',
    'https://github.com/nvim-mini/mini.nvim',

    -- dap
    'https://github.com/mfussenegger/nvim-dap',
    'https://github.com/leoluz/nvim-dap-go',
    'https://github.com/jay-babu/mason-nvim-dap.nvim',
    'https://github.com/rcarriga/nvim-dap-ui',
    'https://github.com/theHamsta/nvim-dap-virtual-text',

    -- git
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/sindrets/diffview.nvim',

    -- http
    'https://github.com/mistweaverco/kulala.nvim',

    -- lint
    'https://github.com/mfussenegger/nvim-lint',

    -- lsp
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/saghen/blink.lib',
    { src = 'https://github.com/saghen/blink.cmp', version = 'v1' },

    -- markdown
    'https://github.com/iamcco/markdown-preview.nvim',

    -- file explorer
    'https://github.com/stevearc/oil.nvim',

    -- test
    'https://github.com/nvim-neotest/neotest',
    'https://github.com/nvim-neotest/neotest-plenary',
    'https://github.com/nvim-neotest/neotest-jest',
    'https://github.com/fredrikaverpil/neotest-golang',

    -- treesitter
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
})

vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update();
end, {})

vim.api.nvim_create_user_command('PackClean', function()
    local inactive = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()
    vim.pack.del(inactive)
end, {})
