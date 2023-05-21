include("shared.lua")

for k, v in ipairs(file.Find("gmstation/gamemode/cl/*.lua", "LUA")) do
	MsgN("[GMST] Loading " .. v)
	include("cl/" .. v)
end

Derma_Message("Welcome to GMStation!\nThis is a very early version of the gamemode, so expect bugs and missing features.\nIf you find any bugs, please report them on the Discord (https://discord.gg/EnadGnaAGm).\n\nHave fun!", "GMStation", "Sounds neat.")

MsgN("[GMST] Client Loaded!")