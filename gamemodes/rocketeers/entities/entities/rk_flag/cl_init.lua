include("shared.lua")

ENT.capturer = nil

function ENT:Draw()
	if IsValid(self.capturer) then
		local bone = self.capturer:LookupBone("ValveBiped.Bip01_Spine2")
		local pos, ang = self.capturer:GetBonePosition(bone)
		local pos2 = pos + ang:Forward() * 10
		local ang2 = ang

		ang2:RotateAroundAxis(ang2:Right(), -90)
		ang2:RotateAroundAxis(ang2:Up(), 90)
		ang2:RotateAroundAxis(ang2:Right(), 40)

		self:SetPos(pos2)
		self:SetAngles(ang2)
	end

	if self.capturer != LocalPlayer() then
		self:DrawModel()
	end
end

net.Receive("nk_captured", function()
	local ply = net.ReadEntity()
	local teeam = net.ReadInt(3)

	MsgN(ply:Nick() .. " has the " .. team.GetName(teeam) .. " flag!")
	rk_notice(ply:Nick() .. " has the " .. team.GetName(teeam) .. " flag!", teeam)
end)

function ENT:Think()
	self.capturer = self:GetNWEntity("capturer", nil)
end