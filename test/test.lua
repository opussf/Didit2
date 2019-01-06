#!/usr/bin/env lua

addonData = { ["Version"] = "1.0",
}

require "wowTest"

test.outFileName = "testOut.xml"

-- Figure out how to parse the XML here, until then....
DiditFrame = CreateFrame()
SendMailNameEditBox = CreateFontString("SendMailNameEditBox")
GameTooltip = CreateFrame( "GameTooltip", "tooltip" )

-- require the file to test
package.path = "../src/?.lua;'" .. package.path
require "DiditData"
require "Didit"


function test.before()
	Didit.OnLoad()
end
function test.after()
end

function test.test_EventRegistered_GROUP_ROSTER_UPDATE()
	assertTrue( DiditFrame.Events.GROUP_ROSTER_UPDATE )
end
function test.test_EventRegistered_ACHIEVEMENT_EARNED()
	assertTrue( DiditFrame.Events.ACHIEVEMENT_EARNED )
end
function test.test_EventRegistered_PLAYER_ENTERING_WORLD()
	assertTrue( DiditFrame.Events.PLAYER_ENTERING_WORLD )
end
function test.test_DoEvent_GROUP_ROSTER_UPDATE()
	Didit.GROUP_ROSTER_UPDATE()
end
function test.test_DoEvent_ACIEVEMENT_EARNED()
	Didit.ACHIEVEMENT_EARNED()
end
function test.test_DoEvent_PLAYER_ENTERING_WORLD()
	Didit.PLAYER_ENTERING_WORLD()
end
function test.test_DoCmd_01()
	Didit.Cmd()
end



test.run()
