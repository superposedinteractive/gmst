GM.Name = "GMStation Lobby"
GM.Author = "japannt, raizen"
GM.Website = "https://gmstation.raizen.de"

for k,v in ipairs(file.Find("gmstation/gamemode/sh/*.lua", "LUA")) do
	print("Shared file: "..v)
	AddCSLuaFile("sh/"..v)
	include("sh/"..v)
end