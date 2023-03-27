// cataclysm - General UI

local quick_hud

if(IsValid(quick_hud)) then
	quick_hud:Remove()
end

local hudExceptions = {
	["CHudCrosshair"] = true,
	["CHudCloseCaption"] = true,
	["CHudDamageIndicator"] = true,
	["CHudMessage"] = true,
	["CHudHintDisplay"] = true,
	["CHudWeapon"] = true,
	["CHudGMod"] = true,
	["CHudChat"] = true,
	["NetGraph"] = true
}

function GM:HUDShouldDraw(name)
	return hudExceptions[name] || false
end

local function createFonts()
	surface.CreateFont("Trebuchet32", {
		font = "Trebuchet MS",
		size = ScreenScale(16),
		weight = 500,
		antialias = true,
		shadow = false
	})
	surface.CreateFont("Trebuchet24Bold", {
		font = "Trebuchet MS",
		size = ScreenScale(12),
		weight = 1000,
		antialias = true,
		shadow = false
	})
end

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

function WavyText(text, font, x, y, color, xalign, yalign, style, intesity)
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

quick_hud = vgui.Create("DPanel")
quick_hud:SetSize(250, 100)
quick_hud:SetPos(32, ScrH() - quick_hud:GetTall() - 32)
quick_hud.Paint = function(self, w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 255))
	draw.SimpleText("Cataclysm", "Trebuchet24Bold", 32, 26, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText("100cc", "Trebuchet32", 32, 64, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

createFonts()