GM.Name = "GMStation"
GM.Author = "superposed"
GM.Website = "https://superposed.xyz/gmstation"

for k, v in ipairs(file.Find("gmstbase/gamemode/sh/*.lua", "LUA")) do
	print("Shared file: "..v)
	AddCSLuaFile("sh/"..v)
	include("sh/"..v)
end