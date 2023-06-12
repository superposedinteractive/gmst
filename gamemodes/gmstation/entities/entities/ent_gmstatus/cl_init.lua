include("shared.lua")

net.Receive("gmstation_bulletin", function()
	local ent = net.ReadEntity()
	ent.gm = ent:GetNWString("gamemode")

	if !ent.gm then return end

	apiCall("game_status", {id = ent.gm}, function(body, length, headers, code)
		ent.inprogress = body.inprogress
		ent.players = body.players
		ent.players_count = body.players_count
	end)
end)

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)

	cam.Start3D2D(pos + ang:Up() + -ang:Right() * 80, ang, 0.1)
		draw.RoundedBox(0, -420, -75, 840, 150, Color(0, 0, 0, 200))
		draw.SimpleText(string.upper(self.gm), "Trebuchet72Bold", 0, 0 - (math.sin(CurTime() * 2) * 10), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if self.inprogress then
			draw.SimpleText("In Progress", "Trebuchet32", 0, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(self.players_count .. " Players", "Trebuchet32", 0, 140, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Not In Progress", "Trebuchet24", 0, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end