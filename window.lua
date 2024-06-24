WindowModal = hs.hotkey.modal.new({ 'cmd', 'ctrl' }, '2')
WindowModal:bind({}, 'escape', function() WindowModal:exit() end)

---@type string | nil
local modalAlert = nil

---@diagnostic disable-next-line: duplicate-set-field
function WindowModal:entered()
    modalAlert = hs.alert.show('↔', nil)
end

---@diagnostic disable-next-line: duplicate-set-field
function WindowModal:exited()
    if modalAlert ~= nil then
        hs.alert.closeSpecific(modalAlert)
    end
    modalAlert = nil
end

local function bindLayouts()
    local vimToPositionMap = {
        { modifiers = {}, key = 'h', layout = hs.layout.left50 },
        { modifiers = {}, key = 'l', layout = hs.layout.right50 },
        { modifiers = {}, key = 'space', layout = hs.layout.maximized },

        { modifiers = {}, key = 'j', layout = hs.geometry.rect(0, 0.5, 1, 0.5) },
        { modifiers = {}, key = 'k', layout = hs.geometry.rect(0, 0, 1, 0.5) },

        { modifiers = {}, key = 'u', layout = hs.geometry.rect(0, 0, 0.5, 0.5) },
        { modifiers = {}, key = 'o', layout = hs.geometry.rect(0.5, 0, 0.5, 0.5) },
        { modifiers = {}, key = 'm', layout = hs.geometry.rect(0, 0.5, 0.5, 0.5) },
        { modifiers = {}, key = '.', layout = hs.geometry.rect(0.5, 0.5, 0.5, 0.5) },

        { modifiers = { 'cmd' }, key = 'h', layout = hs.layout.left70 },
        { modifiers = { 'cmd' }, key = 'l', layout = hs.layout.right70 },
    }

    for _, mapping in ipairs(vimToPositionMap) do
        WindowModal:bind(mapping['modifiers'], mapping['key'], function()
            hs.window.focusedWindow():moveToUnit(mapping['layout'])
            WindowModal:exit()
        end)
    end
end

local function bindScreenMoves()
    local vimToScreenMoveMap = {
        { key = 'k', move = function(s) return s:toNorth() end },
        { key = 'j', move = function(s) return s:toSouth() end },
        { key = 'h', move = function(s) return s:toWest() end },
        { key = 'l', move = function(s) return s:toEast() end },
    }

    for _, mapping in ipairs(vimToScreenMoveMap) do
        WindowModal:bind({ 'ctrl' }, mapping['key'], function()
            local win = hs.window.focusedWindow()
            local screen = win:screen()
            local newScreen = mapping['move'](screen)
            win:moveToScreen(newScreen)
        end)
    end
end

local function findSmallestScreen()
    ---@type hs.screen
    ---@diagnostic disable-next-line: assign-type-mismatch
    local smallestScreen = hs.fnutils.reduce(hs.screen.allScreens(), function(acc, screen)
        local currentFrame = acc:frame()
        local frame = screen:frame()
        local newScreenIsBigger = currentFrame['w'] * currentFrame['h'] <= frame['w'] * frame['h'] 
        if newScreenIsBigger then
            return acc
        else
            return screen
        end
    end, hs.screen.primaryScreen())

    return smallestScreen
end

-- This centers the window on its current screen, but sizes it to the size of your smallest monitor. This is useful
-- for screen sharing: a large monitor is hard to see if you're consuming it on a smaller laptop screen.
local function bindCenterOnScreen()
    WindowModal:bind({}, 'tab', function()
        local smallestScreen = findSmallestScreen()
        local win = hs.window.focusedWindow()
        -- first, move the window to the top left of the current screen so it has room to resize
        win:setTopLeft(win:screen():frame())
        -- then, resize it
        win:setSize(hs.geometry.size(smallestScreen:frame()['w'], smallestScreen:frame()['h']))
        -- finally, center it on the screen
        win:centerOnScreen()
        WindowModal:exit()
    end)
end

bindLayouts()
bindScreenMoves()
bindCenterOnScreen()
