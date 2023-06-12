include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
util.AddNetworkString("gmstation_bulletin")


timer.Create("nogmsatalpha", 120, 0, function()
	net.Start("gmstation_announcement")
		net.WriteString("I would like to apologize that the gamemodes are not yet ready. I'm working on them as fast I can. Thank you for your patience.")
	net.Broadcast()
end)