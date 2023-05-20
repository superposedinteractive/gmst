include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

net.Receive("nk_captured", function()
	local ply = net.ReadEntity()
	local teeam = net.ReadInt(3)
	rk_notice(ply:Nick() .. " has the " .. team.GetName(teeam) .. " flag!", teeam)
end)