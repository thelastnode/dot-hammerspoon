WindowModal = hs.hotkey.modal.new({ 'cmd', 'ctrl' }, '2')
WindowModal:bind({}, 'escape', function() WindowModal:exit() end)

---@diagnostic disable-next-line: duplicate-set-field
function WindowModal:entered()
    hs.alert.show('↔')
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

bindLayouts()
bindScreenMoves()
