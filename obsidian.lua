local wf = hs.window.filter

local function getFirstCharOfLine()
    hs.eventtap.keyStroke({ 'cmd' }, 'left')
    hs.eventtap.keyStroke({ 'ctrl' }, 'f')
    hs.eventtap.keyStroke({ 'ctrl' }, 'f')
    hs.eventtap.keyStroke({ 'shift' }, 'right')
    hs.eventtap.keyStroke({ 'cmd' }, 'c')
    hs.eventtap.keyStroke({}, 'left')
    local char = hs.pasteboard.getContents()
    hs.pasteboard.clearContents()
    return char
end

local function bindToggleStarHotkey()
    local STAR_CHAR = '➡️'
    
    local starHotkey = hs.hotkey.new({ 'cmd', 'ctrl' }, 's', function()
        hs.application.find('Obsidian'):activate()
        local firstChar = getFirstCharOfLine()
        if firstChar == STAR_CHAR then
            hs.eventtap.keyStroke({}, 'right')
            hs.eventtap.keyStroke({}, 'delete') -- delete star
            hs.eventtap.keyStroke({}, 'delete') -- delete space
        else
            hs.eventtap.keyStrokes(STAR_CHAR .. ' ')
        end
        hs.eventtap.keyStroke({ 'cmd' }, 'right') -- go to end of line
    end)

    ObsidianFilter = wf.new { 'Obsidian' }
    ObsidianFilter:subscribe(wf.windowFocused, function () starHotkey:enable() end)
    ObsidianFilter:subscribe(wf.windowUnfocused, function () starHotkey:disable() end)
end

bindToggleStarHotkey()
