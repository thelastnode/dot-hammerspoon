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

-- Outlook in Chrome PWA mappings
local function focusOutlookWindow(profileName, tabNum)
    focusChromeWindow(profileName)
    hs.eventtap.keyStroke({ 'cmd' }, tabNum)
    LaunchModal:exit()
end

LaunchModal:bind({}, 'o', function() focusOutlookWindow(workProfileName, '1') end) -- Mail
LaunchModal:bind({}, 'c', function() focusOutlookWindow(workProfileName, '2') end) -- Calendar
LaunchModal:bind({}, 'g', function() focusOutlookWindow(workProfileName, '3') end) -- ChatGPT
LaunchModal:bind({}, 'G', function() focusOutlookWindow(personalProfileName, '2') end) -- open-webui
