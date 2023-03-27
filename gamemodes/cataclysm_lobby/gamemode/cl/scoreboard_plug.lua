// cataclysm - cataclysm_controls plugin

local cataclysm_controls

hook.Add("ScoreboardShow", "cataclysm_cataclysm_controls", function()
	if(IsValid(cataclysm_controls)) then
		cataclysm_controls:Remove()
	end

	cataclysm_controls = vgui.Create("DPanel")
	cataclysm_controls:SetSize(600, 200)
	cataclysm_controls:SetPos(ScrW() - cataclysm_controls:GetWide() - 32, ScrH())
	cataclysm_controls:MoveTo(cataclysm_controls:GetX(), ScrH() - cataclysm_controls:GetTall() - 32, 0.25, 0, 1)

	cataclysm_controls.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
		WavyText("CONTROLS", "Trebuchet24Bold", 8, 9, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, 2)
	end
end)

hook.Add("ScoreboardHide", "cataclysm_cataclysm_controls", function()
	if(IsValid(cataclysm_controls)) then
		cataclysm_controls:MoveTo(cataclysm_controls:GetX(), ScrH(), 0.25, 0, 1, function()
			cataclysm_controls:Remove()
		end)
	end
end)