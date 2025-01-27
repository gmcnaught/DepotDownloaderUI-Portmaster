-- games.lua
local games = {}
local lovedir = love.filesystem.getSourceBaseDirectory()
-- When you add new Games, please make sure they are alphabetically right
function games.load(directory)
    games.list = {
        {name = "Alien Squatter", data = "-app 1131750  -depot 1131751 -dir " .. directory .. "/aliensquatter/"},
        {name = "Annalynn", data = "-app 1508460 -depot 1508461 -manifest 5365853075598347936 -dir " .. directory .. "/annalynn/gamedata/"},
        {name = "Balatro", data = "-app 2379780  -depot 2379781 -dir " .. directory .. "/balatro/"},
        {name = "Bleed", data = "-app 239800 -depot 239803 -dir " .. directory .. "/bleed/gamedata/"},
        {name = "Blossom Tales 2", data = "-app 1747830 -depot 1747831 -dir " .. directory .. "/blossomtales2/gamedata/"},
        {name = "Blue Revolver", data = "-app 439490 -depot 439494 -manifest 895637721803560756 -dir " .. directory .. "/bluerevolver/"},
        {name = "Boneraiser Minions", data = "-app 1944570 -depot 1944571 -manifest 6000190403203003495 -dir " .. directory .. "/boneraiserminions/gamedata/"},
        {name = "Bot Vice", data = "-app 491040 -depot 491042  -dir " .. directory .. "/botvice/", description = "rename the assets folder to gamedata"},
        {name = "Bunnys Flowers", data = "-app 1375480 -depot 1375482  -dir " .. directory .. "/bunnysflowers/gamedata/"},
        {name = "Cards with Personalities", data = "-app 2147020 -depot 2147021 -filelist " .. lovedir .. "/UI/regex/onlyexe.txt  -dir " .. directory .. "/cardswithpersonalities/"},
		{name = "Carrie's Order Up", data = "-app 522490 -depot 522491 -dir " .. directory .. "/carriesorderup/gamedata"},
        {name = "Chasm", data = "-app 312200 -depot 312202 -dir " .. directory .. "/chasm/gamedata"},
        {name = "CLANNAD", data = "-app 324160 -depot 324161 -dir " .. directory .. "/clannad/gamedata", description = "Its 5gb big so it takes a while"},
        {name = "Cook, Serve, Delicious!", data = "-app 247020 -depot 247021 -dir " .. directory .. "/cookservedelicious/gamedata"},
        {name = "Cybarian", data = "-app 928840 -depot 928841 -dir " .. directory .. "/cybarian/gamedata"},
        {name = "Daikatana", data = "-app 242980 -depot 242981 -dir " .. directory .. "/daikatana/gamedata"},
        {name = "Dark Deity", data = "-app 1374840  -depot 1374842 -dir " .. directory .. "/darkdeity/gamedata", description = "needs Ultra Device like Retroid Pocket 5"},
        {name = "Dark Sheep", data = "-app 1576490 -depot 1576491 -dir " .. directory .. "/darksheep/gamedata"},
        {name = "Demonizer", data = "-app 1091390 -depot 1091391 -dir " .. directory .. "/demonizer/gamedata", description = "Go into the demonizer/gamedata and rename demonizer.exe to demonizer.love" },
        {name = "Depths of Limbo", data = "-app 568400 -depot 568401-dir " .. directory .. "/depthsoflimbo/"},
        {name = "Descent", data = "-app 273570 -depot 273573 -dir " .. directory .. "/descent/", description = " rename the descent folder in the descent folder to data and merge it with the already existing one "},
        {name = "Descent 2", data = "-app 273580 -depot 273583 -dir " .. directory .. "/carriesorderup/gamedata/", description = " rename the descent2 folder in the descent2 folder to data and merge it with the already existing one "},
        {name = "Descent 3", data = "-app 273590 -depot 273592 -dir " .. directory .. "/descent3/gamedata/"},
        {name = "Destructivator 2", data = "-app 1124990 -depot 1124991 -dir " .. directory .. "/destructivator2/gamedata/"},
        {name = "Devolver Bootleg", data = "-app 1066260 -depot 1066261 -dir " .. directory .. "/devbootleg/gamedata"},
        {name = "Donut Dodo", data = "-app 1779560 -depot 1779561 -dir " .. directory .. "/donutdodo/gamedata"},
        {name = "Doom 3", data = "-app 208200 -dir " .. directory .. "/doom3/", description = "over 6gb big so make sure you have time"},
        {name = "Downwell", data = "-app 360740 -depot 360741 -dir " .. directory .. "/downwell/gamedata"},
        {name = "Duke Nukem 3D", data = "-app 434050 -depot 434051 -dir " .. directory .. "/rednukem/gamedata"},
        {name = "Dungeon Souls", data = "-app 383230 -depot 383232 -dir " .. directory .. "/dungeonsouls/gamedata"},
        {name = "E.Z", data = "-app 795040 -depot 795041 -dir " .. directory .. "/ez/gamedata"},
		{name = "Elec Dude", data = "-app 1907980 -depot 1907982 -dir " .. directory .. "/elecdude/gamedata/", description = "Free Game"},
        {name = "ElecHead", data = "-app 51456880 -depot 1456881 -dir " .. directory .. "/elechead/gamedata"},
        {name = "Fallen Leaf", data = "-app 1459010 -depot 1459011 -dir " .. directory .. "/fallenleaf/gamedata"},
        {name = "Fallout 1", data = "-app 38400 -depot 38401 -dir " .. directory .. "/fallout1/", description = "english version"},
        {name = "Fallout 2", data = "-app 38410 -depot 38411 -dir " .. directory .. "/fallout2/", description = "english version"},
        {name = "Flywrench", data = "-app 337350 -depot 337351 -dir " .. directory .. "/flywrench/gamedata"},
        {name = "Forager", data = "-app 751780 -depot 751783 -manifest 3324194938480079153 -dir " .. directory .. "/forager/", description = "reguires power device, something like a x55"},
        {name = "Fran Bow", data = "-app 362680 -depot 362681 -dir " .. directory .. "/franbow/", description = "After installation rename Fran Bow Gamemaker to gamedata and remove the Other Folder"},
        {name = "Freedom Planet", data = "-app 248310 -depot 248312 -dir " .. directory .. "/freedomplanet/gamedata"},
        {name = "Fungus Reaper", data = "-app 2406640 -depot 2406641 -dir " .. directory .. "/fungusreaper/"},
        {name = "Goldon Hornet", data = "-app 739260 -depot 739261 -dir " .. directory .. "/goldenhornet/gamedata"},
        {name = "Gravity Circuit", data = "-app 858710 -depot 858711 -dir " .. directory .. "/gravitycircuit", description = " rename win64_steam to gamedata"},
		{name = "Half Life", data = "-app 70 -dir " .. directory .. "/halflife/"},
		{name = "Stardew Valley", data = "-app 413150 -depot 413153 -manifest 8332166493523218127 -dir " .. directory .. "/stardewvalley/gamedata/"},
        -- Add more games here
    }
end

return games