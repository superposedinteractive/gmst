// cataclysm - General UI

local hudExceptions = {
	["CHudCrosshair"] = true,
	["CHudCloseCaption"] = true,
	["CHudDamageIndicator"] = true,
	["CHudMessage"] = true,
	["CHudHintDisplay"] = true,
	["CHudWeapon"] = true,
	["CHudGMod"] = true,
	["CHudChat"] = true,
}

function GM:HUDShouldDraw(name)
	return hudExceptions[name] || false
end