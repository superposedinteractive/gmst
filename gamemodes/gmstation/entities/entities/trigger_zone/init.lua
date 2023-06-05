include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
util.AddNetworkString("gmstation_zone")

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self:SetTrigger(true)
end

function ENT:KeyValue(key, value)
	if key == "zoneName" then
		self.zone = value
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		ent:SetNW2String("zone", self.zone)
		MsgN("[GMST] Player " .. ent:Name() .. " entered zone " .. self.zone)
		net.Start("gmstation_zone")
		net.WriteString(self.zone)
		net.Send(ent)
	end
end
