ENT.Type = "anim"
ENT.Base = "base_gmodentity"

function ENT:Initialize()
	self:SetModel("models/props_office/whiteboard.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)

	self.gm = "???"
	self.inprogress = false
	self.players = {}
	self.players_count = 0

	function self:GetQueue()
		self.queue = {}
		for k, v in pairs(self.players) do
			table.insert(queue, v)
		end
		return queue
	end

	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end
end

