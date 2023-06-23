include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
util.AddNetworkString("nk_captured")
ENT.team = 2
ENT.grav = 0

function ENT:KeyValue(key, value)
	if key == "team" then
		print("Setting team to "..value)
		self.team = value
	end
end

function ENT:StartTouch(ent)
	if !ent:IsPlayer() then return end
	if !ent:Alive() then return end

	local captured = IsValid(self:GetNWEntity("capturer"))

	if ent:Team() != self.team && !captured then
		net.Start("nk_captured")
			net.WriteEntity(ent)
			net.WriteInt(self.team, 3)
		net.Broadcast()

		self:SetNWEntity("capturer", ent)
		ent.flag = self
	else
		if ent:Team() == self.team then
			MsgN("Returning")
			self:SetNWEntity("capturer", nil)
		end
	end
end

function ENT:Think()
	local capturer = self:GetNWEntity("capturer")
	self:SetNWEntity("capturer", capturer)
	-- feels so hacky

	if IsValid(capturer) then
		self:SetPos(capturer:GetPos() + Vector(0, 0, 50))
		self.grav = 10
	else
		local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() + Vector(0, 0, -10),
			filter = self
		})

		self.grav = self.grav - FrameTime() * 100

		if tr.Hit then
			self.grav = -self.grav * 0.5
		end

		if self.grav >= 2 || self.grav <= -2 then
			self:SetPos(self:GetPos() + Vector(0, 0, self.grav))
		end
	end

	local magnitude = self:GetPos():Distance(self.base_coords)

	if magnitude > 5 && !IsValid(capturer) then
		if !self.ty then
			self.ty = 0
		end

		self.ty = self.ty + 1

		if self.ty > 100 then
			self:SetPos(self.base_coords)
			self.ty = 0
			MsgN("[Rocketeers] Flag reset")
		end
	end

	self:NextThink(CurTime() + 0.1)
	return true
end