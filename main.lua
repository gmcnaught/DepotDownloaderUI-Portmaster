local selectedGame = 1
local gamesPerPage = 10
local currentPage = 1
local inputCooldown = 0.2
local inputTimer = 0
local games = require("games")  -- Require the games.lua file
local isDownloading = false
local lovedir = love.filesystem.getSourceBaseDirectory()
local downloadOutputChannel = love.thread.getChannel("downloadOutput")
local downloadThread
local directory = "roms"
local depotDownloaderHandle
local splashlib = require("splash")  -- Assuming "splash.lua" is the correct module name
local splash -- Declare the splash screen variable globally
local push = require "push"
love.graphics.setDefaultFilter("nearest", "nearest")
local gameWidth, gameHeight = 640, 480 -- Fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()
-- windowHeight = 1280, 720 -- Uncomment this when using on desktop to show windows
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})
local login = require("login")

function loadBackground()
    -- Release previously loaded images (if any)
    if background then
        background:release()
        background = nil
    end
      
    -- Load images with nearest-neighbor filtering
    love.graphics.setDefaultFilter("nearest", "nearest")

    background = love.graphics.newImage("assets/background.png")
    background:setFilter("nearest", "nearest")

    -- Restore default filter settings
    love.graphics.setDefaultFilter("linear", "linear")
end

function drawBackground()
    local windowWidth, windowHeight = love.graphics.getDimensions()

    -- Set the default filter to nearest for sharp pixel scaling
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Draw the background layer
    if background then
        local backgroundScale = windowHeight / background:getHeight()
        local backgroundWidth = background:getWidth() * backgroundScale
        local backgroundOffsetX = math.floor((windowWidth - backgroundWidth) / 2)
        love.graphics.draw(background, math.floor(backgroundOffsetX), 0, 0, backgroundScale, backgroundScale)
    end
end

-- Function to recall the resolution after screen is set to fullscreen
function love.resize(w, h)
    -- Initialize or update the splash screen with the new dimensions
    initializeSplashScreen(w, h)
end

function initializeSplashScreen(width, height)
    -- Configure the splash screen
    local splashConfig = {
        background = {0, 0, 0},  -- Black background
    }

    -- Initialize or update the splash screen
    splash = splashlib(splashConfig, width, height)
end

function love.keypressed(key)
    -- Handle keyboard input
    if splash and not splash.done then
        splash:keypressed(key)
    else
        login.keypressed(key)
    end
end

