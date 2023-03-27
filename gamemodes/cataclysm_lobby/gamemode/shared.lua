GM.Name = "Cataclysm Lobby"
GM.Author = "japannt, raizen"
GM.Website = "https://cataclysm.raizen.de"

for k,v in ipairs(file.Find("cataclysm_lobby/gamemode/sh/*.lua", "LUA")) do
	print("Shared file: "..v)
	AddCSLuaFile("sh/"..v)
	include("sh/"..v)
end