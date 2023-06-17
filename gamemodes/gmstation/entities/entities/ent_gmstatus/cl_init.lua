include("shared.lua")

net.Receive("gmstation_bulletin", function()
	local ent = net.ReadEntity()
	ent.gm = ent:GetNWString("gamemode")

	if !ent.gm then return end

	ent.timeofarrival = ent:GetNWInt("timeofarrival")

	apiCall("game_status", {id = ent.gm}, function(body, length, headers, code)
		ent.inprogress = body.inprogress
		-- ent.players = body.players
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

		if !self.inprogress then
			draw.SimpleText("In Progress", "Trebuchet24", 0, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("So in general", "Trebuchet24", 240, 220, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(#self.players, "Trebuchet48Bold", 240, 264, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Players", "Trebuchet24", 240, 300, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
			draw.SimpleText("Players", "Trebuchet24", -240, 120, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			-- for k, v in pairs(self.players) do
			for k, v in pairs({{name = "niggerman1"},{name = "niggerman2"},{name = "niggerman3"},{name = "niggerman4"},{name = "niggerman5"},{name = "niggerman6"},{name = "niggerman7"},{name = "niggerman8"},{name = "niggerman9"},{name = "niggerman10"},}) do
				draw.SimpleText(v.name, "Trebuchet24", -320, 120 + (k * 25), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		else
			draw.SimpleText("Not In Progress", "Trebuchet24", 0, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Arriving In", "Trebuchet24", 0, 220, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			local time = self.timeofarrival - os.time()

			if time > 0 then
				if time > 60 then
					draw.SimpleText(math.floor(time / 60) .. " minutes", "Trebuchet48Bold", 0, 260, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText(time .. " seconds", "Trebuchet48Bold", 0, 260, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			else
				draw.SimpleText("Get in there!", "Trebuchet48Bold", 0, 260, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	cam.End3D2D()
end