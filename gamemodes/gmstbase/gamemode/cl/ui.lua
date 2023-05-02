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

function GM:HUDDrawTargetID()
	return false
end

function GM:HUDShouldDraw(name)
	return hudExceptions[name] || false
end

local function m_AlignText(text, font, x, y, xalign, yalign)
	surface.SetFont(font)
	local textw, texth = surface.GetTextSize(text)

	if xalign == TEXT_ALIGN_CENTER then
		x = x - (textw / 2)
	elseif xalign == TEXT_ALIGN_RIGHT then
		x = x - textw
	end

	if yalign == TEXT_ALIGN_BOTTOM then
		y = y - texth
	end

	return x, y
end

function draw.LinearGradient(x, y, w, h, stops, horizontal)
	if #stops == 0 then
		return
	elseif #stops == 1 then
		surface.SetDrawColor(stops[1].color)
		surface.DrawRect(x, y, w, h)

		return
	end

	table.SortByMember(stops, "offset", true)
	render.SetMaterial(white)
	mesh.Begin(MATERIAL_QUADS, #stops - 1)

	for i = 1, #stops - 1 do
		local offset1 = math.Clamp(stops[i].offset, 0, 1)
		local offset2 = math.Clamp(stops[i + 1].offset, 0, 1)
		if offset1 == offset2 then continue end
		local deltaX1, deltaY1, deltaX2, deltaY2
		local color1 = stops[i].color
		local color2 = stops[i + 1].color
		local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
		local r2, g2, b2, a2
		local r3, g3, b3, a3 = color2.r, color2.g, color2.b, color2.a
		local r4, g4, b4, a4

		if horizontal then
			r2, g2, b2, a2 = r3, g3, b3, a3
			r4, g4, b4, a4 = r1, g1, b1, a1
			deltaX1 = offset1 * w
			deltaY1 = 0
			deltaX2 = offset2 * w
			deltaY2 = h
		else
			r2, g2, b2, a2 = r1, g1, b1, a1
			r4, g4, b4, a4 = r3, g3, b3, a3
			deltaX1 = 0
			deltaY1 = offset1 * h
			deltaX2 = w
			deltaY2 = offset2 * h
		end

		mesh.Color(r1, g1, b1, a1)
		mesh.Position(Vector(x + deltaX1, y + deltaY1))
		mesh.AdvanceVertex()
		mesh.Color(r2, g2, b2, a2)
		mesh.Position(Vector(x + deltaX2, y + deltaY1))
		mesh.AdvanceVertex()
		mesh.Color(r3, g3, b3, a3)
		mesh.Position(Vector(x + deltaX2, y + deltaY2))
		mesh.AdvanceVertex()
		mesh.Color(r4, g4, b4, a4)
		mesh.Position(Vector(x + deltaX1, y + deltaY2))
		mesh.AdvanceVertex()
	end

	mesh.End()
end

function draw.SimpleWavyText(text, font, x, y, color, xalign, yalign, style, intesity)
	local xalign = xalign || TEXT_ALIGN_LEFT
	local yalign = yalign || TEXT_ALIGN_TOP
	local texte = string.Explode("", text)
	surface.SetFont(font)
	local chars_x = 0
	local x, y = m_AlignText(text, font, x, y, xalign, yalign)

	for i = 1, #texte do
		local char = texte[i]
		local charw, charh = surface.GetTextSize(char)
		local y_pos = 1
		local mod = math.sin((RealTime() - (i * 0.1)) * (2 * intesity))

		if style == 1 then
			y_pos = y_pos - math.abs(mod)
		elseif style == 2 then
			y_pos = y_pos + math.abs(mod)
		else
			y_pos = y_pos - mod
		end

		draw.SimpleText(char, font, x + chars_x, y - (5 * y_pos), color, xalign, yalign)
		chars_x = chars_x + charw
	end
end

function draw.SimpleLinearGradient(x, y, w, h, startColor, endColor, horizontal)
	draw.LinearGradient(x, y, w, h, {
		{
			offset = 0,
			color = startColor
		},
		{
			offset = 1,
			color = endColor
		}
	}, horizontal)
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
		size = 18,
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
	ParticleEffectAttach("achieved", PATTACH_POINT_FOLLOW, who, who:LookupAttachment("none"))
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
		local reward = vgui.Create("DLabel", GUIElements.achievement)
		reward:SetPos(96, 48)
		reward:SetFont("Trebuchet16")
		reward:SetText(money .. "cc")
		reward:SizeToContents()
		reward:SetColor(Color(255, 200, 0))

		timer.Simple(5, function()
			if IsValid(GUIElements.achievement) then
				GUIElements.achievement:MoveTo(ScrW(), 32, 0.5, 0, 1.5)

				timer.Simple(0.5, function()
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
	dismiss:Dock(FILL)
	dismiss:SetText("")
	dismiss.Paint = function(self, w, h) end

	dismiss.DoClick = function()
		GUIElements.css:Remove()
	end
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
	draw.DrawText(text, "TrebuchetChat", 0, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
	draw.DrawText(stringified_globals, "TrebuchetChat", 0, height, Color(255, 255, 255), TEXT_ALIGN_LEFT)
end)
