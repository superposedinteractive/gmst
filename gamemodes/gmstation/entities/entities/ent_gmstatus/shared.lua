ENT.Type = "anim"
ENT.Base = "base_gmodentity"

function ENT:KeyValue(key, value)
	self:SetNWString(key, value)
	print(key, value)
end

function ENT:Initialize()
	self:SetModel("models/props_office/whiteboard.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self.gm = "???"
	self.in_progress = false
	self.players = {}
	self.players_count = 0

	if SERVER then
		self:SetUseType(SIMPLE_USE)

		timer.Create(tostring(self) .. "_gmupdate", 5, 0, function()
			net.Start("gmstation_bulletin")
			net.WriteEntity(self)
			net.Broadcast()
		end)
	end
end
