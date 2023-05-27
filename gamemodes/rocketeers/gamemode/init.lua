AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

for k, v in ipairs(file.Find("rocketeers/gamemode/cl/*.lua", "LUA")) do
	MsgN("Adding " .. v .. " for client")
	AddCSLuaFile("cl/" .. v)
end

for k, v in ipairs(file.Find("rocketeers/gamemode/sv/*.lua", "LUA")) do
	MsgN("Loading " .. v)
	include("sv/" .. v)
end

MsgN("Rocketeers Server Loaded!")
