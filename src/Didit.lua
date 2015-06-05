-------------------------------------------
-- Didit 2
--------------------------------------------
-- Based on an addon by Parq of Bloodhoof
-- Updated by Sistersally of Hyjal
--------------------------------------------

-- Colours
COLOR_RED = "|cffff0000";
COLOR_GREEN = "|cff00ff00";
COLOR_BLUE = "|cff0000ff";
COLOR_PURPLE = "|cff700090";
COLOR_YELLOW = "|cffffff00";
COLOR_ORANGE = "|cffff6d00";
COLOR_GREY = "|cff808080";
COLOR_GOLD = "|cffcfb52b";
COLOR_NEON_BLUE = "|cff4d4dff";
COLOR_END = "|r";

--Didit = {};  -- set in DiditData
Didit_players= {};  -- Didit.players[unitName][statID] = {["lookup"] = lookupString};

function Didit.OnLoad()
	SLASH_DIDIT1 = '/didit';
	SlashCmdList["DIDIT"] = function(msg) Didit.Cmd(msg); end

	DiditFrame:RegisterEvent("PARTY_MEMBERS_CHANGED");
	DiditFrame:RegisterEvent("GROUP_ROSTER_UPDATE");
	DiditFrame:RegisterEvent("ACHIEVEMENT_EARNED");
	DiditFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	GameTooltip:HookScript("OnTooltipSetUnit", Didit.TooltipHook);
	Didit_players = {};
	Didit.Print("Starting Didit up");
end

function Didit.GROUP_ROSTER_UPDATE()
	-- code for when party members are changed
	-- 
	Didit.Print("Party Members changed");
	for unitName, struct in pairs(Didit_players) do
		Didit_players[unitName].lookup = nil;
	end
	for i = 1,GetNumGroupMembers() do -- MAX_PARTY_MEMBERS
		local lookupString = "party"..i;
		local unitName = GetUnitName(lookupString) or "NotSet";
		--Didit.Debug("unitName: "..(unitName or "Not Set"));
		if Didit_players[unitName] then
			--Didit.Debug("  Set: "..unitName.." ("..lookupString..")");
			Didit_players[unitName].lookup = lookupString;
		else
			--Didit.Debug("  Need to init player:"..unitName);
			Didit_players[unitName] = {["lookup"] = lookupString};
		end
		if Didit.statisticID and not Didit_players[unitName][Didit.statisticID] then
			--Didit.Debug("  I haz a statisticID("..Didit.statisticID..") and need to init");
			Didit_players[unitName][Didit.statisticID] = {};
		end
		Didit.Debug(string.format("%s (%s): %s", unitName, Didit_players[unitName]["lookup"], Didit_players[unitName]["error"] or ""));
	end
	if not Didit_players[UnitName("player")] then
		Didit_players[UnitName("player")] = {};
	end
end
function Didit.PLAYER_ENTERING_WORLD()
	-- code to run when entering the world
	Didit.Debug("Player Entering World");
	local inInstance, instanceType = IsInInstance();  -- 1nil, string( arena, none, party, pvp, raid)
	if (inInstance) then
		local iName, iType, iDiff = GetInstanceInfo();
		Didit.inDungeon = true;
		if Didit.data[iName] then
			Didit.statisticID = Didit.data[iName](iDiff == 2);
		else
			Didit.statisticID = 932;  -- 932 is # of 5 mans entered
			Didit.Print("No statisticID known for "..iName);
		end
		if iType and iDiff then
			Didit.Print("Welcome to: "..iName.." ("..iType..":"..iDiff..")");
			if Didit.statisticID then
				Didit.Print("Stat #: "..Didit.statisticID.." ("..select(2,GetAchievementInfo(Didit.statisticID))..")");
				-- Scan self
				Didit_players[UnitName("player")] = {[Didit.statisticID] = {}};
				Didit_players[UnitName("player")][Didit.statisticID]["value"] = GetStatistic(Didit.statisticID);
				--Didit.ScanPlayers();
			end
		end
	else
		Didit.Print("Not in Dungeon");
		Didit.inDungeon = nil;
	end
end
function Didit.ACHIEVEMENT_EARNED( achievementId )
	Didit.Print("An achievement (id:"..(achievementId or "bleh")..") has been earned.");
end
function Didit.INSPECT_ACHIEVEMENT_READY()
	-- code to run when achievement compare is ready
	Didit.Debug("Stat came back for: "..Didit.scanName);
	if Didit.statisticID then
		Didit_players[Didit.scanName][Didit.statisticID]["value"] = GetComparisonStatistic(Didit.statisticID);
		Didit_players[Didit.scanName][Didit.statisticID]["name"] = select(2,GetAchievementInfo(Didit.statisticID));
		Didit_players[Didit.scanName][Didit.statisticID]["scannedAt"] = time();
		if Didit_players[Didit.scanName].error then  -- clear error text on successful scan
			Didit_players[Didit.scanName].error = nil;
		end
		Didit.scanName = nil;
	end
	DiditFrame:UnregisterEvent("INSPECT_ACHIEVEMENT_READY");
	ClearAchievementComparisonUnit();
	--Didit.Report();
