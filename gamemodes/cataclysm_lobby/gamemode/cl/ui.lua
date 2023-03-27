// cataclysm - General UI

local hudExceptions = {
    "CHudCrosshair",
    "CHudCloseCaption",
    "CHudDamageIndicator",
    "CHudMessage",
    "CHudHintDisplay",
    "CHudWeapon",
    "CHudGMod",
    "CHudChat",
}

function GM:HUDShouldDraw(name)
    return table.HasValue(hudExceptions, name)
end