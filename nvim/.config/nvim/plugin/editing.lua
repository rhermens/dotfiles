require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.comment').setup()
require('mini.move').setup()
require('mini.hipatterns').setup({
    highlighters = { hex_color = require('mini.hipatterns').gen_highlighter.hex_color() },
})