function love.gamepadpressed(joystick, button)
    if splash and not splash.done then
        splash:gamepadpressed(button)
    elseif login and not login.done then 
        login.gamepadpressed(joystick, button)
    else
        if inputTimer <= 0 then
            -- Handle gamepad input
            if button == "dpup" then
                selectedGame = math.max(1, selectedGame - 1)
                if selectedGame < (currentPage - 1) * gamesPerPage + 1 then
                    currentPage = math.max(1, currentPage - 1)
                end
            elseif button == "dpdown" then
                selectedGame = math.min(#games.list, selectedGame + 1)
                if selectedGame > currentPage * gamesPerPage then
                    currentPage = math.min(math.ceil(#games.list / gamesPerPage), currentPage + 1)
                end
            elseif button == "a" then
                startDownload(games.list[selectedGame])
            elseif button == "rightshoulder" then
                selectedGame = math.min(#games.list, selectedGame + 2)
                if selectedGame > currentPage * gamesPerPage then
                    currentPage = math.min(math.ceil(#games.list / gamesPerPage), currentPage + 1)
                end
            elseif button == "leftshoulder" then
                selectedGame = math.max(1, selectedGame - 2)
                if selectedGame < (currentPage - 1) * gamesPerPage + 1 then
                    currentPage = math.max(1, currentPage - 2)
                end
            end
            inputTimer = inputCooldown
        end
    end
end

local logFileName = "log_depot.txt"
local lastLine = "Start"

local function loadLogin()
    -- Define the file path for login.txt
    local loginFilePath = lovedir .. "/login.txt"
    
    -- Attempt to open the file
    local file = io.open(loginFilePath, "r")
    if not file then
        print("Error: login.txt not found!")
        print(loginFilePath)
        return false
    end

    -- Read the first two lines: username and password
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
    return true
end

-- Function to read the last line from the log file
local function readLastLine()
    local file = io.open(logFileName, "r")
    if not file then
        --print("Error: log_depot.txt not found!")
        --print(lovedir .. logFileName)
        return nil
    end

    local lastLine
    for line in file:lines() do
        lastLine = line
    end
    file:close()
    return lastLine
end

-- Download-Startfunktion (Simuliert Download-Prozess in einem separaten Thread)
function startDownload(game)
    local passwordChannel = love.thread.getChannel("passwordChannel")
    passwordChannel:push(password)
    local selected = games.list[selectedGame]
    if selected then
        print("Name: " .. selected.name)
        print("GameData: " .. selected.data)
        print("Username: " .. (login.username or "N/A"))
        --print(password) -- Printing the password to the log.txt DONT DO THIS UNLESS YOU KNOW WHAT YOU ARE DOING
        print("---------------")
    end

    if isDownloading then return end
    isDownloading = true

    -- Erstelle einen neuen Thread für den Download
    local downloadThreadPath = "downloadThread.lua"
    if not love.filesystem.getInfo(downloadThreadPath) then
        print("Error: downloadThread.lua not found!")
        isDownloading = false
        return
    end

    downloadThread = love.thread.newThread(downloadThreadPath)  -- Lade den Thread aus der externen Datei
    
    if not downloadThread then
        print("Error: Failed to create download thread!")
        isDownloading = false
        return
    end

    local success, err = pcall(function()
        downloadThread:start({
            game = game,
            username = login.username,
            password = password.value,
            channel = love.thread.getChannel("downloadProgress")
        })  -- Starte den Thread und übergebe die Spielparameter
    end)

    if not success then
        print("Error: Failed to start download thread - " .. tostring(err))
        isDownloading = false
    end
end

local function fileExists(filepath)
    local file = io.open(filepath, "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end

-- Funktion, um den Inhalt einer Datei zu lesen
local function fileContains(filepath, searchString)
    local file = io.open(filepath, "r")
    if not file then return false end

    for line in file:lines() do
        if line:find(searchString) then
            file:close()
            return true
        end
    end

    file:close()
    return false
end

function love.load()
    music = love.audio.newSource("assets/music.mp3", "stream") -- "stream" is used for large audio files
    music:setLooping(true) -- Set to true if you want the music to loop
    music:play() -- Start playing the music
    login.load()
    initializeSplashScreen(love.graphics.getWidth(), love.graphics.getHeight())
    --font
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    local fontsize =  (screenHeight / 20 )
    local font = love.graphics.newFont(fontsize)
    love.graphics.setFont(font)
    
    loadBackground()
    if not loadLogin() then
        print("Failed to load login data. Exiting...")
    end

    directory = lovedir .. "/.."
    games.load(directory)  -- Ensure games are loaded
    if not games.list then
        print("Error: games.list is nil after loading games")
    else
        print("Games loaded successfully. Total games: " .. #games.list)
    end
end

function love.update(dt)
    login.update(dt)
    inputTimer = inputTimer - dt
    if splash and not splash.done then
        splash:update(dt)
        return
    end
    
    if login.isDone() then
        login.done = true
        password = login.getPassword()
    else
        login.done = false
    end
    
    
    -- Update the last line from the log file
    local newLastLine = readLastLine()
    if newLastLine and newLastLine ~= lastLine then
        lastLine = newLastLine
    end

    -- Check for process handle from the thread
    local processChannel = love.thread.getChannel("depotDownloaderHandle")
    local handle = processChannel:pop()
    if handle then
        depotDownloaderHandle = handle
    end

    -- Handle joystick input
    local joystick = love.joystick.getJoysticks()[1]
    if joystick and inputTimer <= 0 and not isDownloading then
        if joystick:isGamepadDown("dpup") then
            selectedGame = math.max(1, selectedGame - 1)
            if selectedGame < (currentPage - 1) * gamesPerPage + 1 then
                currentPage = math.max(1, currentPage - 1)
            end
            inputTimer = inputCooldown
        elseif joystick:isGamepadDown("dpdown") then
            selectedGame = math.min(#games.list, selectedGame + 1)
            if selectedGame > currentPage * gamesPerPage then
                currentPage = math.min(math.ceil(#games.list / gamesPerPage), currentPage + 1)
            end
            inputTimer = inputCooldown
        elseif joystick:isGamepadDown("a") and not isDownloading and login.done then
            startDownload(games.list[selectedGame])
            inputTimer = inputCooldown
        elseif joystick:isGamepadDown("rightshoulder") then
            selectedGame = math.min(#games.list, selectedGame + 2)
            if selectedGame > currentPage * gamesPerPage then
                currentPage = math.min(math.ceil(#games.list / gamesPerPage), currentPage + 1)
            end
            inputTimer = inputCooldown
        elseif joystick:isGamepadDown("leftshoulder") then
            selectedGame = math.max(1, selectedGame - 2)
            if selectedGame < (currentPage - 1) * gamesPerPage + 1 then
                currentPage = math.max(1, currentPage - 2)
            end
            inputTimer = inputCooldown
        end
    end
end

function love.draw()
    -- Draw the splash screen if it exists and is not done
    if splash and not splash.done then
        splash:draw()
    elseif login and not login.done then
        drawBackground()
        login.draw()
    else
        drawBackground()
        local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
        local listWidth = screenWidth * 0.4
        local listHeight = screenHeight * 0.56
        local startX = (screenWidth - listWidth) / 2
        local startY = (screenHeight - listHeight) / 1.5

        -- Anweisung zum Spielauswahl
        love.graphics.printf("Select a game with the D-Pad. Press A to download.", 0, screenHeight / 20, screenWidth, "center")

        -- Spiele anzeigen
        local startIdx = (currentPage - 1) * gamesPerPage + 1
        local endIdx = math.min(startIdx + gamesPerPage - 1, #games.list)

        for i = startIdx, endIdx do
            local game = games.list[i]
            local yPosition = startY + (i - startIdx) * (listHeight / gamesPerPage)

            -- Highlight für ausgewähltes Spiel
            if i == selectedGame then
                love.graphics.setColor(1, 1, 0) -- Gelb für Auswahl
            else
                love.graphics.setColor(1, 1, 1) -- Weiß für andere Spiele
            end

            love.graphics.printf(game.name, startX, yPosition - 80, listWidth, "center")
        end

        -- Farben zurücksetzen
        love.graphics.setColor(1, 1, 1)

        -- Beschreibung des ausgewählten Spiels anzeigen
        if games.list[selectedGame] then
            love.graphics.printf(games.list[selectedGame].description or "No description available", 0, screenHeight - 150, screenWidth - 20, "right")
        end

        -- Fortschritt oder Seitenanzeige anzeigen
        if isDownloading then
            love.graphics.printf("Downloading: " .. lastLine, 0, screenHeight - 30, screenWidth - 10, "left")
        else
            love.graphics.printf("Page " .. currentPage .. " of " .. math.ceil(#games.list / gamesPerPage), 0, screenHeight - 40, screenWidth - 30, "right")
        end
    end
end

function love.quit()
    -- Terminate the DepotDownloader process if it is running
    if depotDownloaderHandle then
        print("Terminating DepotDownloader...")
        depotDownloaderHandle:kill()  -- Forcefully terminate the process
    end
end
