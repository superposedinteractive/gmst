include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

util.AddNetworkString("nk_captured")

ENT.team = 0

function ENT:KeyValue(key, value)
	if key == "team" then
		self.team = value
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() && ent:Team() != self.team then
		self:SetNWEntity("capturer", ent)
		net.Start("nk_captured")
			net.WriteEntity(ent)
			net.WriteInt(self.team, 3)
		net.Broadcast()
	else
		if ent.captured then
			MsgN("Returning")
		end
	end
end