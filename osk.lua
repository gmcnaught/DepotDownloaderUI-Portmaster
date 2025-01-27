-- osk.lua

local osk = {}

-- Keyboard layout
osk.keys = {
    {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"},
    {"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"},
    {"A", "S", "D", "F", "G", "H", "J", "K", "L"},
    {"Shift", "Z", "X", "C", "V", "B", "N", "M", "Backspace"}
}

osk.keyWidth = 50
osk.keyHeight = 50
osk.margin = 5
osk.inputText = ""
osk.isShiftActive = false
osk.password = nil  -- Variable to hold the reference to the password

-- Controller navigation
osk.selectedRow = 1
osk.selectedCol = 1

function osk.setPasswordReference(passwordReference)
    osk.password = passwordReference
end

function osk.draw()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    
    -- Calculate the total width and height of the OSK
    local totalWidth = (#osk.keys[1] * osk.keyWidth) + ((#osk.keys[1] - 1) * osk.margin)
    local totalHeight = (#osk.keys * osk.keyHeight) + ((#osk.keys - 1) * osk.margin)
    
    -- Calculate starting positions to center the OSK
    local startX = (screenWidth - totalWidth) / 2
    local startY = (screenHeight - totalHeight) / 2

    -- Draw the keys
    for rowIndex, row in ipairs(osk.keys) do
        for keyIndex, key in ipairs(row) do
            local x = startX + (keyIndex - 1) * (osk.keyWidth + osk.margin)
            local y = startY + (rowIndex - 1) * (osk.keyHeight + osk.margin)
            if rowIndex == osk.selectedRow and keyIndex == osk.selectedCol then
                love.graphics.setColor(0.5, 0.5, 1) -- Highlight selected key
                love.graphics.rectangle("fill", x, y, osk.keyWidth, osk.keyHeight)
                love.graphics.setColor(1, 1, 1) -- Reset color to white
            end
            love.graphics.rectangle("line", x, y, osk.keyWidth, osk.keyHeight)
            if key == "Shift" or key == "Space" or key == "Backspace" or key == "Enter" then
                love.graphics.printf(key, x, y + osk.keyHeight / 3, osk.keyWidth, "center")
            else
                local displayKey = osk.isShiftActive and string.upper(key) or string.lower(key)
                love.graphics.printf(displayKey, x, y + osk.keyHeight / 3, osk.keyWidth, "center")
            end
        end
    end

    -- Draw the input text
    love.graphics.printf(osk.inputText, 100, 400, 600, "center")
end

function osk.keypressed(key)
    if key == "return" then
        osk.pressSelectedKey(true)
    elseif key == "up" then
        osk.selectedRow = math.max(1, osk.selectedRow - 1)
    elseif key == "down" then
        osk.selectedRow = math.min(#osk.keys, osk.selectedRow + 1)
    elseif key == "left" then
        osk.selectedCol = math.max(1, osk.selectedCol - 1)
    elseif key == "right" then
        osk.selectedCol = math.min(#osk.keys[osk.selectedRow], osk.selectedCol + 1)
    end
end

function osk.gamepadpressed(joystick, button)
    if button == "a" then
        osk.pressSelectedKey(false)
    elseif button == "dpup" then
        osk.selectedRow = math.max(1, osk.selectedRow - 1)
    elseif button == "dpdown" then
        osk.selectedRow = math.min(#osk.keys, osk.selectedRow + 1)
    elseif button == "dpleft" then
        osk.selectedCol = math.max(1, osk.selectedCol - 1)
    elseif button == "dpright" then
        osk.selectedCol = math.min(#osk.keys[osk.selectedRow], osk.selectedCol + 1)
    elseif button == "x" then  -- Treat the "X" button as the "Enter" key
        osk.pressSelectedKey(true)
    end
end

function osk.pressSelectedKey(isEnterKey)
    local key = osk.keys[osk.selectedRow][osk.selectedCol]
    if key == "Shift" then
        osk.isShiftActive = not osk.isShiftActive
    elseif key == "Backspace" then
        osk.password.value = osk.password.value:sub(1, -2)
    elseif key == "Space" then
        osk.password.value = osk.password.value .. " "
    elseif key == "Enter" or isEnterKey then  -- Handle Enter key
        -- Trigger any action you want to perform on Enter key press
        print("Enter key pressed")
    else
        local char = osk.isShiftActive and string.upper(key) or string.lower(key)
        osk.password.value = osk.password.value .. char
    end
end

return osk