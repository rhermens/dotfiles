local summon = function(bundleID)
    local targetScreen = hs.mouse.getCurrentScreen()
    hs.application.launchOrFocusByBundleID(bundleID)

    local app = hs.application.get(bundleID)
    local win = app and (app:focusedWindow() or app:mainWindow())

    if win and targetScreen then
        win:moveToScreen(targetScreen, false, true, 0)
        win:focus()
    end
end

hs.hotkey.bind('cmd', "1", function()
    summon("com.google.Chrome")
end)

hs.hotkey.bind('cmd', "2", function()
    summon("com.mitchellh.ghostty")
end)
