util.AddNetworkString("gmstation_store")

include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	self:SetModel("models/humans/group01/female_02.mdl")

	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)

	self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD)
end

function ENT:KeyValue(key, value)
	self[key] = value
	MsgN("GMStation: ", key, " = ", value)
end

function ENT:Use(activator, caller, useType, value)
	if activator:IsPlayer() then
		net.Start("gmstation_store")
			net.WriteString(self.store || "unknown")
			net.WriteString(self.message || "Welcome!")
			net.WriteString(self.exitMessage || "Goodbye!")
		net.Send(activator)
	end
end