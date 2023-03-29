// GMStation - tab plugin

hook.Add("ScoreboardShow", "gmstation_tab", function()
	if(IsValid(GUIElements.tab)) then
		GUIElements.tab:Remove()
	end

	GUIElements.tab = vgui.Create("DPanel")
	GUIElements.tab:SetSize(600, 200)
	GUIElements.tab:SetPos(ScrW() - GUIElements.tab:GetWide() - 32, ScrH())
	GUIElements.tab:MoveTo(GUIElements.tab:GetX(), ScrH() - GUIElements.tab:GetTall() - 32, 0.25, 0, 1)

	GUIElements.tab.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
		WavyText("GMStation - Navigation", "Trebuchet24Bold", 8, 9, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, 2)
		draw.SimpleText("Comming Soon!", "Trebuchet24", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

hook.Add("ScoreboardHide", "gmstation_tab", function()
	if(IsValid(GUIElements.tab)) then
		GUIElements.tab:MoveTo(GUIElements.tab:GetX(), ScrH(), 0.25, 0, 1, function()
			GUIElements.tab:Remove()
		end)
	end
end)