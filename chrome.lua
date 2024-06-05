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
    { key = '1', profile = workProfileName },
    { key = '2', profile = 'Ankit' },
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

LaunchModal:bind({}, 'o', function() focusChromeTab(workProfileName, '1') end) -- Mail
LaunchModal:bind({}, 'c', function() focusChromeTab(workProfileName, '2') end) -- Calendar
LaunchModal:bind({ "shift" }, 'g', function() focusChromeTab(workProfileName, '3') end) -- ChatGPT
LaunchModal:bind({}, 'g', function() focusChromeTab(personalProfileName, '2') end) -- open-webui
