local login = {}
local password = { value = "" }  -- Define password as a table to hold the value
local inputActive = true
local lovedir = love.filesystem.getSourceBaseDirectory()
login.done = false  -- Initialize the done flag
local osk = require("osk")

local background  -- Variable to hold the background image

function login.load()
    -- Load the background image
    background = love.graphics.newImage("assets/background.png")
    background:setFilter("nearest", "nearest")
    -- Define the file path for login.txt
    local loginFilePath = lovedir .. "/login.txt"
    
    -- Attempt to open the file
    local file = io.open(loginFilePath, "r")
    if not file then
        print("Error: login.txt not found!")
        print(loginFilePath)
        return false
    end

    -- Read the first line: username
    local username = file:read("*line")
    file:close()

    -- Validate the data read from the file
    if not username then
        print("Error: login.txt does not contain valid data!")
        return false
    end

    -- Store the data in the `login` table
    login.username = username

    print("Login loaded successfully: " .. login.username)
    
    -- Pass the password reference to the OSK
    osk.setPasswordReference(password)

    return true
end

function login.update(dt)
    -- Update logic (if any) goes here
end

function login.draw()
    love.graphics.clear(0, 0, 0)  -- Clear the screen with black color
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    local listWidth = screenWidth * 0.4
    local listHeight = screenHeight * 0.56
    local startX = (screenWidth - listWidth) / 2
	local startY = (screenHeight - listHeight) / 1.5
    -- Set the default filter to nearest for sharp pixel scaling
    love.graphics.setDefaultFilter("nearest", "nearest")
    if background then
        local backgroundScale = windowHeight / background:getHeight()
        local backgroundWidth = background:getWidth() * backgroundScale
        local backgroundOffsetX = math.floor((windowWidth - backgroundWidth) / 2)
        love.graphics.draw(background, math.floor(backgroundOffsetX), 0, 0, backgroundScale, backgroundScale)
    end

    love.graphics.setColor(1, 1, 1)  -- Set color to white
    love.graphics.setFont(love.graphics.newFont(20))  -- Set font size

    love.graphics.printf("Username: " .. (login.username or "N/A"), 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Password: " .. string.rep("*", #password.value), 0, 140, love.graphics.getWidth(), "center")

    if inputActive then
        love.graphics.printf("Type your password and press Enter to login", 0, 180, love.graphics.getWidth(), "center")
    end
	love.graphics.printf("Press X to send your password.", 0, screenHeight / 20, screenWidth, "center")
    -- Draw the OSK last to ensure it is on top
    osk.draw()
end

function login.keypressed(key)
    -- First handle the OSK key input
    osk.keypressed(key)

    -- Then handle the password input and login logic
    if inputActive then
        if key == "backspace" then
            password.value = password.value:sub(1, -2)
        elseif key == "return" then  -- Handle Enter key
            inputActive = false
            print("Username: " .. (login.username or "N/A"))
            print("Password: " .. password.value)
            -- Handle login logic here, e.g., validate credentials
            -- Set the done flag to true after successful login
            login.done = true
        elseif key:len() == 1 then
            password.value = password.value .. key
        end
    end
end

function love.textinput(text)
    if inputActive then
        password.value = password.value .. text
    end
end

function login.gamepadpressed(joystick, button)
    osk.gamepadpressed(joystick, button)

    if button == "x" then  -- Handle Enter action when the "X" button is pressed
        inputActive = false
        print("Username: " .. (login.username or "N/A"))
        print("Password: " .. password.value)
        -- Handle login logic here, e.g., validate credentials
        -- Set the done flag to true after successful login
        login.done = true
    end
end

-- Function to check if login is done
function login.isDone()
    return login.done
end

-- Function to get the password
function login.getPassword()
    return password.value
end

return login