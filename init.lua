-- Disabling once generated to make sure startup is quick.
-- hs.loadSpoon('EmmyLua')

hs.hotkey.bind({ 'cmd', 'shift', 'ctrl' }, 'r', function()
    hs.reload()
end)

-- launch mode
LaunchModal = hs.hotkey.modal.new({ 'cmd', 'ctrl' }, 'a')
LaunchModal:bind({}, 'escape', function() LaunchModal:exit() end)

-- app mappings
local appMap = {
    { key = 'v', app = 'Code$' },
    { key = 's', app = 'Slack' },
    { key = 'n', app = 'Obsidian' },
    { key = 't', app = 'Microsoft Teams' },
    { key = 'i', app = 'Messages' },
    { key = 'f', app = 'Figma' },
    { key = 'p', app = 'Spotify' },
    { key = 'w', app = 'WhatsApp' },
    { key = 'j', app = 'IntelliJ' },
    { key = 'b', app = 'Blender' },
    { key = 'e', app = 'Microsoft Edge' },
}
local function focusApplication(pattern)
    local app = hs.application.find(pattern)
    if app ~= nil then
        app:activate()
    end
end
for _, mapping in ipairs(appMap) do
    LaunchModal:bind({}, mapping['key'], function()
        focusApplication(mapping['app'])
        LaunchModal:exit()
    end)
end

-- Hammerspoon console
LaunchModal:bind({}, '=', function() hs:openConsole(); LaunchModal:exit() end)

-- other modules
require('cameralight')
require('chrome')
require('figma')
require('obsidian')
require('screenrecording')

hs.alert.show('Hammerspoon loaded 🔨')
