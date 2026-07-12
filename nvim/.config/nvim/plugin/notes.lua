require('obsidian').setup({
    legacy_commands = false,
    ui = {
        enable = false,
    },
    picker = {
        name = 'snacks.picker'
    },
    workspaces = {
        {
            name = "notes",
            path = "~/notes",
        },
    }
})
