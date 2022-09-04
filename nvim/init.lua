require('usermod.airline')
require('usermod.plugged')
require('usermod.settings')
require('usermod.keymaps')

if vim.g.vscode == nil then
    require('usermod.fzf')
    require("usermod.lsp")
    require("usermod.treesitter")
    require("usermod.chadtree")
end
