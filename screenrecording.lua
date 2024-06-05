-- Run `ScreenRecordingMode()` in console, then click window. This will:
-- 1. Center and resize to 1080p
-- 2. Open CleanShot X all-in-one capture mode
--
-- You can also specify custom dimensions like `ScreenRecordingMode{ w = 800, h = 600 }`.

--- @param dimensions table | nil
function ScreenRecordingMode(dimensions)
    local width = dimensions and dimensions.w or 1920
    local height = dimensions and dimensions.h or 1080

    ScreenRecordingModeWatcher  = hs.application.watcher.new(function (name, event, app)
        if event ~= hs.application.watcher.activated then
            return
        end
        ScreenRecordingModeWatcher:stop()

        -- center on screen, set to 1080p
        local window = app:focusedWindow()
        window:setSize({ w = width, h = height })
        window:centerOnScreen()

        -- CleanShot X uses points relative to bottom left: https://cleanshot.com/docs/api
        -- hs.screen:localToAbsolute() uses points relative to top left
        local topLeft = window:screen():absoluteToLocal(window:topLeft())

        local cleanShotUrl = (
            'cleanshot://all-in-one?'
            .. 'x=' .. string.format('%d', topLeft['x'])
            .. '&y=' .. string.format('%d', topLeft['y'])
            .. '&width=' .. string.format('%d', window:size()['w'])
            .. '&height=' .. string.format('%d', window:size()['h'])
            .. '&display=' .. string.format('%d', window:screen():id())
        )
        hs.urlevent.openURL(cleanShotUrl)
    end)
    ScreenRecordingModeWatcher:start()
end