include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
util.AddNetworkString("gmstation_bulletin")

timer.Create("nogmsatalpha", 60 * 6, 0, function()
	net.Start("gmstation_announcement")
		net.WriteString("I would like to apologize that the gamemodes are not yet ready. I'm working on them as fast as I can. Thank you for your patience.")
	net.Broadcast()
end)

function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		net.Start("gmstation_bulletin")
			net.WriteEntity(self)
			net.WriteBool(true)
		net.Send(activator)
	end
end