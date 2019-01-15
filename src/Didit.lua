-------------------------------------------
-- Didit 2
--------------------------------------------
-- Based on an addon by Parq of Bloodhoof
-- Updated by Sistersally of Hyjal
--------------------------------------------

-- Colours
COLOR_RED = "|cffff0000"
COLOR_GREEN = "|cff00ff00"
COLOR_BLUE = "|cff0000ff"
COLOR_PURPLE = "|cff700090"
COLOR_YELLOW = "|cffffff00"
COLOR_ORANGE = "|cffff6d00"
COLOR_GREY = "|cff808080"
COLOR_GOLD = "|cffcfb52b"
COLOR_NEON_BLUE = "|cff4d4dff"
COLOR_END = "|r"

Didit.lookupPre = "party"
--Didit = {};  -- set in DiditData
Didit_players= {}  -- Didit.players[unitName][statID] = {["lookup"] = lookupString};
function Didit.OnLoad()
	SLASH_DIDIT1 = '/didit'
	SlashCmdList["DIDIT"] = function(msg) Didit.Cmd(msg); end

	DiditFrame:RegisterEvent( "GROUP_ROSTER_UPDATE" )
	DiditFrame:RegisterEvent( "ACHIEVEMENT_EARNED" )
	DiditFrame:RegisterEvent( "PLAYER_ENTERING_WORLD" )
	GameTooltip:HookScript( "OnTooltipSetUnit", Didit.TooltipHook )
	Didit.myName = UnitName( "player" )
	Didit.Debug( "Starting Didit up" )
end
function Didit.Print( msg, showName )
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	if (showName == nil) or (showName) then
		--msg = COLOR_RED.."Didit> "..COLOR_END..msg;
		msg = COLOR_NEON_BLUE.."Didit> "..COLOR_END..msg
	end
	DEFAULT_CHAT_FRAME:AddMessage( msg );
end
function Didit.Debug( msg )
	if Didit.debug then
		Didit.Print( msg );
	end
end
function Didit.GROUP_ROSTER_UPDATE()
	-- code for when party members are changed
	--
	Didit.Debug( "GROUP_ROSTER_UPDATE" )
	-- scan the players
	for i = 1, GetNumGroupMembers() do
		local lookupString = Didit.lookupPre..i
		local unitName = GetUnitName( lookupString ) or "NotSet"
		Didit.Debug( ("unitName: %s"):format( unitName or "Not Set" ) )
		if not Didit_players[unitName] then
			Didit_players[unitName] = {}
			Didit.Print( ("init player: %s"):format( unitName ) )
		end
		if Didit.statisticID and not Didit_players[unitName][Didit.statisticID] then
			Didit.Print( ("  I haz a statisticID(%s) and need to init %s"):format( Didit.statisticID, unitName ) )
			Didit_players[unitName][Didit.statisticID] = { Started = "Yes" }
		end
	end
	if not Didit_players[Didit.myName] then
		Didit_players[Didit.myName] = {}
	end
end
function Didit.PLAYER_ENTERING_WORLD()
	-- code to run when entering the world
	Didit.Print( "Player Entering World" )
	inInstance, lookupPre = IsInInstance()  -- 1nil, string( arena, none, party, pvp, raid)
	Didit.lookupPre = lookupPre

	Didit.Print( (inInstance and "IN" or "NOT IN").." instance type:"..( Didit.lookupPre or "nil" ) )
	if( inInstance ) then
		local iName, iType, iDiff = GetInstanceInfo()
		local iDiffStr = GetDifficultyInfo( iDiff )
		-- https://wow.gamepedia.com/DifficultyID
		-- /run for i=1, 34 do print(i, (GetDifficultyInfo(i))) end
		-- diff:  1 = Normal, 2 = Heroic, 23 = Mythic, 24,33=Timewalking
		Didit.Print( string.format( "%s (%s)", (iName or "nil"), (iDiff or "nil") ) )
		Didit.inDungeon = true
		Didit.statisticID = ( Didit.data[iName] and Didit.data[iName][iDiffStr] )
				and Didit.data[iName][iDiffStr] or 932  -- 932 is # of 5 man dungeons entered
		Didit.Print( string.format( "Stat #: %s (%s - %s)", Didit.statisticID, select( 2, GetAchievementInfo( Didit.statisticID ) ), iDiffStr ) )
		Didit.Print( ("value: %s"):format( GetStatistic( Didit.statisticID ) ) )



		Didit_players[Didit.myName] = { [Didit.statisticID] = {} }
		Didit_players[Didit.myName][Didit.statisticID]["value"] = GetStatistic( Didit.statisticID )
		Didit_players[Didit.myName][Didit.statisticID]["dungeon"] = select( 2, GetDifficultyInfo( Didit.statisticID ) )
		-- Didit.ScanPlayers()  -- removed?
	else
		Didit.Print( "Not in Dungeon" )
		Didit.inDungeon = nil
	end
