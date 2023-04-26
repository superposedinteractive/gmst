// GMStation - General UI
local white = Material("vgui/white")
local hover_popup = Material("gmstation/ui/hover_popup.png")

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

local function m_AlignText( text, font, x, y, xalign, yalign )
	surface.SetFont( font )
	local textw, texth = surface.GetTextSize( text )

	if ( xalign == TEXT_ALIGN_CENTER ) then
		x = x - ( textw / 2 )
	elseif ( xalign == TEXT_ALIGN_RIGHT ) then
		x = x - textw
	end

	if ( yalign == TEXT_ALIGN_BOTTOM ) then
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
	local xalign = xalign or TEXT_ALIGN_LEFT
	local yalign = yalign or TEXT_ALIGN_TOP
	local texte = string.Explode( "", text )

	surface.SetFont( font )

	local chars_x = 0
	local x, y = m_AlignText( text, font, x, y, xalign, yalign )

	for i = 1, #texte do
		local char = texte[i]
		local charw, charh = surface.GetTextSize( char )
		local y_pos = 1
		local mod = math.sin( ( RealTime() - ( i * 0.1 ) ) * ( 2 * intesity ) )

		if ( style == 1 ) then
			y_pos = y_pos - math.abs( mod )
		elseif ( style == 2 ) then
			y_pos = y_pos + math.abs( mod )
		else
			y_pos = y_pos - mod
		end

		draw.SimpleText( char, font, x + chars_x, y - ( 5 * y_pos ), color, xalign, yalign )
		chars_x = chars_x + charw
	end
end

function draw.SimpleLinearGradient(x, y, w, h, startColor, endColor, horizontal)
	draw.LinearGradient(x, y, w, h, { {offset = 0, color = startColor}, {offset = 1, color = endColor} }, horizontal)
end

local function createFonts()
	surface.CreateFont("Trebuchet48", {
		font = "Trebuchet MS",
		size = 72,
		weight = 500,
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

function SetupHUD()
	if IsValid(GUIElements.registering) then
		GUIElements.registering:Remove()
	end

	if IsValid(GUIElements.quick_hud) then
		GUIElements.quick_hud:Remove()
	end

	if IsValid(GUIElements.info_box) then
		GUIElements.info_box:Remove()
	end

	surface.SetFont("Trebuchet32")
	local money_w,h = surface.GetTextSize("1000000")
	
	GUIElements.quick_hud = vgui.Create("DPanel")
	GUIElements.quick_hud:SetSize(300, 100)
	GUIElements.quick_hud:SetPos(32, ScrH() - 100 - 32)
	GUIElements.quick_hud.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
		draw.SimpleText("GMStation", "Trebuchet24Bold", 18, 28, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(CL_GLOBALS.zone or "Somewhere", "Trebuchet16Add", w - 18, 28, Color(255, 255, 255, 100), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(CL_GLOBALS.money .. "cc", "Trebuchet32", 18, 66, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	GUIElements.info_box = vgui.Create("DPanel")
	GUIElements.info_box:SetSize(200, 100)
	GUIElements.info_box:SetPos(ScrW() - 200, 0)
	GUIElements.info_box.Paint = function(self, w, h)
		draw.SimpleText("GMStation", "Trebuchet24Bold", w/2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("PreAlpha", "Trebuchet16Bold", w/1.5, h / 2 + 20, Color(255, 175, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function GM:HUDDrawTargetID()
	return false
end

net.Receive("gmstation_first_join", function()
	if IsValid(GUIElements.registering) then
		GUIElements.registering:Remove()
	end

	GUIElements.registering = vgui.Create("DPanel")
	GUIElements.registering:SetSize(ScrW(), ScrH())
	GUIElements.registering.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 250))
		draw.SimpleText("Please wait while we register you...", "Trebuchet32", w/2, h/2 - 16, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("This may take a few seconds.", "Trebuchet16", w/2, h/2 + 16, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

function GM:HUDShouldDraw(name)
	return hudExceptions[name] || false
end

function GM:OnScreenSizeChanged(w, h)
	createFonts()
	if IsValid(GUIElements.quick_hud) then
		SetupHUD()
	end
end

net.Receive("gmstation_map_restart", function()
	local time = net.ReadFloat()

	if IsValid(GUIElements.restarting) then
		GUIElements.restarting:Remove()
	end

	timer.Create("gmstation_map_restart", time, 1, function() end)

	GUIElements.restarting = vgui.Create("DPanel")
	GUIElements.restarting:SetSize(300, 100)
	GUIElements.restarting:SetPos(ScrW() / 2 - GUIElements.restarting:GetWide() / 2, ScrH() / 2 - GUIElements.restarting:GetTall() / 2 + 32)
	GUIElements.restarting.Paint = function(self, w, h)
		local time = string.ToMinutesSeconds(timer.TimeLeft("gmstation_map_restart"))

		draw.SimpleText("MAP RESTART", "Trebuchet16Bold", w/2 + 1, h/2 + 1, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("MAP RESTART", "Trebuchet16Bold", w/2, h/2, Color(math.sin(CurTime() * 8) * 64 + 192, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(time, "Trebuchet8", w/2 + 1, h/2 + 20 + 1, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(time, "Trebuchet8", w/2, h/2 + 20, Color(math.sin(CurTime() * 8) * 64 + 192, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

createFonts()