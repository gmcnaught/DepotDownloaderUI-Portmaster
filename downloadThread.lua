-- This script is intended to be run as a thread in LOVE2D

-- Retrieve the passed game data and credentials
local gameData = ...
local lovedir = love.filesystem.getSourceBaseDirectory()
local depotDownloaderPath = "DepotDownloader"  -- Ensure this path is correct

local username = gameData.username
local password = gameData.password
local game = gameData.game

-- Debug print to check received credentials and game data
print("Received Username: " .. (username or "N/A"))
print("Received Game Data: " .. (game.data or "N/A"))

-- Construct the command to run DepotDownloader
local cmd = string.format(
    '"%s/%s" %s -username %s -password %s',
    lovedir,
    depotDownloaderPath,
    game.data,
    username,
    password
)

-- Path to the log file
local logFilePath = lovedir .. "/log_depot.txt"

-- Open DepotDownloader and write output to the log file
local handle = io.popen(cmd .. " > " .. logFilePath .. " 2>&1", "r")
if not handle then
    local errorFile = io.open(logFilePath, "w")
    errorFile:write("Error: Unable to start DepotDownloader!")
    errorFile:close()
    return
end

-- Wait until the process finishes
local success, reason, exitCode = handle:close()

-- Write completion information to the log file
local logFile = io.open(logFilePath, "a")

-- Signal that the download is done
local progressChannel = love.thread.getChannel("downloadProgress")
progressChannel:push("done")