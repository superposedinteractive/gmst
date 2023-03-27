include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

util.AddNetworkString("cataclysm_zone")

local zone

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self:SetTrigger(true)
end

function ENT:KeyValue(key, value)
	if(key == "zone_name") then
		zone = value
	end
end

function ENT:StartTouch(ent)
	if(ent:IsPlayer()) then
		ent:SetNWString("zone", zone)
		print("Player " .. ent:Nick() .. " entered zone " .. zone)
	end
end