end
function Didit.ACHIEVEMENT_EARNED( achievementId )
	Didit.Print("An achievement (id:"..(achievementId or "bleh")..") has been earned.");
end
function Didit.INSPECT_ACHIEVEMENT_READY()
	-- code to run when achievement compare is ready
	Didit.Print( "Stat came back for: "..Didit.scanName )
	if Didit.statisticID then
		Didit_players[Didit.scanName][Didit.statisticID]["value"] = GetComparisonStatistic( Didit.statisticID )
		Didit_players[Didit.scanName][Didit.statisticID]["name"] = select( 2, GetAchievementInfo( Didit.statisticID ) )
		Didit_players[Didit.scanName][Didit.statisticID]["scannedAt"] = time()
		if Didit_players[Didit.scanName].error then  -- clear error text on successful scan
			Didit_players[Didit.scanName].error = nil
		end
		Didit.scanName = nil
	end
	DiditFrame:UnregisterEvent( "INSPECT_ACHIEVEMENT_READY" )
	ClearAchievementComparisonUnit()
	--Didit.Report();
	Didit.ScanPlayers()
end
function Didit.ScanPlayers()
	-- scan the players
	Didit.Print( "Starting the scan of players" )
	if Didit.statisticID and not Didit.scanName then
		Didit.Print( "StatID: "..Didit.statisticID.." not currently scanning " )
		for i = 0, GetNumGroupMembers() do
			local lookupString = i>0 and Didit.lookupPre..i or "player"
			local unitName = GetUnitName( lookupString ) or "NotSet"
			Didit.Print( "unitName: "..unitName )
			struct = Didit_players[unitName]
			if struct and
					(not struct[Didit.statisticID].value or struct[Didit.statisticID].scannedAt+3600 < time()) then
					-- missing the value, or the data is older than an hour
				Didit.Print( string.format( "Scanning: %s (%s)", lookupString, unitName ) )
				if CheckInteractDistance( lookupString, 1 ) then  -- 1=inspect range
					SetAchievementComparisonUnit( lookupString )
					Didit.scanName = unitName
					DiditFrame:RegisterEvent( "INSPECT_ACHIEVEMENT_READY" )
					Didit.Print( "In range to inspect: "..Didit.scanName )
					break  -- only scan one at a time - break the for loop
				else  -- out of range to inspect
					Didit_players[unitName]["error"] = "Out of Range"
					Didit.Print( unitName.." is out of range" )
				end
			end
		end
		Didit.Print( "Ending scan at: "..date("%X %x") )
--	else
--		Didit.Print("No statID");
	end

end
function Didit.Report( chatChannel )
	-- INSTANCE, PARTY, GUILD, SAY
	if( chatChannel == "INSTANCE" and not IsInGroup( LE_PARTY_CATEGORY_INSTANCE ) ) then
		chatChannel = "PARTY"
	end
	if( chatChannel == "INSTANCE" ) then
		chatChannel = "INSTANCE_CHAT"
	end
	if( chatChannel == "PARTY" and not IsInGroup() ) then
		chatChannel = "SAY"
	end
	if( chatChannel == "GUILD" and not IsInGuild() ) then
		chatChannel = "SAY"
	end

	if Didit.statisticID then
		Didit.report = {}
		table.insert( Didit.report, string.format( "How many %s do *you* have?", select( 2, GetAchievementInfo( Didit.statisticID ) ) ) )
		for i = 0, GetNumGroupMembers() do
			local lookupString = i>0 and Didit.lookupPre..i or "player"
			local unitName = GetUnitName( lookupString )
			local playerInfo = Didit_players[unitName]
			local reportLine = ""
			if playerInfo then
				print( "I have playerInfo" )
				if playerInfo[Didit.statisticID].value then
					print( unitName.." has a value for "..Didit.statisticID )
					reportLine = string.format( "... %s for %s", playerInfo[Didit.statisticID].value, unitName )
				elseif playerInfo.error then
					print( unitName.." has an error" )
					reportLine = string.format( "Error: %s for %s", playerInfo.error, unitName )
				else
					reportLine = string.format( "%s has not yet been scanned.", unitName )
				end
			end
			Didit.Print( string.format( "%s for %s = %s",
					( Didit.statisticID or "nil" ),
					( unitName or "nil" ),
					( playerInfo[Didit.statisticID].value or "nil" )
			) )
			table.insert( Didit.report, reportLine )
		end
		for i, reportLine in pairs( Didit.report ) do
			if( chatChannel ) then
				SendChatMessage( reportLine, chatChannel )
			else
				Didit.Print( reportLine, false )
			end
		end
	else
		Didit.Print( "No statistic to report on" )
	end
