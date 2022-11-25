require('usermod.airline')
require('usermod.plugged')
require('usermod.settings')
require('usermod.keymaps')

if vim.g.vscode == nil then
    require('usermod.fzf')
    -- require('usermod.telescope')
    require("usermod.lsp")
    require("usermod.treesitter")
    require("usermod.chadtree")
    require("usermod.lualine")
    require("usermod.bufferline")
    require("usermod.scrollbar")
    require("usermod.copilot")
    require("usermod.chromeshell")
    -- require("usermod.dap")
end
