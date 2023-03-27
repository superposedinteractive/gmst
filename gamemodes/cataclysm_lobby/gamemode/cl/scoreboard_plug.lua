// cataclysm - Scoreboard plugin

local ScoreboardPanel = {}

hook.Add("ScoreboardShow", "cataclysm_scoreboard", function()
	if(IsValid(ScoreboardPanel.PANEL)) then
		ScoreboardPanel.PANEL:Remove()
	end

	ScoreboardPanel.PANEL = vgui.Create("DPanel")
	ScoreboardPanel.PANEL:SetSize(600, 100)
	ScoreboardPanel.PANEL:CenterHorizontal()
	ScoreboardPanel.PANEL:SetY(ScrH())
	ScoreboardPanel.PANEL:MoveTo(ScoreboardPanel.PANEL:GetX(), ScrH() - 132, 0.5, 0, 1)

	ScoreboardPanel.PANEL.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
		draw.SimpleText("CATACLYSM", "Trebuchet24", 8, 8, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
end)

hook.Add("ScoreboardHide", "cataclysm_scoreboard", function()
	if(IsValid(ScoreboardPanel.PANEL)) then
		ScoreboardPanel.PANEL:MoveTo(ScoreboardPanel.PANEL:GetX(), ScrH(), 0.5, 0, 1, function()
			ScoreboardPanel.PANEL:Remove()
		end)
	end
end)