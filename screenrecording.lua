-- Run in console, then click window to center and resize to 1080p.
-- Will also capture area with CleanShot X to set up last capture location for recording.

function ScreenRecordingMode()
    ScreenRecordingModeWatcher  = hs.application.watcher.new(function (name, event, app)
        if event ~= hs.application.watcher.activated then
            return
        end
        ScreenRecordingModeWatcher:stop()

        -- center on screen, set to 1080p
        local window = app:focusedWindow()
        window:setSize({ w = 1920, h = 1080 })
        window:centerOnScreen()

        -- TODO CleanShot X doesn't support parameters for all-in-one mode.

        -- CleanShot X uses points relative to bottom left: https://cleanshot.com/docs/api
        -- hs.screen:localToAbsolute() uses points relative to top left
        -- local topLeft = window:screen():absoluteToLocal(window:topLeft())
        -- local screenHeight = window:screen():fullFrame()['h']

        -- local cleanShotUrl = (
        --     'cleanshot://capture-area?'
        --     .. 'x=' .. string.format('%d', topLeft['x'])
        --     .. '&y=' .. string.format('%d', topLeft['y'])
        --     .. '&width=' .. string.format('%d', window:size()['w'])
        --     .. '&height=' .. string.format('%d', window:size()['h'])
        --     .. '&display=' .. string.format('%d', window:screen():id())
        -- )
        -- print(cleanShotUrl) -- TODO remove
    end)
    ScreenRecordingModeWatcher:start()
end