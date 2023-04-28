AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SV_GLOBALS = {}
SV_GLOBALS.url = "https://superposed.xyz/gmstation"
SV_GLOBALS.password = "651820566861d3bfe89ac8271aade105"

for k, v in ipairs(file.Find("gmstbase/gamemode/cl/*.lua", "LUA")) do
	print("Adding "..v.." for client")
	AddCSLuaFile("cl/"..v)   
end

for k, v in ipairs(file.Find("gmstbase/gamemode/sv/*.lua", "LUA")) do
	print("Loading "..v)
	include("sv/"..v)
end

MsgN("GMSTBase Server Loaded!")