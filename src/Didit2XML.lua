#!/usr/bin/env lua

dataFile = arg[1]

function FileExists( name )
   local f = io.open( name, "r" )
   if f then io.close( f ) return true else return false end
end
function DoFile( filename )
	local f = assert( loadfile( filename ) )
	return f()
end
if FileExists( dataFile ) then
	DoFile( dataFile )
	if Didit_players then
		strOut = "<?xml version='1.0' encoding='utf-8' ?>\n"
		strOut = strOut .. "<Didit>\n"

		for name, _ in pairs( Didit_players ) do
			if name ~= "NotSet" then
				strOut = strOut .. string.format( '<p name="%s">\n', name)


				for aId, data in pairs( Didit_players[name]	 ) do
					if data.value then
						strOut = strOut .. string.format( '\t<a id="%i" name="%s" value="%i" scanTS="%i"/>\n',
								aId, (data.name or "--"), (data.value == "--" and 0 or data.value), (data.scannedAt or 0) )
					end
				end
				strOut = strOut .."</p>\n"
			end
		end
		strOut = strOut .. "</Didit>\n"
		print(strOut)
	end
end