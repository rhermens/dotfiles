require("obsidian").setup({
    workspaces = {
        {
            name = "notes",
            path = "~/notes",
        },
    },
    notes_subdir = "0-inbox",
    daily_notes = {
        folder = "0-inbox",
    },
})
