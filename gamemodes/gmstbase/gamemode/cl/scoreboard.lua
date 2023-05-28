// GMStation - tab plugin
local bgColor = Color(25, 25, 25, 200)
local headerColor = Color(0, 120, 255, 255)
local rowColor1 = Color(0, 102, 218)
local rowColor2 = Color(0, 78, 167, 200)
local textColor = Color(255, 255, 255, 255)
local textColor2 = Color(255, 255, 255, 100)
local blurscreen = Material("pp/blurscreen")
local playerGradient = Material("gmstation/ui/gradients/hoz.png")

local optionTypes = {
	["SLIDER"] = 1,
	["CHECKBOX"] = 2,
	["BUTTON"] = 3,
}

local tabs = {"Players", "Drip", "Settings", "Awards", "Credits"}

local credits = {
	{"fgor", "Designer, Lead \"Scream at his team\" guy"},
	{"japannt", "Lead Developer"},
	{"Dark", "Mapper, Composer & SFX"},
	{}, {"Bartkk", "API Development & Contributions"},
	{"Michu", "Server hosting & Contributions"},
	{""},
	{"Special thanks to :"},
	{"PixelTail Games for the original GMTower concept."},
	{"The folks over at TCF for the GMTower revival."},
	{"Our whole community for supporting us and you for playing!"},
}

local settingOrder = {"Music Volume", "sep", "Scoreboard Waves*", "Scoreboard Blur", "Blur Strength", "sep", "Delete Account",}

local settings = {
	["sep"] = {"seperator"},
	["Music Volume"] = {"volume", optionTypes["SLIDER"], 0, 100},
	["Scoreboard Waves*"] = {"tabWaves", optionTypes["CHECKBOX"]},
	["Scoreboard Blur"] = {"tabBlur", optionTypes["CHECKBOX"]},
	["Blur Strength"] = {"blurStrength", optionTypes["SLIDER"], 1, 10},
	["Delete Account"] = {
		"deleteAccount", optionTypes["BUTTON"], "Delete Account", function()
			Derma_Query("Are you sure you want to delete your account?\nYou will lose everything!", "Delete Account", "Yes", function()
				net.Start("gmstation_deleteAccount")
				net.SendToServer()
			end, "No")
		end
	}
}

function Derma_DrawBackgroundBlurInside(panel)
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetMaterial(blurscreen)
	surface.SetDrawColor(255, 255, 255, 255)
	local blurStrength = CL_GLOBALS.blurStrength * 100

	for i = 0.33, 1, 0.33 do
		blurscreen:SetFloat("$blur", blurStrength * i)
		blurscreen:Recompute()

		if render then
			render.UpdateScreenEffectTexture()
		end

		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end

	surface.SetDrawColor(10, 10, 10, 150)
	surface.DrawRect(x * -1, y * -1, ScrW(), ScrH())
end

