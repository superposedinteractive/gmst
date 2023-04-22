GM.Name = "GMStation"
GM.Author = "superposed"
GM.Website = "https://superposed.xyz"

for k,v in ipairs(file.Find("gmstation/gamemode/sh/*.lua", "LUA")) do
	print("Shared file: "..v)
	AddCSLuaFile("sh/"..v)
	include("sh/"..v)
end