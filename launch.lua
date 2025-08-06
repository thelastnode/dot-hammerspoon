-- app mappings
local appMap = {
    { key = 'v', app = '^Code[ ]?[-]?' },  -- match both 'Code - Insiders' and 'Code'
    { key = 'w', app = 'Windsurf' },
    { key = 's', app = 'Slack' },
    { key = 'n', app = 'Obsidian' },
    { key = 't', app = 'Microsoft Teams' },
    { key = 'i', app = 'Messages' },
    { key = 'f', app = 'Figma' },
    { key = 'p', app = 'Spotify' },
    { key = 'j', app = 'IntelliJ' },
    { key = 'b', app = 'Blender' },
    { key = 'e', app = 'Microsoft Edge' },
    { key = 'x', app = 'Excel' },
    { key = 'm', app = 'Messenger' },
    { key = 'q', app = 'Xcode' },
    { key = 'g', app = 'Open WebUI' },
    { key = 'h', app = 'Home Assistant' },
    { key = 'd', app = 'Claude' },
    { key = 'l', app = 'LM Studio' },
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
