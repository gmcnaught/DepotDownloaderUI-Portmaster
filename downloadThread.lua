-- This script is intended to be run as a thread in LOVE2D

-- Retrieve the passed game data and credentials
local passwordChannel = love.thread.getChannel("passwordChannel")
local password = passwordChannel:pop()

local gameData = ...
local lovedir = love.filesystem.getSourceBaseDirectory()
local depotDownloaderPath = "DepotDownloader"  -- Ensure this path is correct

local username = gameData.username
local game = gameData.game

-- Ensure the password is not nil before using it
if not password then
    error("Password is nil")
end

print("Password Download: " .. password)
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
logFile:write("Download completed with exit code: " .. tostring(exitCode))
logFile:close()

-- Signal that the download is done
local progressChannel = love.thread.getChannel("downloadProgress")
progressChannel:push("done")