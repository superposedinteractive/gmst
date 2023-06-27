GM.Name = "GMStation"
GM.Author = "superposed"
GM.Website = "https://superposed.xyz/gmstation"

DeriveGamemode("sandbox")

for k, v in ipairs(file.Find("gmstbase/gamemode/sh/*.lua", "LUA")) do
	MsgN("[GMSTBase] Shared file: " .. v)
	AddCSLuaFile("sh/" .. v)
	include("sh/" .. v)
end

MsgN("[GMSTBase] Shared Loaded!")