hook.Add("ScoreboardShow", "gmstation_tab", function()
	gui.EnableScreenClicker(true)

	if IsValid(GUIElements.tab) then
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
			for i = 0, 16 do
				local verts = {
					{
						x = 0,
						y = h
					}
				}

				for ii = 0, w / 16 do
					verts[#verts + 1] = {
						x = ii * 16,
						y = h / 2 + math.sin(CurTime() + (ii * i) / w * 60) * h / 16 + (i * (w / 32))
					}
				end

				verts[#verts + 1] = {
					x = w,
					y = h
				}

				surface.SetDrawColor(0, 78, 218, i * 50)
				draw.NoTexture()
				surface.DrawPoly(verts)
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
	GUIElements.tabs.Paint = function(self, w, h) end
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

		playerPanel.Paint = function(self, w, h)
			if v:Team() != 0 then
				surface.SetDrawColor(team.GetColor(v:Team()))
			else
				surface.SetDrawColor(rowColor1)
			end

			surface.SetMaterial(playerGradient)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		playerPanel.avatar = vgui.Create("AvatarImage", playerPanel)
		playerPanel.avatar:SetPlayer(v, 64)
		playerPanel.avatar:Dock(LEFT)
		playerPanel.avatar:DockMargin(8, 8, 8, 8)
		playerPanel.avatar:SetSize(48, 48)
		local button = vgui.Create("DButton", playerPanel.avatar)
		button:SetSize(48, 48)
		button:SetText("")
		button.Paint = function(self, w, h) end

		button.DoClick = function()
			if IsValid(v) then
				v:ShowProfile()
			end
		end

		playerPanel.name = vgui.Create("DLabel", playerPanel)
		playerPanel.name:SetFont("Trebuchet16")
		playerPanel.name:SetText(v:Nick())
		playerPanel.name:SetTextColor(textColor)
		playerPanel.name:Dock(TOP)
		playerPanel.name:DockMargin(0, 13, 0, 0)
		playerPanel.location = vgui.Create("DLabel", playerPanel)
		playerPanel.location:SetFont("Trebuchet16")
		playerPanel.location:SetText(v:GetNW2String("zone") || "Somewhere")
		playerPanel.location:SetTextColor(textColor2)
		playerPanel.location:Dock(BOTTOM)
		playerPanel.location:DockMargin(0, 0, 0, 10)

		timer.Create("gmstation_scoreboard_" .. v:SteamID(), 0.5, 0, function()
			if IsValid(playerPanel.location) then
				playerPanel.location:SetText(v:GetNW2String("zone") || "Somewhere")
			end
		end)
	end

	GUIElements.tabs.drip = vgui.Create("DPanel", GUIElements.tabs)
	GUIElements.tabs.drip:Dock(FILL)
	GUIElements.tabs.drip:SetVisible(false)
	GUIElements.tabs.drip:DockMargin(16, 16, 16, 16)

	GUIElements.tabs.drip.Paint = function(self, w, h)
		draw.SimpleText("Experimental feature!", "Trebuchet16Bold", w - 8, h - 4, textColor2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	end

	GUIElements.tabs.drip.list = vgui.Create("DScrollPanel", GUIElements.tabs.drip)
	GUIElements.tabs.drip.list:Dock(FILL)
	local items = GMSTBase_GetItems()
	local targetPreviewPos = Vector(50, 50, 50)
	local targetPreviewTarget = Vector(0, 0, 40)
	local targetPreviewFov = 40
	local hats = {}

	for k, v in pairs(items) do
		if v.type == "hat" then
			table.insert(hats, v)
		end
	end

	GUIElements.tabs.drip.list.hats = vgui.Create("DLabel", GUIElements.tabs.drip.list)
	GUIElements.tabs.drip.list.hats:SetFont("Trebuchet24Bold")
	GUIElements.tabs.drip.list.hats:SetText("Hats")
	GUIElements.tabs.drip.list.hats:SetTextColor(textColor)
	GUIElements.tabs.drip.list.hats:SizeToContents()
	GUIElements.tabs.drip.list.hats:Dock(TOP)
	GUIElements.tabs.drip.list.hatsgrid = vgui.Create("DGrid", GUIElements.tabs.drip.list)
	GUIElements.tabs.drip.list.hatsgrid:SetCols(6)
	GUIElements.tabs.drip.list.hatsgrid:SetColWide(64)
	GUIElements.tabs.drip.list.hatsgrid:SetRowHeight(64)
	GUIElements.tabs.drip.list.hatsgrid:Dock(TOP)
	GUIElements.tabs.drip.list.hatsgrid:SetContentAlignment(5)
	GUIElements.tabs.drip.list.pmtitle = vgui.Create("DLabel", GUIElements.tabs.drip.list)
	GUIElements.tabs.drip.list.pmtitle:SetFont("Trebuchet24Bold")
	GUIElements.tabs.drip.list.pmtitle:SetText("Playermodels")
	GUIElements.tabs.drip.list.pmtitle:SetTextColor(textColor)
	GUIElements.tabs.drip.list.pmtitle:SizeToContents()
	GUIElements.tabs.drip.list.pmtitle:Dock(TOP)
	GUIElements.tabs.drip.list.pmgrid = vgui.Create("DGrid", GUIElements.tabs.drip.list)
	GUIElements.tabs.drip.list.pmgrid:SetCols(6)
	GUIElements.tabs.drip.list.pmgrid:SetColWide(64)
	GUIElements.tabs.drip.list.pmgrid:SetRowHeight(64)
	GUIElements.tabs.drip.list.pmgrid:Dock(TOP)
	local model = GMSTBase_GetItemInfo(LocalPlayer():GetNW2String("hat", "none")).model
	local hat = ClientsideModel(model, RENDERGROUP_OPAQUE)
	hat:SetNoDraw(true)
	local nohat = vgui.Create("SpawnIcon", GUIElements.tabs.drip.list.hatsgrid)
	nohat:SetModel("models/props_c17/streetsign004e.mdl")
	nohat:SetTall(64)
	nohat:SetTooltip(false)
	GUIElements.tabs.drip.list.hatsgrid:AddItem(nohat)

	nohat.DoClick = function()
		net.Start("gmstation_hatchange")
		net.WriteString("")
		net.SendToServer()
		hat:SetModel("")
		targetPreviewPos = Vector(50, 50, 50)
		targetPreviewTarget = Vector(0, 0, 40)
		targetPreviewFov = 40
	end

	GMSTBase_SimpleHover(nohat, "Take off hat")

	for i = 1, #items do
		local itemPanel = vgui.Create("SpawnIcon", GUIElements.tabs.drip.list.hatsgrid)
		local item = GMSTBase_GetItemInfo(items[i])
		itemPanel:SetModel(item.model)
		itemPanel:SetTall(64)
		itemPanel:SetTooltip(false)

		itemPanel.DoClick = function()
			net.Start("gmstation_hatchange")
			net.WriteString(items[i])
			net.SendToServer()
			hat:SetModel(item.model)
			targetPreviewPos = Vector(50, 50, 70)
			targetPreviewTarget = Vector(0, 0, 70)
			targetPreviewFov = 20
		end

		GUIElements.tabs.drip.list.hatsgrid:AddItem(itemPanel)
		local fancyhover = vgui.Create("DPanel")
		fancyhover:SetSize(256, 112)
		local fancyhoverlabel = vgui.Create("DLabel", fancyhover)
		fancyhoverlabel:SetFont("Trebuchet24Bold")
		fancyhoverlabel:SetText(item.name)
		fancyhoverlabel:SetTextColor(textColor)
		fancyhoverlabel:SizeToContents()
		fancyhoverlabel:Dock(TOP)
		fancyhoverlabel:DockMargin(16, 8, 8, 0)
		local fancyhoverdesc = vgui.Create("DLabel", fancyhover)
		fancyhoverdesc:SetFont("Trebuchet8")
		fancyhoverdesc:SetText(item.description)
		fancyhoverdesc:SizeToContents()
		fancyhoverdesc:Dock(TOP)
		fancyhoverdesc:DockMargin(16, 0, 8, 4)
		local fancyhoverprice = vgui.Create("DLabel", fancyhover)
		fancyhoverprice:SetFont("Trebuchet8")
		fancyhoverprice:SetText("Price: " .. item.price .. "cc")
		fancyhoverprice:SizeToContents()
		fancyhoverprice:Dock(BOTTOM)
		fancyhoverprice:DockMargin(8, 8, 8, 8)
		fancyhoverprice:SetContentAlignment(6)

		if item.unobtainable then
			local fancyhoverunobtainable = GMSTBase_tag(fancyhover, Color(255, 50, 0), "Unobtainable")
			fancyhoverunobtainable:Dock(TOP)
			fancyhoverunobtainable:DockMargin(8, 0, 8, 0)
		end

		GMSTBase_HoverPanel(itemPanel, fancyhover)
	end

	GUIElements.tabs.drip.preview = vgui.Create("DModelPanel", GUIElements.tabs.drip)
	GUIElements.tabs.drip.preview:Dock(RIGHT)
	GUIElements.tabs.drip.preview:SetWide(256)
	GUIElements.tabs.drip.preview:SetModel(LocalPlayer():GetModel())

	GUIElements.tabs.drip.preview.LayoutEntity = function(self, ent)
		GUIElements.tabs.drip.preview:SetCamPos(LerpVector(FrameTime() * 10, GUIElements.tabs.drip.preview:GetCamPos(), targetPreviewPos))
		GUIElements.tabs.drip.preview:SetFOV(Lerp(FrameTime() * 10, GUIElements.tabs.drip.preview:GetFOV(), targetPreviewFov))
		GUIElements.tabs.drip.preview:SetLookAt(LerpVector(FrameTime() * 10, GUIElements.tabs.drip.preview:GetLookAt(), targetPreviewTarget))
		ent:SetAngles(Angle(0, ent:GetAngles().y + FrameTime() * 50, 0))
	end

	GUIElements.tabs.drip.preview.PostDrawModel = function(self, ent)
		hat:SetModel(LocalPlayer():GetNW2String("hat", ""))
		local bone = ent:LookupBone("ValveBiped.Bip01_Head1")
		if !bone then return end
		local pos, ang = ent:GetBonePosition(bone)
		if !pos then return end
		hat:SetPos(pos + ang:Forward() * 2)
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)
		hat:SetAngles(ang)
		hat:SetModelScale(1.2, 0)
		hat:SetupBones()

		if LocalPlayer():GetNW2String("hat", "") != "" then
			hat:DrawModel()
		end
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
	GUIElements.tabs.settings.list.Paint = function(self, w, h) end
	GUIElements.tabs.settings.list.title = vgui.Create("DLabel", GUIElements.tabs.settings.list)
	GUIElements.tabs.settings.list.title:SetFont("Trebuchet32")
	GUIElements.tabs.settings.list.title:SetText("Settings")
	GUIElements.tabs.settings.list.title:SetTextColor(textColor)
	GUIElements.tabs.settings.list.title:SizeToContents()
	GUIElements.tabs.settings.list.title:Dock(TOP)

	for i = 1, #settingOrder do
		local k = settingOrder[i]
		local v = settings[settingOrder[i]]
		// Lua, why lua WHYYYYYYYYYYYYY
		local setting = vgui.Create("DPanel", GUIElements.tabs.settings.list)
		setting:Dock(TOP)
		setting.Paint = function(self, w, h) end

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
			setting.slider:SetValue(CL_GLOBALS[v[1]] * 100 || 0)
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
		elseif v[2] == optionTypes["BUTTON"] then
			setting.button = vgui.Create("DButton", setting)
			setting.button:SetWide(200)
			setting.button:SetText(v[3])
			setting.button:Dock(RIGHT)
			setting.button:DockMargin(0, 0, 0, 0)
			setting.button:SetTextColor(textColor)

			setting.button.DoClick = function(self)
				v[4]()
			end
		end
	end

	GUIElements.tabs.awards = vgui.Create("DPanel", GUIElements.tabs)
	GUIElements.tabs.awards:Dock(FILL)
	GUIElements.tabs.awards:SetVisible(false)
	GUIElements.tabs.awards:DockMargin(16, 16, 16, 16)

	GUIElements.tabs.awards.Paint = function(self, w, h)
		draw.DrawText("Work in progress...\nDon't worry your already collected achievements are safe!", "Trebuchet16Bold", w / 2, h / 2 - 32, textColor2, TEXT_ALIGN_CENTER)
	end

	GUIElements.tabs.credits = vgui.Create("DPanel", GUIElements.tabs)
	GUIElements.tabs.credits:Dock(FILL)
	GUIElements.tabs.credits:SetVisible(false)
	GUIElements.tabs.credits:DockMargin(16, 16, 16, 16)
	GUIElements.tabs.credits.Paint = function(self, w, h) end
	GUIElements.tabs.credits.scroll = vgui.Create("DScrollPanel", GUIElements.tabs.credits)
	GUIElements.tabs.credits.scroll:Dock(FILL)
	GUIElements.tabs.credits.scroll.Paint = function(self, w, h) end
	local title = vgui.Create("DLabel", GUIElements.tabs.credits.scroll)
	title:SetFont("Trebuchet48")
	title:SetText("GMStation")
	title:SizeToContents()
	title:Dock(TOP)
	local subtitle = vgui.Create("DLabel", GUIElements.tabs.credits.scroll)
	subtitle:SetFont("Trebuchet16")
	subtitle:SetText("A Garry's Mod experience by superposed")
	subtitle:SizeToContents()
	subtitle:Dock(TOP)
	local spacer = vgui.Create("DPanel", GUIElements.tabs.credits.scroll)
	spacer:SetTall(8)
	spacer:Dock(TOP)
	spacer.Paint = function(self, w, h) end
	local title2 = vgui.Create("DLabel", GUIElements.tabs.credits.scroll)
	title2:SetFont("Trebuchet32")
	title2:SetText("Credits")
	title2:SizeToContents()
	title2:Dock(TOP)

	for _, v in pairs(credits) do
		local panel = vgui.Create("DPanel", GUIElements.tabs.credits.scroll)
		panel.Paint = function(self, w, h) end
		panel:Dock(TOP)

		if v[1] != nil then
			local name = vgui.Create("DLabel", panel)
			name:SetFont("Trebuchet16")
			name:SetText(v[1])
			name:SizeToContents()
			name:Dock(LEFT)

			if v[2] != nil then
				local position = vgui.Create("DLabel", panel)
				position:SetFont("Trebuchet16")
				position:SetColor(textColor2)
				position:SetText(v[2])
				position:SizeToContents()
				position:SetContentAlignment(6)
				position:Dock(RIGHT)
			else
				name:Dock(FILL)
				name:SetContentAlignment(5)
			end
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
			if self:IsHovered() then
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

	if IsValid(GUIElements.tab) then
		GUIElements.tab:AlphaTo(0, 0.125, 0, function()
			GUIElements.tab:Remove()
		end)

		for k, v in pairs(player.GetAll()) do
			timer.Remove("gmstation_scoreboard_" .. v:SteamID())
		end
	end

	return false
end)
