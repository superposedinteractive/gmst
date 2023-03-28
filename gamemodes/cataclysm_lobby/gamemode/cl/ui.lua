// cataclysm - General UI
gameevent.Listen("player_changename")

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
	surface.CreateFont("Trebuchet16", {
		font = "Trebuchet MS",
		size = ScreenScale(8),
		weight = 500,
		antialias = true,
		shadow = false
	})
	surface.CreateFont("Trebuchet16Add", {
		font = "Trebuchet MS",
		size = ScreenScale(8),
		weight = 500,
		antialias = true,
		additive = true,
	})
end

createFonts()

function GM:OnScreenSizeChanged(w, h)
	createFonts()
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

local function SetupHUD()
	if IsValid(GUIElements.quick_hud) then
		GUIElements.quick_hud:Remove()
	end

	local width = 250
	local money = 1000000
	local nickname = LocalPlayer():Nick()
	
	if(string.len(nickname) > 16) then
		nickname = string.sub(nickname, 1, 16) .. "..."
	end
	surface.SetFont("Trebuchet24")
	local w,h = surface.GetTextSize(nickname)
	
	if(w < 250) then
		width = 250 + w
	else 
		width = 250
	end
	
	surface.SetFont("Trebuchet32")
	local money_w,h = surface.GetTextSize("1000000")
	
	GUIElements.quick_hud = vgui.Create("DPanel")
	GUIElements.quick_hud:SetSize(250 + w, 100)
	GUIElements.quick_hud:SetPos(32, ScrH() - GUIElements.quick_hud:GetTall() - 32)
	GUIElements.quick_hud.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
		WavyText(nickname, "Trebuchet24Bold", 20, 28, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, -1, 2)
		draw.SimpleText(LocalVars["zone"] or "Somewhere", "Trebuchet16Add", w - 18, 28, Color(255, 255, 255, 100), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(money .. "cc", "Trebuchet32", w/2, 66, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function GM:InitPostEntity()
	timer.Simple(0.1, function()
		SetupHUD()
	end)
end

hook.Add("player_changename", "cataclysm_nameUpdate", function()
	timer.Simple(0.5, function()
		SetupHUD()
	end)
end)

function GM:OnReloaded()
	SetupHUD()
end