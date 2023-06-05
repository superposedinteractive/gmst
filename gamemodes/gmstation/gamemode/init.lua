AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

for k, v in ipairs(file.Find("gmstation/gamemode/cl/*.lua", "LUA")) do
	MsgN("[GMST] Adding " .. v .. " for client")
	AddCSLuaFile("cl/" .. v)
end

for k, v in ipairs(file.Find("gmstation/gamemode/sv/*.lua", "LUA")) do
	MsgN("[GMST] Loading " .. v)
	include("sv/" .. v)
end

MsgN("[GMST] Server Loaded!")
