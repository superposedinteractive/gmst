// GMStation - tab plugin

hook.Add("ScoreboardShow", "gmstation_tab", function()
	if(IsValid(GUIElements.tab)) then
		GUIElements.tab:Remove()
	end

	GUIElements.tab = vgui.Create("DPanel")
	GUIElements.tab:SetSize(ScrW(), ScrH())
	GUIElements.tab:SetPos(0, 0)
	GUIElements.tab:SetAlpha(0)
	GUIElements.tab:AlphaTo(255, 0.5)

	GUIElements.tab.Paint = function(self, w, h)
		draw.SimpleLinearGradient(self:GetX(), self:GetY(), w, h, Color(0, 0, 0, self:GetAlpha()), Color(0, 0, 0, 0), true)
		draw.SimpleLinearGradient(self:GetX(), self:GetY(), w, h, Color(0, 0, 0, 0), Color(0, 0, 0, self:GetAlpha()), false)
		draw.SimpleLinearGradient(self:GetX(), self:GetY(), w, h, Color(0, 0, 0, self:GetAlpha()), Color(0, 0, 0, 0), false)
		draw.SimpleLinearGradient(self:GetX(), self:GetY(), w, h, Color(0, 0, 0, 0), Color(0, 0, 0, self:GetAlpha()), true)
		draw.SimpleWavyText("GMStation", "Trebuchet48", w / 2, 32, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, 2)
	end
end)

hook.Add("ScoreboardHide", "gmstation_tab", function()
	if(IsValid(GUIElements.tab)) then
		GUIElements.tab:AlphaTo(0, 0.5, 0, function()
			GUIElements.tab:Remove()
		end)
	end
end)