end
function Didit.ScanPlayers()
	-- scan the players
	Didit.Debug("Starting the scan of players");
	if Didit.statisticID and not Didit.scanName then
		for unitName, struct in pairs(Didit_players) do
			if struct.lookup and -- has the lookup text
					(not struct[Didit.statisticID].value or struct[Didit.statisticID].scannedAt+3600 < time()) then
					-- missing the value, or the data is older than an hour
				Didit.Debug(string.format("Scanning: %s (%s)", struct.lookup, unitName));
				if CheckInteractDistance(struct.lookup, 1) then  -- 1=inspect range
					SetAchievementComparisonUnit(struct.lookup);
					Didit.scanName = unitName;
					DiditFrame:RegisterEvent("INSPECT_ACHIEVEMENT_READY");
					Didit.Debug("In range to inspect: "..Didit.scanName);
					break;
				else  -- out of range to inspect
					Didit_players[unitName]["error"] = "Out of Range";
					Didit.Print(unitName.." is out of range");
				end
			end
		end
		Didit.Debug("Ending scan at: "..date("%X %x"));
--	else
--		Didit.Print("No statID");
	end
end
function Didit.Report( toParty )
	if Didit.statisticID then
		Didit.toParty = toParty;
		Didit.Debug("Report for "..select(2,GetAchievementInfo(Didit.statisticID)));
		Didit.Print("How many "..select(2, GetAchievementInfo(Didit.statisticID)).." do *you* have?", false);
		for i = 0,GetNumGroupMembers() do -- MAX_PARTY_MEMBERS
			local lookupString = i>0 and "party"..i or "player";
			local unitName = GetUnitName(lookupString);
			Didit.Debug(lookupString..":"..(unitName or "Not Set"));
			local playerInfo = Didit_players[unitName];
			if playerInfo and playerInfo[Didit.statisticID].value then
				Didit.Print(string.format("... %s for %s", playerInfo[Didit.statisticID].value, unitName), false);
			elseif playerInfo and playerInfo.error then
				Didit.Print(string.format("Error: %s for %s", playerInfo.error, unitName), false);
			elseif unitName then
				Didit.Print(string.format("%s has not yet been scanned.", unitName), false);
			end
		end
		Didit.toParty = nil;
	else
		Didit.Print("No statistic to report on");
	end
end
function Didit.TooltipHook()
	if Didit.inDungeon then
		--Didit.tooltipName = GameTooltip:GetUnit();
		Didit.tooltipName = GetUnitName("mouseover");
		if Didit_players[Didit.tooltipName] and Didit_players[Didit.tooltipName][Didit.statisticID] then
			if Didit_players[Didit.tooltipName][Didit.statisticID].value then
				GameTooltip:AddLine(string.format("Didit (%s): %s",
						select(2,GetAchievementInfo(Didit.statisticID)),
						--Didit.statisticID, 
						Didit_players[Didit.tooltipName][Didit.statisticID].value));
			else
				GameTooltip:AddLine("Didit?");
				Didit.ScanPlayers();
			end
		end
	end
end
Didit.commandList = {
	["party"] = {
		["help"] = "Display report to the party",
		["cmd"] = function() Didit.Report( true ); end,
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
function Didit.Cmd(msg)
	local cmd, param = Didit.ParseCmd(msg);
	if Didit.commandList[cmd] then
		Didit.commandList[cmd].cmd();
	else
		Didit.Report();
	end
end
function Didit.ParseCmd(msg)
	if msg then
		msg = string.lower(msg);
		local a,b,c = strfind(msg, "(%S+)");  --contiguous string of non-space characters
		if a then
			return c, strsub(msg, b+2);
		else
			return "";
		end
	end
end
function Didit.PrintHelp()
	local helpPre = "/Didit ";
	Didit.Print(helpPre);
	for cmd, struct in pairs(Didit.commandList) do
		Didit.Print(helpPre..cmd.." -> "..struct.help);
	end
end
function Didit.GatherData()
	local dnr = 15062;    -- dungeons & raids category
	dnr = 14822;
	dnr = 15096;
	for i = 1, GetCategoryNumAchievements(dnr) do
		local id, name, points, _, _, _, desc, _, _, _ = GetAchievementInfo(dnr, i);
		points = GetStatistic(id);
		Didit.Print(name.." ("..id..") = "..points);
	end
	local listTable = GetStatisticsCategoryList();
	for _,cat in pairs(listTable) do
		Didit.Print(cat..":"..GetCategoryInfo(cat));
		
	end
end
function Didit.Print( msg, showName)
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	if (showName == nil) or (showName) then
		msg = COLOR_RED.."Didit> "..COLOR_END..msg;
	end
	if (Didit.toParty and IsInGroup() ) then
		SendChatMessage( msg, "PARTY" );
	else
		DEFAULT_CHAT_FRAME:AddMessage( msg );
	end
end
function Didit.Debug( msg )
	if Didit.debug then
		Didit.Print( msg );
	end
end

