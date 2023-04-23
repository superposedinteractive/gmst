// GMStation - tab plugin

local bgColor = Color(25, 25, 25, 200)
local headerColor = Color(0, 120, 255, 255)
local rowColor1 = Color(0, 102, 218)
local rowColor2 = Color(0, 78, 167, 200)
local textColor = Color(255, 255, 255, 255)
local textColor2 = Color(255, 255, 255, 100)

local blurscreen = Material("pp/blurscreen")
local playerGradient = Material("gmstation/ui/ply_gradient.png")

local optionTypes = {
	["SLIDER"] = 1,
	["CHECKBOX"] = 2,
}

local tabs = {
	"Players",
	"Settings"
}

local settings = {
	["Music Volume"] = {"volume", optionTypes["SLIDER"], 100}
}

function Derma_DrawBackgroundBlurInside( panel )
	local x, y = panel:LocalToScreen( 0, 0 )

	surface.SetMaterial( blurscreen )
	surface.SetDrawColor( 255, 255, 255, 255 )

	for i=0.33, 1, 0.33 do
			blurscreen:SetFloat( "$blur", 5 * i ) -- Increase number 5 for more blur
			blurscreen:Recompute()
			if ( render ) then render.UpdateScreenEffectTexture() end
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end

	surface.SetDrawColor( 10, 10, 10, 150 )
	surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )
end

