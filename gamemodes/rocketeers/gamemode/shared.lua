GM.Name = "GMStation"
GM.Author = "superposed"
GM.Website = "https://superposed.xyz"

DeriveGamemode("gmstbase")

for k, v in ipairs(file.Find("rocketeers/gamemode/sh/*.lua", "LUA")) do
	print("Shared file: "..v)
	AddCSLuaFile("sh/"..v)
	include("sh/"..v)
end

MsgN("Rocketeers Shared Loaded!")