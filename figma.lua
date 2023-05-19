-- Figma open URL from clipboard
local function openFigmaUrlFromClipboard()
    local figma = hs.application.find('Figma')
    figma:activate()
    figma:selectMenuItem({ 'File', 'Open File URL From Clipboard' })
    LaunchModal:exit()
end

LaunchModal:bind({ 'shift' }, 'f', openFigmaUrlFromClipboard)
