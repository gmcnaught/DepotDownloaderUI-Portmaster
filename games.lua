-- games.lua
local games = {}
-- When you add new Games, please make sure they are alphabetically right
function games.load(directory)
    games.list = {
        {name = "Alien Squatter", data = "-app 1131750  -depot 1131751 -dir " .. directory .. "/aliensquatter/"},
        {name = "Annalynn", data = "-app 1508460 -depot 1508461 -manifest 5365853075598347936 -dir " .. directory .. "/annalynn/gamedata/"},
        {name = "Balatro", data = "-app 2379780  -depot 2379781 -dir " .. directory .. "/balatro/"},
        {name = "Bleed", data = "-app 239800 -depot 239803 -dir " .. directory .. "/bleed/gamedata/"},
        {name = "Blossom Tales 2", data = "-app 1747830 -depot 1747831 -dir " .. directory .. "/blossomtales2/gamedata/"},
        {name = "Elec Dude", data = "-app 1907980 -depot 1907982 -dir " .. directory .. "/elecdude/gamedata/", description = "Free Game"},
        {name = "Fran Bow", data = "-app 362680 -depot 362681 -dir " .. directory .. "/franbow", description = "After installation rename Fran Bow Gamemaker to gamedata and remove the Other Folder"},
        {name = "Stardew Valley", data = "-app 413150 -depot 413153 -manifest 8332166493523218127 -dir " .. directory .. "/stardewvalley/gamedata/"},
        -- Add more games here
    }
end

return games