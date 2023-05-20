ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Flag"

function ENT:Initialize()
	self:SetModel("models/props_combine/breenbust.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	if SERVER then
		self:SetTrigger(true)
	end
end