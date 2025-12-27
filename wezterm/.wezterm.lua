local wezterm = require('wezterm')

local config = wezterm.config_builder();

config.default_prog = { "powershell.exe" }
config.color_scheme = "Tokyo Night Storm"
config.tab_bar_at_bottom = true

config.leader = {
    key = "b",
    mods = "CTRL",
}

config.keys = {
    {
        key = "c",
        mods = "LEADER",
        action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    }
}

for index = 1, 9 do
    table.insert(config.keys, {
        key = tostring(index),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(index - 1),
    })
end

config.window_padding = {
    top = 0,
    right = 0,
    bottom = 0,
    left = 0,
}

config.use_fancy_tab_bar = false

return config
