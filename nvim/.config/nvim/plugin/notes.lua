require('obsidian').setup({
    legacy_commands = false,
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
