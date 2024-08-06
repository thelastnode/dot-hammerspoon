-- Chrome profiles
local function focusChromeWindow(profile)
    local chrome = hs.application.find('Google Chrome')
    chrome:activate()
    local didSelect = chrome:selectMenuItem({ 'Profiles', profile })
    if didSelect == nil then
        error("Could not find profile: " .. profile)
    end
end

local workProfileName = 'Work'
local personalProfileName = 'Ankit'

local chromeMap = {
    -- { key = '9', profile = workProfileName },
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

LaunchModal:bind({}, 'o', function() focusIslandTab('1') end) -- Mail
LaunchModal:bind({}, 'c', function() focusIslandTab('2') end) -- Calendar
LaunchModal:bind({ "shift" }, 'g', function() focusIslandTab('3') end) -- ChatGPT

