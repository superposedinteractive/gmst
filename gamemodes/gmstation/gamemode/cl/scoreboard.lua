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

local settingOrder = {
	"Music Volume",
	"sep",
	"Scoreboard Waves*",
	"Scoreboard Blur",
	"Blur Strength",
}

local settings = {
	["sep"] = {"seperator"},
	["Music Volume"] = {"volume", optionTypes["SLIDER"], 0, 100},
	["Scoreboard Waves*"] = {"tabWaves", optionTypes["CHECKBOX"]},
	["Scoreboard Blur"] = {"tabBlur", optionTypes["CHECKBOX"]},
	["Blur Strength"] = {"blurStrength", optionTypes["SLIDER"], 1, 10}
}

function Derma_DrawBackgroundBlurInside(panel)
	local x, y = panel:LocalToScreen( 0, 0 )

	surface.SetMaterial( blurscreen )
	surface.SetDrawColor( 255, 255, 255, 255 )

	local blurStrength = (CL_GLOBALS.blurStrength * 100)

	for i=0.33, 1, 0.33 do
			blurscreen:SetFloat( "$blur", blurStrength * i )
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
	GUIElements.tab:SetSize(math.min(ScrW() - 100, 800), math.min(ScrH() - 100, 500))
	GUIElements.tab:Center()
	GUIElements.tab:SetAlpha(0)
	GUIElements.tab:AlphaTo(255, 0.125, 0)
	GUIElements.tab.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, bgColor)

		if CL_GLOBALS.tabWaves then
			for i = 0, 16, 1 do
				for ii = 0, w / 16, 1 do
					draw.RoundedBox(0, ii * 16, h/2 + math.sin(CurTime() + (ii * i) / w * 60) * h / 16 + (i * (w / 32)), 16, h, Color(0, 78, 218, i * 50))
				end
			end
		end
	end

	GUIElements.tab.blur = vgui.Create("DPanel", GUIElements.tab)
	GUIElements.tab.blur:SetSize(GUIElements.tab:GetWide(), GUIElements.tab:GetTall())
	GUIElements.tab.blur:Center()
	GUIElements.tab.blur:SetSize(GUIElements.tab:GetWide(), GUIElements.tab:GetTall())
	GUIElements.tab.blur.Paint = function(self, w, h)
		if CL_GLOBALS.tabBlur then
			Derma_DrawBackgroundBlurInside(self)
		end
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

	GUIElements.tabs.players = vgui.Create("DScrollPanel", GUIElements.tabs)
	GUIElements.tabs.players:Dock(FILL)
	GUIElements.tabs.players:SetVisible(true)

	GUIElements.tabs.players.panel = vgui.Create("DListLayout", GUIElements.tabs.players)
	GUIElements.tabs.players.panel:Dock(FILL)

	for k, v in pairs(player.GetAll()) do
		local playerPanel = vgui.Create("DPanel", GUIElements.tabs.players.panel)
		playerPanel:SetTall(64)
		playerPanel:DockMargin(0, 1, 0, 0)
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
	end

	GUIElements.tabs.settings = vgui.Create("DPanel", GUIElements.tabs)
	GUIElements.tabs.settings:Dock(FILL)
	GUIElements.tabs.settings:SetVisible(false)
	GUIElements.tabs.settings:DockMargin(16, 16, 16, 16)
	GUIElements.tabs.settings.Paint = function(self, w, h)
		draw.SimpleText("Settings are saved automatically.", "Trebuchet16Bold", w - 8, h - 4, textColor2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		draw.SimpleText("* - Possibly expensive to run.", "Trebuchet8", w - 8, h - 24, textColor2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	end

	GUIElements.tabs.settings.list = vgui.Create("DScrollPanel", GUIElements.tabs.settings)
	GUIElements.tabs.settings.list:Dock(FILL)
	GUIElements.tabs.settings.list.Paint = function(self, w, h)
	end

	GUIElements.tabs.settings.list.title = vgui.Create("DLabel", GUIElements.tabs.settings.list)
	GUIElements.tabs.settings.list.title:SetFont("Trebuchet32")
	GUIElements.tabs.settings.list.title:SetText("Settings")
	GUIElements.tabs.settings.list.title:SetTextColor(textColor)
	GUIElements.tabs.settings.list.title:SizeToContents()
	GUIElements.tabs.settings.list.title:Dock(TOP)

	for i = 1, #settingOrder, 1 do
		local k = settingOrder[i]
		local v = settings[settingOrder[i]]

		-- Lua, why lua WHYYYYYYYYYYYYY

		local setting = vgui.Create("DPanel", GUIElements.tabs.settings.list)
		setting:Dock(TOP)
		setting.Paint = function(self, w, h)
		end

		if string.StartWith(k, "sep") then
			setting:SetTall(1)
			setting:DockMargin(0, 8, 0, 8)
			setting.Paint = function(self, w, h)
				draw.NoTexture()
				surface.SetDrawColor(textColor2)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			
			continue
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
			setting.slider:SetMin(v[3])
			setting.slider:SetMax(v[4])
			setting.slider:SetDecimals(0)
			setting.slider:SetValue(CL_GLOBALS[v[1]] * 100 or 0)
			setting.slider:Dock(FILL)
			setting.slider:DockMargin(0, 0, 0, 0)
			setting.slider.OnValueChanged = function(self, value)
				CL_GLOBALS[v[1]] = value / 100
				saveSettings()
			end
			continue
		elseif v[2] == optionTypes["CHECKBOX"] then
			setting.checkbox = vgui.Create("DCheckBoxLabel", setting)
			setting.checkbox:SetWide(200)
			setting.checkbox:SetText("")
			setting.checkbox:SetValue(CL_GLOBALS[v[1]])
			setting.checkbox:Dock(RIGHT)
			setting.checkbox:DockMargin(0, 0, 0, 0)
			setting.checkbox:SetTextColor(textColor)
			setting.checkbox.OnChange = function(self, value)
				CL_GLOBALS[v[1]] = value
				saveSettings()
			end
			continue
		end
	end

	GUIElements.tab.tabList = vgui.Create("DScrollPanel", GUIElements.tab)
	GUIElements.tab.tabList:Dock(LEFT)
	GUIElements.tab.tabList:SetWide(96)
	GUIElements.tab.tabList.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, rowColor2)
	end

	for k, v in pairs(tabs) do
		local button = vgui.Create("DButton", GUIElements.tab.tabList)
		button:SetText(v)
		button:SetTextColor(textColor)
		button:SetFont("Trebuchet16")
		button:SetSize(GUIElements.tab.tabList:GetWide(), 32)
		button:Dock(TOP)
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
	end

	return false
end)

hook.Add("ScoreboardHide", "gmstation_tab", function()
	gui.EnableScreenClicker(false)

	saveSettings(true)

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