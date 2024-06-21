-- EmmyLua generates types for Hammerspoon development.
-- It adds to startup time, so it's commented out here after running once. Uncomment to generate types:
-- hs.loadSpoon('EmmyLua')

hs.hotkey.bind({ 'cmd', 'shift', 'ctrl' }, 'r', function()
    hs.reload()
end)

-- Globals:
-- LaunchModal is shared between several modules, initializing here:
LaunchModal = hs.hotkey.modal.new({ 'cmd', 'ctrl' }, 'a')
LaunchModal:bind({}, 'escape', function() LaunchModal:exit() end)

-- Modules:
require('cameralight')
require('chrome')
require('figma')
require('launch')
require('screenrecording')
require('timetracker.timetracker')
require('window')

hs.alert.show('Hammerspoon loaded 🔨')
