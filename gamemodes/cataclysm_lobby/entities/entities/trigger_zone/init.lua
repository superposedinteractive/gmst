include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

util.AddNetworkString("cataclysm_zone")

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self:SetTrigger(true)
end

function ENT:KeyValue(key, value)
	if(key == "zoneName") then
		self.zone = value
	end
end

function ENT:StartTouch(ent)
	if(ent:IsPlayer()) then
		ent:SetNWString("zone", self.zone)
		print("Player " .. ent:Nick() .. " entered zone " .. self.zone)

		net.Start("cataclysm_zone")
		net.WriteString(self.zone)
		net.Send(ent)
	end
end