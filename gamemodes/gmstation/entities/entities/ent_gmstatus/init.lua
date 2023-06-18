include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
util.AddNetworkString("gmstation_bulletin")

function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		net.Start("gmstation_bulletin")
			net.WriteEntity(self)
			net.WriteBool(true)
		net.Send(activator)
	end
end