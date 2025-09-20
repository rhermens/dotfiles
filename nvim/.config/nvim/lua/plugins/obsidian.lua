return {
    {
        'epwalsh/obsidian.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        opts = {
            ui = {
                enable = false,
            },
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
        },
    }
}
