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
        {
            'folke/tokyonight.nvim',
            lazy = false,
            priority = 1000,
            config = function ()
                vim.cmd [[
                    colorscheme tokyonight-storm
                ]]
            end,
        },
        -- {
        --     'sainnhe/everforest',
        --     lazy = false,
        --     priority = 1000,
        --     config = function ()
        --         vim.g.everforest_background = "medium"
        --         vim.cmd [[
        --             colorscheme everforest
        --         ]]
        --     end,
        -- },
        { import = "plugins" },
    },
    install = { colorscheme = { "tokyonight" } },
    -- install = { colorscheme = { "everforest" } },
    checker = { enabled = true },
})
