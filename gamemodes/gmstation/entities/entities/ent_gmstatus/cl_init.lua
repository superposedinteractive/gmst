include("shared.lua")

net.Receive("gmstation_bulletin", function()
	local ent = net.ReadEntity()
	local use = net.ReadBool()
	ent.gm = ent:GetNWString("gamemode")
	if !ent.gm then return end

	apiCall("game_status", {
		id = ent.gm
	}, function(body, length, headers, code)
		ent.in_progress = body.in_progress
		ent.players = body.players
	end)

	if use && ent.in_progress then
		if CL_GLOBALS.watching == ent.gm then
			CL_GLOBALS.watching = nil
		else
			CL_GLOBALS.watching = ent.gm
			surface.PlaySound("items/gift_drop.wav")
			GMSTBase_Notification(string.upper(ent.gm), "You will be notified when the gamemode is ready.")
		end
	end
end)

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	cam.Start3D2D(pos + ang:Up() + -ang:Right() * 80, ang, 0.1)
	// draw.RoundedBox(0, -420, -130, 840, 580, Color(255, 0, 0, math.sin(CurTime() * 2) * 100 + 100))
	draw.RoundedBox(0, -420, -75, 840, 150, Color(0, 0, 0, 200))
	draw.SimpleText(string.upper(self.gm), "Trebuchet72Bold", 0, 0 - (math.sin(CurTime() * 2) * 10), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if self.in_progress then
		draw.SimpleText("In Progress", "Trebuchet24", 0, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("So in general", "Trebuchet24", 240, 205, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(#self.players, "Trebuchet48Bold", 240, 245, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Players", "Trebuchet24", 240, 280, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Players", "Trebuchet24", -240, 120, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		for k, v in pairs(self.players) do
			draw.SimpleText(v, "Trebuchet24", -320, 120 + (k * 25), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		if CL_GLOBALS.watching == self.gm then
			draw.SimpleText("Press [" .. string.upper(input.LookupBinding("+use")) .. "] to no longer be notified when the gamemode is ready.", "Trebuchet24", 0, 420, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Press [" .. string.upper(input.LookupBinding("+use")) .. "] to be notified when the gamemode is ready.", "Trebuchet24", 0, 420, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		draw.SimpleText("Not In Progress", "Trebuchet24", 0, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("The train is here!", "Trebuchet24", 0, 220, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Step in to join!", "Trebuchet48Bold", 0, 260, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	// draw.SimpleTextOutlined("OUT OF ORDER", "Trebuchet72Bold", 0, 240, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5, Color(0, 0, 0))
	cam.End3D2D()
end
