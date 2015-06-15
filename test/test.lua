#!/usr/bin/env lua

addonData = { ["Version"] = "1.0",
}

require "wowTest"

test.outFileName = "testOut.xml"

-- Figure out how to parse the XML here, until then....
DiditFrame = CreateFrame()
SendMailNameEditBox = CreateFontString("SendMailNameEditBox")

-- require the file to test
package.path = "../src/?.lua;'" .. package.path
require "DiditData"
require "Didit"


function test.before()
	Didit.OnLoad()
end
function test.after()
end

test.run()
