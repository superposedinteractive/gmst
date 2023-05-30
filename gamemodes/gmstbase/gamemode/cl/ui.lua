local hoz = Material("gmstation/ui/gradients/hoz.png", "noclamp smooth")

local hudExceptions = {
	["CHudCloseCaption"] = true,
	["CHudDamageIndicator"] = true,
	["CHudMessage"] = true,
	["CHudHintDisplay"] = true,
	["CHudWeapon"] = true,
	["CHudGMod"] = true,
	["CHudCrosshair"] = true,
	["NetGraph"] = true
}

GUIElements.notifications = vgui.Create("DPanel")
GUIElements.notifications:SetSize(ScrW(), ScrH())
GUIElements.notifications.Paint = function() end
GUIElements.notifications.list = {}

function GM:HUDDrawTargetID()
	return false
end

function GM:HUDShouldDraw(name)
	return hudExceptions[name] || false
end

local function image_load(dimage, path)
	if file.Exists(path, "THIRDPARTY") then
		dimage:SetImage(path)
	else
		path = "materials/gmstation/ui/unknown.png"
	end

	dimage:SetImage(path)
end

local function createFonts()
	surface.CreateFont("Trebuchet48Bold", {
		font = "Trebuchet MS",
		size = 72,
		weight = 1000,
		antialias = true,
		shadow = false
	})

	surface.CreateFont("Trebuchet48", {
		font = "Trebuchet MS",
		size = 72,
		weight = 500,
		antialias = true,
		shadow = false
	})

	surface.CreateFont("Trebuchet32Bold", {
		font = "Trebuchet MS",
		size = 48,
		weight = 1000,
		antialias = true,
		shadow = false
	})

	surface.CreateFont("Trebuchet32", {
		font = "Trebuchet MS",
		size = 48,
		weight = 500,
		antialias = true,
		shadow = false
	})

	surface.CreateFont("Trebuchet24Bold", {
		font = "Trebuchet MS",
		size = 36,
		weight = 1000,
		antialias = true,
		shadow = false
	})

	surface.CreateFont("Trebuchet16", {
		font = "Trebuchet MS",
		size = 24,
		weight = 500,
		antialias = true,
		shadow = false
	})

	surface.CreateFont("TrebuchetChat", {
		font = "Trebuchet MS",
		size = 20,
		weight = 1000,
		antialias = false,
		shadow = true
	})

	surface.CreateFont("Trebuchet16Add", {
		font = "Trebuchet MS",
		size = 24,
		weight = 500,
		antialias = true,
		additive = true,
	})

	surface.CreateFont("Trebuchet16Bold", {
		font = "Trebuchet MS",
		size = 24,
		weight = 1000,
		antialias = true,
		shadow = false
	})

	surface.CreateFont("Trebuchet8", {
		font = "Trebuchet MS",
		size = 18,
		weight = 10000,
		antialias = true,
		shadow = false
	})
end

createFonts()

