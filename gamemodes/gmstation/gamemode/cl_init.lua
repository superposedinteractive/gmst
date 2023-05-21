include("shared.lua")

for k, v in ipairs(file.Find("gmstation/gamemode/cl/*.lua", "LUA")) do
	MsgN("[GMST] Loading " .. v)
	include("cl/" .. v)
end

MsgN("[GMST] Client Loaded!")