end
function Didit.TooltipHook()
	if Didit.inDungeon then
		Didit.tooltipName = GetUnitName( "mouseover" )
		Didit.Debug( ("tooltipName: %s"):format( Didit.tooltipName or "nil" ) )
		if Didit_players[Didit.tooltipName] and Didit_players[Didit.tooltipName][Didit.statisticID] then
			Didit.Debug( "I know both the player, and a statID for them." )
			if Didit_players[Didit.tooltipName][Didit.statisticID].value then
				GameTooltip:AddLine( string.format( "Didit (%s): %s",
						select( 2, GetAchievementInfo( Didit.statisticID ) ),
						Didit_players[Didit.tooltipName][Didit.statisticID].value ) )
			else
				GameTooltip:AddLine( "Didit?" )
				Didit.Print( "Scan Players?" )
				Didit.ScanPlayers()
			end
		end
	end
end

Didit.commandList = {
	["instance"] = {
		["help"] = "Display report to the instance",
		["cmd"] = function() Didit.Report( "INSTANCE" ); end,
	},
	["party"] = {
		["help"] = "Display report to the party",
		["cmd"] = function() Didit.Report( "PARTY" ); end,
	},
	["guild"] = {
		["help"] = "Display report to guild",
		["cmd"] = function() Didit.Report( "GUILD" ); end,
	},
	["say"] = {
		["help"] = "Display report to say",
		["cmd"] = function() Didit.Report( "SAY" ); end,
	},
	["help"] = {
		["help"] = "Show this list",
		["cmd"] = Didit.PrintHelp,
	},
	["gather"] = {
		["help"] = "Gather data",
		["cmd"] = Didit.GatherData,
	},
	["debug"] = {
		["help"] = "Toggle Debug",
		["cmd"] = function() Didit.debug = not Didit.debug; Didit.Print("Debug: "..(Didit.debug and "true" or "false")); end,
	},
}
function Didit.ParseCmd(msg)
	if msg then
		msg = string.lower(msg)
		local a,b,c = strfind(msg, "(%S+)") --contiguous string of non-space characters
		if a then
			return c, strsub(msg, b+2)
		else
			return ""
		end
	end
end
function Didit.Cmd(msg)
	local cmd, param = Didit.ParseCmd( msg )
	if Didit.commandList[cmd] then
		Didit.commandList[cmd].cmd()
	else
		Didit.Report()
	end
end
function Didit.PrintHelp()
	local helpPre = "/Didit "
	Didit.Print( helpPre )
	for cmd, struct in pairs( Didit.commandList ) do
		Didit.Print( helpPre..cmd.." -> "..struct.help )
	end
end
function Didit.GatherData()
	local dnr = 15062;    -- dungeons & raids category
	dnr = 14822;
	dnr = 15096;
	dnr = 15233
	dnr = 15409
	for i = 1, GetCategoryNumAchievements(dnr) do
		local id, name, points, _, _, _, desc, _, _, _ = GetAchievementInfo(dnr, i);
		points = GetStatistic(id);
		Didit.Print(name.." ("..id..") = "..points);
	end
	--[[
	local listTable = GetStatisticsCategoryList();
	for _,cat in pairs(listTable) do
		Didit.Print(cat..":"..GetCategoryInfo(cat));
	end
	]]
end
