local summon = function(bundleID)
    local targetScreen = hs.mouse.getCurrentScreen()
    local app = hs.application.get(bundleID)

    if not app then
        hs.application.launchOrFocusByBundleID(bundleID)
        hs.timer.waitUntil(
            function() return hs.application.get(bundleID) ~= nil end,
            function()
                local a = hs.application.get(bundleID)
                local win = a and (a:focusedWindow() or a:mainWindow())
                if win then
                    win:moveToScreen(targetScreen, false, true, 0)
                    win:focus()
                end
            end,
            0.05
        )
        return
    end

    local win = app:focusedWindow() or app:mainWindow()
    if win then
        win:moveToScreen(targetScreen, false, true, 0)
        win:focus()
    else
        app:activate()
    end
end

hs.hotkey.bind('cmd', "1", function()
    summon("com.google.Chrome")
end)

hs.hotkey.bind('cmd', "2", function()
    summon("com.mitchellh.ghostty")
end)

hs.hotkey.bind('cmd', "3", function()
    summon("com.tinyspeck.slackmacgap")
end)

hs.hotkey.bind('cmd', "5", function()
    summon("com.mongodb.compass")
end)
