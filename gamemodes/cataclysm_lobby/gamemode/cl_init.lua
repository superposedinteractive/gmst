include("shared.lua")

HUDElements = {}

for k,v in ipairs(file.Find("cataclysm_lobby/gamemode/cl/*.lua", "LUA")) do
	print("Loading "..v)
	include("cl/"..v)
end