hook.Add("ScoreboardShow", "gmstation_tab", function()
	gui.EnableScreenClicker(true)

	if(IsValid(GUIElements.tab)) then
		GUIElements.tab:Remove()
	end

	GUIElements.tab = vgui.Create("DPanel")
	GUIElements.tab:SetSize(800, 500)
	GUIElements.tab:Center()
	GUIElements.tab:SetAlpha(0)
	GUIElements.tab:AlphaTo(255, 0.125, 0)
	GUIElements.tab.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, bgColor)
	end

	GUIElements.tab.blur = vgui.Create("DPanel", GUIElements.tab)
	GUIElements.tab.blur:SetSize(GUIElements.tab:GetWide(), GUIElements.tab:GetTall())
	GUIElements.tab.blur:Center()
	GUIElements.tab.blur.Paint = function(self, w, h)
		Derma_DrawBackgroundBlurInside(self)
	end

	GUIElements.tab.header = vgui.Create("DPanel", GUIElements.tab)
	GUIElements.tab.header:Dock(TOP)
	GUIElements.tab.header:SetTall(32)
	GUIElements.tab.header.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, headerColor)
	end

	GUIElements.tabs = vgui.Create("DPanel", GUIElements.tab)
	GUIElements.tabs:Dock(FILL)
	GUIElements.tabs.Paint = function(self, w, h)
	end

	GUIElements.tab.header.title = vgui.Create("DLabel", GUIElements.tab.header)
	GUIElements.tab.header.title:SetFont("Trebuchet24Bold")
	GUIElements.tab.header.title:SetText("GMStation")
	GUIElements.tab.header.title:SetTextColor(textColor)
	GUIElements.tab.header.title:SizeToContents()
	GUIElements.tab.header.title:Dock(LEFT)
	GUIElements.tab.header.title:DockMargin(4, 0, 0, 0)

	GUIElements.tabs.players = vgui.Create("DPanelList", GUIElements.tabs)
	GUIElements.tabs.players:Dock(FILL)
	GUIElements.tabs.players:EnableVerticalScrollbar(true)
	GUIElements.tabs.players:EnableHorizontal(false)
	GUIElements.tabs.players:SetSpacing(1)
	GUIElements.tabs.players:SetVisible(true)

	for k, v in pairs(player.GetAll()) do
		local playerPanel = vgui.Create("DPanel")
		playerPanel:SetTall(64)
		playerPanel.Paint = function(self, w, h)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(playerGradient)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		playerPanel.avatar = vgui.Create("AvatarImage", playerPanel)
		playerPanel.avatar:SetPlayer(v, 64)
		playerPanel.avatar:Dock(LEFT)
		playerPanel.avatar:DockMargin(8, 8, 8, 8)
		playerPanel.avatar:SetSize(48, 48)

		playerPanel.name = vgui.Create("DLabel", playerPanel)
		playerPanel.name:SetFont("Trebuchet16")
		playerPanel.name:SetText(v:Nick())
		playerPanel.name:SetTextColor(textColor)
		playerPanel.name:Dock(TOP)
		playerPanel.name:DockMargin(0, 13, 0, 0)

		playerPanel.location = vgui.Create("DLabel", playerPanel)
		playerPanel.location:SetFont("Trebuchet16")
		playerPanel.location:SetText(v:GetNWString("zone") or "Somewhere")
		playerPanel.location:SetTextColor(textColor2)
		playerPanel.location:Dock(BOTTOM)
		playerPanel.location:DockMargin(0, 0, 0, 10)

		timer.Create("gmstation_scoreboard_" .. v:SteamID(), 0.5, 0, function()
			if(IsValid(playerPanel.location)) then
				playerPanel.location:SetText(v:GetNWString("zone") or "Somewhere")
			end
		end)

		GUIElements.tabs.players:AddItem(playerPanel)
	end

	GUIElements.tabs.settings = vgui.Create("DPanelList", GUIElements.tabs)
	GUIElements.tabs.settings:Dock(FILL)
	GUIElements.tabs.settings:EnableVerticalScrollbar(true)
	GUIElements.tabs.settings:EnableHorizontal(false)
	GUIElements.tabs.settings:SetSpacing(1)
	GUIElements.tabs.settings:SetVisible(false)

	GUIElements.tabs.settings.list = vgui.Create("DPanelList", GUIElements.tabs.settings)
	GUIElements.tabs.settings.list:Dock(FILL)
	GUIElements.tabs.settings.list:EnableVerticalScrollbar(true)
	GUIElements.tabs.settings.list:EnableHorizontal(false)
	GUIElements.tabs.settings.list:SetSpacing(1)
	GUIElements.tabs.settings.list:DockMargin(16, 16, 16, 16)

	GUIElements.tabs.settings.list.title_panel = vgui.Create("DPanel", GUIElements.tabs.settings.list)
	GUIElements.tabs.settings.list.title_panel:SetTall(64)
	GUIElements.tabs.settings.list.title_panel:Dock(TOP)
	GUIElements.tabs.settings.list.title_panel.Paint = function(self, w, h)
	end

	GUIElements.tabs.settings.list.title = vgui.Create("DLabel", GUIElements.tabs.settings.list.title_panel)
	GUIElements.tabs.settings.list.title:SetFont("Trebuchet32")
	GUIElements.tabs.settings.list.title:SetText("Settings")
	GUIElements.tabs.settings.list.title:SetTextColor(textColor)
	GUIElements.tabs.settings.list.title:SizeToContents()

	for k, v in pairs(settings) do
		local setting = vgui.Create("DPanel", GUIElements.tabs.settings.list)
		setting:Dock(TOP)
		setting.Paint = function(self, w, h)
		end

		setting.name = vgui.Create("DLabel", setting)
		setting.name:SetFont("Trebuchet16")
		setting.name:SetText(k)
		setting.name:SetTextColor(textColor)
		setting.name:Dock(LEFT)
		setting.name:SizeToContentsX()

		if v[2] == optionTypes["SLIDER"] then
			setting.slider = vgui.Create("DNumSlider", setting)
			setting.slider:SetWide(200)
			setting.slider:SetMin(0)
			setting.slider:SetMax(v[3])
			setting.slider:SetDecimals(0)
			setting.slider:SetValue(GLOBALS[v[1]] * 100 or 0 * 100)
			setting.slider:Dock(FILL)
			setting.slider:DockMargin(0, 0, 0, 0)
			setting.slider.OnValueChanged = function(self, value)
				GLOBALS[v[1]] = value / 100
				saveSettings()
			end
		elseif v[2] == optionTypes["CHECKBOX"] then
			setting.checkbox = vgui.Create("DCheckBoxLabel", setting)
			setting.checkbox:SetWide(200)
			setting.checkbox:SetText("")
			setting.checkbox:SetValue(v[1])
			setting.checkbox:Dock(RIGHT)
			setting.checkbox:DockMargin(0, 0, 0, 0)
			setting.checkbox:SetTextColor(textColor)
		end
	end


	GUIElements.tab.tabList = vgui.Create("DPanelList", GUIElements.tab)
	GUIElements.tab.tabList:Dock(LEFT)
	GUIElements.tab.tabList:SetWide(96)
	GUIElements.tab.tabList:SetSpacing(1)
	GUIElements.tab.tabList.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, rowColor2)
	end

	for k, v in pairs(tabs) do
		local button = vgui.Create("DButton")
		button:SetText(v)
		button:SetTextColor(textColor)
		button:SetFont("Trebuchet16")
		button:SetSize(GUIElements.tab.tabList:GetWide(), 32)
		button:SetX(20)
		button.Paint = function(self, w, h)
			if(self:IsHovered()) then
				draw.RoundedBox(0, 0, 0, w, h, rowColor1)
			else
				draw.RoundedBox(0, 0, 0, w, h, rowColor2)
			end
		end
		button.DoClick = function()
			for k, v in pairs(GUIElements.tabs:GetChildren()) do
				v:SetVisible(false)
			end

			GUIElements.tabs[v:lower()]:SetVisible(true)
		end

		GUIElements.tab.tabList:AddItem(button)
	end

	return false
end)

hook.Add("ScoreboardHide", "gmstation_tab", function()
	gui.EnableScreenClicker(false)

	if(IsValid(GUIElements.tab)) then
		GUIElements.tab:AlphaTo(0, 0.125, 0, function()
			GUIElements.tab:Remove()
		end)

		for k, v in pairs(player.GetAll()) do
			timer.Remove("gmstation_scoreboard_" .. v:SteamID())
		end
	end

	return false
end)