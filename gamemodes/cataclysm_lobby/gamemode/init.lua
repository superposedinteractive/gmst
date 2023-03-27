AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

for k,v in ipairs(file.Find("cataclysm_lobby/gamemode/cl/*.lua", "LUA")) do
	print("Adding "..v.." for client")
	AddCSLuaFile("cl/"..v)   
end

for k,v in ipairs(file.Find("cataclysm_lobby/gamemode/sv/*.lua", "LUA")) do
	print("Loading "..v)
	include("sv/"..v)
end