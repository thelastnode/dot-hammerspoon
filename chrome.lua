-- Chrome profiles
local function focusChromeWindow(profile)
    local chrome = hs.application.find('Google Chrome')
    chrome:activate()
    local didSelect = chrome:selectMenuItem({ 'Profiles', profile })
    if didSelect == nil then
        error("Could not find profile: " .. profile)
    end
end

local chromeMap = {
    { key = '0', profile = 'Ankit' },
}

for _, mapping in ipairs(chromeMap) do
    LaunchModal:bind({}, mapping['key'], function()
        focusChromeWindow(mapping['profile'])
        LaunchModal:exit()
    end)
end

local function focusChromeTab(profileName, tabNum)
    focusChromeWindow(profileName)
    hs.eventtap.keyStroke({ 'cmd' }, tabNum)
    LaunchModal:exit()
end

local function focusIsland()
    hs.application.find('Island'):activate()
end

local function focusIslandTab(tabNum)
    focusIsland()
    hs.eventtap.keyStroke({ 'cmd' }, tabNum)
    LaunchModal:exit()
end

LaunchModal:bind({}, '9', function()
    focusIsland()
    LaunchModal:exit()
end)

-- Disabled for native Outlook for now
-- LaunchModal:bind({}, 'o', function() focusIslandTab('1') end) -- Mail
-- LaunchModal:bind({}, 'c', function() focusIslandTab('2') end) -- Calendar

