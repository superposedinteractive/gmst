GM.Name = "GMStation"
GM.Author = "superposed"
GM.Website = "https://superposed.xyz"
DeriveGamemode("gmstbase")

for k, v in ipairs(file.Find("gmstation/gamemode/sh/*.lua", "LUA")) do
	MsgN("[GMST] Shared file: " .. v)
	AddCSLuaFile("sh/" .. v)
	include("sh/" .. v)
end
