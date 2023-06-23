ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Flag"

function ENT:Initialize()
	self:SetModel("models/flag/flag.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_CUSTOM)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	self:DrawShadow(false)
	self:SetNoDraw(false)

	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(Vector(-16, -16, -16), Vector(16, 16, 16))

	if SERVER then
		self:SetTrigger(true)
		self:NextThink(CurTime() + 0.1)

		timer.Simple(0.1, function()
			self.base_coords = self:GetPos()
		end)
	end
end
