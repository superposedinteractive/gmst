// cataclysm - cataclysm_controls plugin

hook.Add("ScoreboardShow", "cataclysm_cataclysm_controls", function()
	if(IsValid(HUDElements.cataclysm_controls)) then
		HUDElements.cataclysm_controls:Remove()
	end

	HUDElements.cataclysm_controls = vgui.Create("DPanel")
	HUDElements.cataclysm_controls:SetSize(600, 200)
	HUDElements.cataclysm_controls:SetPos(ScrW() - HUDElements.cataclysm_controls:GetWide() - 32, ScrH())
	HUDElements.cataclysm_controls:MoveTo(HUDElements.cataclysm_controls:GetX(), ScrH() - HUDElements.cataclysm_controls:GetTall() -32, 0.5, 0, 1)

	HUDElements.cataclysm_controls.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
		draw.SimpleText("CATACLYSM", "Trebuchet24", 8, 8, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("Controls", "Trebuchet18", 8, 32, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
end)

hook.Add("ScoreboardHide", "cataclysm_cataclysm_controls", function()
	if(IsValid(HUDElements.cataclysm_controls)) then
		HUDElements.cataclysm_controls:MoveTo(HUDElements.cataclysm_controls:GetX(), ScrH(), 0.5, 0, 1, function()
			HUDElements.cataclysm_controls:Remove()
		end)
	end
end)