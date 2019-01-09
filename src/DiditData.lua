Didit = {};

Didit.data = {
	-- Classic
	[14821] = 'Classic',
	["Temple of Ahn'Qiraj"] =   { ["Normal"] = 1101 },
	["Scarlet Halls"] =         { ["Normal"] = 932 }, -- Research this...
	["Molten Core"] =           { ["Normal"] = 1099 },

	["Stormwind Stockade"] =    { ["Normal"] = 633 },
	["Gnomeregan"] =            { ["Normal"] = 634 },


	["Deadmines"]           = function(isHeroic) return (isHeroic and 5738 or 1091); end,
	["Shadowfang Keep"]     = function(isHeroic) return (isHeroic and 5739 or 1092); end,
	["Scarlet Monastary"]   = function(isHeroic) return (1093); end,
	["Zul'Farrak"]          = function(isHeroic) return (1094); end,
	["Blackrock Depths"]    = function(isHeroic) return (1095); end,
	["Blackrock Spire"]     = function(isHeroic) return (1096); end,
	["Stratholme"]          = function(isHeroic) return (1097); end,

	["Onyxia's Lair"]       = function(isHeroic) return (1098); end,
	["Molten Core"]         = function(isHeroic) return (1099); end,
	["Blackwing Lair"]      = function(isHeroic) return (1100); end,

	["Zul'Gurub"]           = function(isHeroic) return (1102); end,

	-- BfA
	[15409] = 'BfA',
	["Atal'Dazar"] =            { ["Normal"] = 12720, ["Heroic"] = 12748, ["Mythic"] = 12749 },
	["Freehold"] =              { ["Normal"] = 12750, ["Heroic"] = 12751, ["Mythic"] = 12752 },
	["King's Rest"] =           {                                         ["Mythic"] = 12763 },
	["Shrine of the Storm"] =   { ["Normal"] = 12766, ["Heroic"] = 12767, ["Mythic"] = 12768 },
	["Siege of Boralus"] =      {                                         ["Mythic"] = 12773 },
	["Temple of Sethraliss"] =  { ["Normal"] = 12774, ["Heroic"] = 12775, ["Mythic"] = 12776 },
	["The MOTHERLODE!!"] =      { ["Normal"] = 12777, ["Heroic"] = 12778, ["Mythic"] = 12779 },
	["The Underrot"] =          { ["Normal"] = 12728, ["Heroic"] = 12729, ["Mythic"] = 12745 },
	["Tol Dagar"] =             { ["Normal"] = 12780, ["Heroic"] = 12781, ["Mythic"] = 12782 },
	["Waycrest Manor"] =        { ["Normal"] = 12783, ["Heroic"] = 12784, ["Mythic"] = 12785 },



	-- Burning Crusade
	[14822] = 'Burning Crusade',
--	["Hellfire Citadel: Ramparts"]            = function(isHeroic) return (isHeroic and nil or nil); end,
	["Hellfire Citadel: The Blood Furnace"]   = function(isHeroic) return (isHeroic and 0 or 1068); end,
	["Hellfire Citadel: The Shattered Halls"] = function(isHeroic) return (isHeroic and 0 or 1078); end,
	["Coilfang: The Slave Pens"]              = function(isHeroic) return (isHeroic and 0 or 1071); end,
	["Coilfang: The Underbog"]                = function(isHeroic) return (isHeroic and 0 or 1072); end,
	["Coilfang: The Steamvault"]                        = function(isHeroic) return (isHeroic and 0 or 1077); end,
	["Auchindoun: Mana-Tombs"]                = function(isHeroic) return (isHeroic and 0 or 1069); end,
	["Auchindoun: Auchenai Crypts"]           = function(isHeroic) return (isHeroic and 0 or 1073); end,
	["Auchindoun: Sethekk Halls"]             = function(isHeroic) return (isHeroic and 0 or 1074); end,
	["Auchindoun: Shadow Labyrinth"]          = function(isHeroic) return (isHeroic and 0 or 1075); end,
	["Old Hillsbrad Foothills"]               = function(isHeroic) return (isHeroic and 0 or 0); end,
	["The Escape From Durnholde"]             = function(isHeroic) return (isHeroic and 0 or 1070); end,
	["The Black Morass"]                      = function(isHeroic) return (isHeroic and 0 or 0); end,
	["The Mechanar"]                          = function(isHeroic) return (isHeroic and 0 or 1079); end,
	["The Botanica"]                          = function(isHeroic) return (isHeroic and 0 or 1080); end,
	["The Arcatraz"]                          = function(isHeroic) return (isHeroic and 0 or 1081); end,
	["Magister's Terrace"]                    = function(isHeroic) return (isHeroic and 0 or 1082); end,
	--Opening the Dark portal -- 1076

	["14823"] = "WotLK",
	-- WoLK
	["Utgarde Keep"]               = function(isHeroic) return (isHeroic and 1504 or 1242); end,
	["The Nexus"]                  = function(isHeroic) return (isHeroic and 1505 or 1231); end,
	["Azjol-Nerub"]                = function(isHeroic) return (isHeroic and 1506 or 1232); end,
	["Ahn'kahet: The Old Kingdom"] = function(isHeroic) return (isHeroic and 1507 or 1233); end,
	["Drak'Tharon Keep"]           = function(isHeroic) return (isHeroic and 1508 or 1234); end,
	["The Violet Hold"]            = function(isHeroic) return (isHeroic and 1509 or 1235); end,
	["Gundrak"]                    = function(isHeroic) return (isHeroic and 1510 or 1236); end,
	["Halls of Stone"]             = function(isHeroic) return (isHeroic and 1511 or 1237); end,
	["Halls of Lightning"]         = function(isHeroic) return (isHeroic and 1512 or 1238); end,
	["The Oculus"]                 = function(isHeroic) return (isHeroic and 1513 or 1239); end,
	["Utgarde Pinnacle"]           = function(isHeroic) return (isHeroic and 1514 or 1240); end,
	["The Culling of Stratholme"]  = function(isHeroic) return (isHeroic and 1515 or 1241); end,
	["Trial of the Champion"]      = function(isHeroic) return (isHeroic and 4027 or 4026); end,
	["The Forge of Souls"]         = function(isHeroic) return (isHeroic and 4716 or 4715); end,
	["Pit of Saron"]               = function(isHeroic) return (isHeroic and 4721 or 4720); end,
	["Halls of Reflection"]        = function(isHeroic) return (isHeroic and 4727 or 4726); end,
	-- Raids
	["Icecrown Citadel"]           = function(isHeroic) return (isHeroic and 4686 or 4653); end,

	["15096"] = "Cata",
	["Blackrock Caverns"]        = function(isHeroic) return (isHeroic and 5725 or 5724); end,
	["Throne of the Tides"]      = function(isHeroic) return (isHeroic and 5727 or 5726); end,
	["The Stonecore"]            = function(isHeroic) return (isHeroic and 5729 or 5728); end,
	["The Vortex Pinnacle"]      = function(isHeroic) return (isHeroic and 5731 or 5730); end,
	["Grim Batol"]               = function(isHeroic) return (isHeroic and 5733 or 5732); end,
	["Halls of Origination"]     = function(isHeroic) return (isHeroic and 5735 or 5734); end,
	["Lost City of the Tol'vir"] = function(isHeroic) return (isHeroic and 5737 or 5736); end,
	--[""] = function(isHeroic) return (isHeroic and ); end,
--	[] = function(isHeroic) return (isHeroic and ); end,
--	[] = function(isHeroic) return (isHeroic and ); end,
-- Patch 4.2.0
--
--	["End Time"]={"Murozond"},
--	["End Time - Herioc"]={"Murozond"},
--	["Well of Eternity"]={"Peroth'arn","Azshara","Mannoroth","Varo'then"},
--	["Well of Eternity - Heroic"]={"Peroth'arn","Azshara","Mannoroth","Varo'then"},
--	["Hour of Twilight"]={"Arcurion","Asira Dawnslayer","Archbishop Benedictus"},
--	["Hour of Twilight - Heroic"]={"Arcurion","Asira Dawnslayer","Archbishop Benedictus"},

-- WoD
	["15233"] = "WoD",
	["Bloodmaul Slag Mines"]     = function(isHeroic) return (isHeroic and 9259 or 9258); end,
	["Iron Docks"]               = function(isHeroic) return (isHeroic and 9261 or 9260); end,
	["Auchindoun"]               = function(isHeroic) return (isHeroic and 9263 or 9262); end,
	["Skyreach"]                 = function(isHeroic) return (isHeroic and 9267 or 9266); end,
	-- 100 dungeons
	["Grimrail Depot"]           = function(isHeroic) return (isHeroic and 9269 or 9268); end,
	["The Everbloom"]            = function(isHeroic) return (isHeroic and 9272 or 9271); end,
	["Shadowmoon Burial Grounds"]= function(isHeroic) return (isHeroic and 9274 or 9273); end,
	["Upper Blackrock Spire"]    = function(isHeroic) return (isHeroic and 9276 or 9275); end,


};