net.Receive("gmstation_achievement", function()
	local name = net.ReadString()
	local desc = net.ReadString()
	local image = net.ReadString()
	local money = net.ReadInt(21)
	local who = net.ReadEntity()
	chat.AddText(who, Color(255, 255, 255), " has earned ", Color(255, 200, 0), name, Color(255, 255, 255), "!")

	who:CreateParticleEffect("achieved", 0, {
		["entity"] = who,
		["attachtype"] = PATTACH_ABSORIGIN_FOLLOW
	})

	who:EmitSound("misc/achievement_earned.wav")

	if IsValid(who) && who == LocalPlayer() then
		if IsValid(GUIElements.achievement) then
			GUIElements.achievement:Remove()
		end

		GUIElements.achievement = vgui.Create("DPanel")
		GUIElements.achievement:SetSize(300, 100)
		GUIElements.achievement:SetX(ScrW())
		GUIElements.achievement:SetY(32)
		GUIElements.achievement:MoveTo(ScrW() - GUIElements.achievement:GetWide() - 32, 32, 0.5, 0, 0.5)
		local bg = vgui.Create("DPanel", GUIElements.achievement)
		bg:SetSize(GUIElements.achievement:GetWide(), GUIElements.achievement:GetTall())

		bg.Paint = function(self, w, h)
			draw.SimpleText(money .. "cc", "Trebuchet48Bold", w - 32, h / 2, Color(255, 200, 0, 100), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local icon = vgui.Create("DImage", GUIElements.achievement)
		icon:SetSize(64, 64)
		icon:SetPos(16, 16)
		image_load(icon, image)
		local title = vgui.Create("DLabel", GUIElements.achievement)
		title:SetPos(96, 16)
		title:SetFont("Trebuchet16Bold")
		title:SetText(name)
		title:SizeToContents()
		local description = vgui.Create("DLabel", GUIElements.achievement)
		description:SetPos(96, 32)
		description:SetFont("Trebuchet16")
		description:SetText(desc)
		description:SizeToContents()

		timer.Simple(5, function()
			if IsValid(GUIElements.achievement) then
				GUIElements.achievement:MoveTo(ScrW(), 32, 0.5, 0, 1.5, function()
					if IsValid(GUIElements.achievement) then
						GUIElements.achievement:Remove()
					end
				end)
			end
		end)
	end
end)

local css = Material("de_nuke/radwarning")
local tf2 = Material("vgui/marked_for_death")

if css:IsError() || tf2:IsError() then
	local games = ""

	if css:IsError() then
		games = " Counter-Strike: Source"
	end

	if tf2:IsError() then
		games = games .. " and Team Fortress 2"
	end

	if !css:IsError() then
		games = string.sub(games, 5, -1)
	end

	GUIElements.css = vgui.Create("DPanel")
	GUIElements.css:SetSize(math.min(ScrW() - 64, 750), 116)
	GUIElements.css:CenterHorizontal()
	GUIElements.css:SetY(ScrH() - 116 - 32)

	GUIElements.css.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
		draw.SimpleText("Content Warning", "Trebuchet32Bold", w / 2, 32, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.DrawText("You appear to be missing" .. games .. ".\nExpect Missing textures, sounds and models!", "Trebuchet16", w / 2, 55, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Click to dismiss", "Trebuchet8", w - 8, h - 4, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	end

	local dismiss = vgui.Create("DButton", GUIElements.css)
	dismiss:SetText("")
	dismiss:SetSize(GUIElements.css:GetWide(), GUIElements.css:GetTall())
	dismiss:SetPos(0, 0)
	dismiss:SetZPos(100)
	dismiss.Paint = function(self, w, h) end

	dismiss.DoClick = function()
		GUIElements.css:Remove()
	end
end

function GMSTBase_Notification(title_text, text_text, icon_uri)
	local notif = vgui.Create("DPanel", GUIElements.notifications)
	local y = 0

	for i = 1, #GUIElements.notifications.list do
		y = y + GUIElements.notifications.list[i]:GetTall() + 8
	end

	table.insert(GUIElements.notifications.list, notif)
	local rawtext = ""

	for i = 1, #text_text do
		if type(text_text[i]) == "string" then
			rawtext = rawtext .. text_text[i]
		end
	end

	surface.SetFont("Trebuchet8")
	local w, h = surface.GetTextSize(rawtext)
	local icon = vgui.Create("DImage", notif)

	if icon_uri then
		icon:Dock(LEFT)
		local pad = notif:GetTall() * 1.3341
		icon:DockMargin(8, padd, 8, pad)
		icon:SetWide(32)
		icon:SetImage(icon_uri)
	end

	local title = vgui.Create("DLabel", notif)
	title:SetFont("Trebuchet16Bold")
	title:SetText(title_text)
	title:SizeToContents()
	title:Dock(TOP)
	title:DockMargin(8, 8, 0, 0)

	if !icon then
		title:DockMargin(8, 8, 8, 0)
	end

	local text = vgui.Create("RichText", notif)
	text:Dock(FILL)
	text:DockMargin(8, 8, 8, 8)
	text:SetVerticalScrollbarEnabled(false)

	text.PerformLayout = function(self)
		self:SetFontInternal("Trebuchet8")
	end

	for i = 1, #text_text do
		if type(text_text[i]) == "string" then
			text:AppendText(text_text[i])
		elseif type(text_text[i]) == "table" then
			text:InsertColorChange(text_text[i].r, text_text[i].g, text_text[i].b, text_text[i].a)
		end
	end

	surface.PlaySound("buttons/lightswitch2.wav")
	notif:SetSize(math.min(w + 128, ScrW()), h + 64)
	notif:SetPos(ScrW(), ScrH() - 32 - notif:GetTall() - y - 32)

	notif:MoveTo(ScrW() - notif:GetWide(), notif:GetY(), 0.5, 0, 0.5, function()
		notif:MoveTo(ScrW(), notif:GetY(), 0.5, 5, 1.5, function()
			table.RemoveByValue(GUIElements.notifications.list, notif)
			notif:Remove()
		end)
	end)
end

function GMSTBase_tag(parent, color, text)
	local tag = vgui.Create("DPanel", parent)
	tag:SetSize(96, 16)

	tag.Paint = function(self, w, h)
		surface.SetDrawColor(color)
		surface.SetMaterial(hoz)
		surface.DrawTexturedRect(0, 0, w, h)
		draw.SimpleText(text, "Trebuchet8", 8, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	return tag
end

function GMSTBase_HoverPanel(panel, hover_panel)
	hover_panel:SetVisible(false)

	panel.OnCursorEntered = function(self)
		hover_panel:SetVisible(true)
		hover_panel:MoveToFront()
		hover_panel:SetAlpha(0)
		hover_panel:AlphaTo(255, 0.1)

		hover_panel.Think = function(self)
			local x, y = gui.MousePos()
			self:SetPos(x + 16, y + 16)
		end
	end

	panel.OnCursorExited = function(self)
		hover_panel:AlphaTo(0, 0.1, 0, function()
			hover_panel:SetVisible(false)
		end)

		hover_panel.Think = function() end
	end

	panel.OnRemove = function(self)
		hover_panel:Remove()
	end
end

function GMSTBase_SimpleHover(panel, text)
	local hover = vgui.Create("DPanel")
	surface.SetFont("Trebuchet8")
	local w, h = surface.GetTextSize(text)
	hover:SetSize(w + 16, h + 16)
	local label = vgui.Create("DLabel", hover)
	label:SetFont("Trebuchet8")
	label:SetText(text)
	label:Dock(FILL)
	label:SetContentAlignment(5)
	GMSTBase_HoverPanel(panel, hover)
end

net.Receive("gmstation_reward", function()
	timer.Stop("gmstation_payout_timer")
	local rewards = net.ReadTable()
	local sum = 0
	local i = 1

	for k, v in pairs(rewards) do
		sum = sum + v[2]
	end

	for i = 1, #rewards do
		MsgN("⎸ " .. i .. " " .. rewards[i][1] .. " | " .. rewards[i][2])
	end

	MsgN("⎸")
	MsgN("⎸ Total: " .. sum)
	MsgN("\\__________________________")

	if IsValid(GUIElements.reward) then
		GUIElements.reward:Remove()
	end

	GUIElements.reward = vgui.Create("DPanel")
	GUIElements.reward:SetSize(300, ScrH())
	GUIElements.reward:SetX(ScrW() - GUIElements.reward:GetWide())
	GUIElements.reward.Paint = function(self, w, h) end

	// timer.Create("gmstation_payout_timer", 0, #rewards + 1, function()
	timer.Create("gmstation_payout_timer", 0.56, #rewards + 1, function()
		local reward = vgui.Create("DPanel", GUIElements.reward)
		reward:SetWide(GUIElements.reward:GetWide())
		reward:SetTall(32)
		reward:SetPos(reward:GetWide() + 1, ScrH() - reward:GetTall() - (i - 1) * 32)
		surface.PlaySound("gmstation/sfx/payout/roll.mp3")

		if i != #rewards + 1 then
			local text = vgui.Create("DLabel", reward)
			text:Dock(FILL)
			text:DockMargin(8, 0, 8, 0)
			text:SetContentAlignment(4)
			text:SetFont("Trebuchet8")
			text:SetText(rewards[i][1])
			text:SizeToContents()
			local moneytext = vgui.Create("DLabel", reward)
			moneytext:Dock(RIGHT)
			moneytext:DockMargin(8, 0, 8, 0)
			moneytext:SetContentAlignment(4)
			moneytext:SetFont("Trebuchet24Bold")
			moneytext:SetText(rewards[i][2] .. "cc")
			moneytext:SizeToContents()
			local ii = i

			reward:MoveTo(0, reward:GetY(), 0.56, 0, 16, function()
				surface.PlaySound("gmstation/sfx/payout/goal" .. math.min(ii, 5) .. ".wav")
			end)
		else
			reward:SetTall(64)
			reward:SetY(ScrH() - reward:GetTall() - (i - 1) * 32)
			local totaltext = vgui.Create("DLabel", reward)
			totaltext:Dock(FILL)
			totaltext:DockMargin(8, 0, 8, 0)
			totaltext:SetContentAlignment(4)
			totaltext:SetFont("Trebuchet16")
			totaltext:SetText("Total")
			totaltext:SizeToContents()
			local moneytext = vgui.Create("DLabel", reward)
			moneytext:Dock(RIGHT)
			moneytext:DockMargin(8, 0, 8, 0)
			moneytext:SetContentAlignment(6)
			moneytext:SetFont("Trebuchet32Bold")
			moneytext:SetText(sum .. "cc")
			moneytext:SizeToContents()

			reward:MoveTo(0, reward:GetY(), 0.56, 0, 16, function()
				surface.PlaySound("gmstation/sfx/payout/payout_end.mp3")

				GUIElements.reward:MoveTo(GUIElements.reward:GetX(), GUIElements.reward:GetY() - 64, 4, 0, 1, function()
					GUIElements.reward:Remove()
				end)

				GUIElements.reward:AlphaTo(0, 4, 0)
			end)
		end

		i = i + 1
	end)
end)

net.Receive("gmstation_map_restart", function()
	surface.PlaySound("ui/hitsound_beepo.wav")
	local time = net.ReadFloat()

	if IsValid(GUIElements.restarting) then
		GUIElements.restarting:Remove()
	end

	timer.Create("gmstation_map_restart", time, 1, function()
		surface.PlaySound("ui/hitsound.wav")
	end)

	GUIElements.restarting = vgui.Create("DPanel")
	GUIElements.restarting:SetSize(300, 100)
	GUIElements.restarting:SetPos(ScrW() / 2 - GUIElements.restarting:GetWide() / 2, ScrH() / 2 - GUIElements.restarting:GetTall() / 2 + 32)

	GUIElements.restarting.Paint = function(self, w, h)
		local time = string.ToMinutesSeconds(timer.TimeLeft("gmstation_map_restart") || 0)
		draw.SimpleText("MAP RESTART", "Trebuchet16Bold", w / 2 + 1, h / 2 + 1, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("MAP RESTART", "Trebuchet16Bold", w / 2, h / 2, Color(math.sin(CurTime() * 8) * 64 + 192, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(time, "Trebuchet8", w / 2 + 1, h / 2 + 20 + 1, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(time, "Trebuchet8", w / 2, h / 2 + 20, Color(math.sin(CurTime() * 8) * 64 + 192, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

local last_timeout_think = 0
local last_bad_timeout = 0

hook.Add("Think", "gmstation_timeout_think", function()
	if SysTime() - (last_timeout_think || 0) > 1 then
		local timing = GetTimeoutInfo()

		if timing then
			if !IsValid(GUIElements.timeout) then
				last_bad_timeout = SysTime()
				timeout_music = CreateSound(LocalPlayer(), "gmstation/music/timing.mp3")
				GUIElements.timeout = vgui.Create("DPanel")
				GUIElements.timeout:SetSize(ScrW(), ScrH())

				GUIElements.timeout.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 220))
					draw.SimpleText("Aw shucks!", "Trebuchet32Bold", w / 2, h / 2 - 24, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.DrawText("The server is currently experiencing some technical difficulties,\nor you're just having a bad connection...\n\nPlease wait while we try to plug you back in.\nYou've been timing out for " .. math.Round(SysTime() - last_bad_timeout) .. " seconds.", "Trebuchet16", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				end

				if CL_GLOBALS.currentSound then
					CL_GLOBALS.currentSound:ChangeVolume(0.01, 0)
				end

				timeout_music:PlayEx(CL_GLOBALS.volume * 100, 100)
				gui.EnableScreenClicker(true)
			end

			if SysTime() - last_bad_timeout > 30 then
				if IsValid(GUIElements.timeout.label) then return end
				GUIElements.timeout.label = vgui.Create("DLabel", GUIElements.timeout)
				GUIElements.timeout.label:SetY(ScrH() / 1.55)
				GUIElements.timeout.label:SetSize(ScrW(), 64)
				GUIElements.timeout.label:CenterHorizontal()
				GUIElements.timeout.label:SetFont("Trebuchet16")
				GUIElements.timeout.label:SetText("You've been timing out for quite a while now.\nYou can try to reconnect and see if you will be able to play again.")
				GUIElements.timeout.label:SetContentAlignment(5)
				local reconnect = vgui.Create("DButton", GUIElements.timeout)
				reconnect:SetSize(ScrW() / 1.5, 64)
				reconnect:SetPos(ScrW() / 2 - reconnect:GetWide() / 2, ScrH() / 1.5 + 64)
				reconnect:SetText("Reconnect")
				reconnect:SetFont("Trebuchet16Bold")

				reconnect.DoClick = function()
					RunConsoleCommand("retry")
				end
			end
		else
			if IsValid(GUIElements.timeout) then
				GMSTBase_Notification("Welcome back!", {"You've been reconnected to the server."})

				GUIElements.timeout:Remove()
				timeout_music:Stop()
				timeout_music = nil

				if CL_GLOBALS.currentSound then
					CL_GLOBALS.currentSound:ChangeVolume(CL_GLOBALS.volume * CL_GLOBALS.ogVolume, 0)
				end

				gui.EnableScreenClicker(false)
				GMSTBase_RequestNetVars()
			end
		end

		last_timeout_think = SysTime()
	end
end)

local last_commit_hash = file.Read("addons/gmstation/.git/refs/heads/master", "GAME") || "failed to read .git repo"
local sfile = file.Read("addons/gmstation/.superposed", "GAME") || "failed to read .superposed file"
local stringified_globals = ""
surface.SetFont("TrebuchetChat")
local text = "superposed dev\nhash: " .. last_commit_hash .. sfile .. "\nCL_GLOBALS dump:"
local _, height = surface.GetTextSize(text)

hook.Add("HUDPaint", "gmstation_draw_info", function()
	stringified_globals = ""

	for k, v in pairs(CL_GLOBALS) do
		stringified_globals = stringified_globals .. k .. " = " .. tostring(v) .. "\n"
	end

	draw.SimpleText("cataclysm alpha testing", "Trebuchet48Bold", ScrW() * 0.9, ScrH() * 0.9, Color(255, 255, 255, 100), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	draw.DrawText(text, "TrebuchetChat", ScrW(), 0, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
	draw.DrawText(stringified_globals, "TrebuchetChat", ScrW(), height, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
end)

hook.Remove("HUDPaint", "gmstation_draw_info")
timer.Stop("gmstation_payout_timer")
