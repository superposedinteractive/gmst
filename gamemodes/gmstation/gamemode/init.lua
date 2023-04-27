AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SV_GLOBALS = {}
SV_GLOBALS.url = "https://superposed.xyz/gmstation/"
SV_GLOBALS.password = "651820566861d3bfe89ac8271aade105"

for k, v in ipairs(file.Find("gmstation/gamemode/cl/*.lua", "LUA")) do
	print("Adding "..v.." for client")
	AddCSLuaFile("cl/"..v)   
end

for k, v in ipairs(file.Find("gmstation/gamemode/sv/*.lua", "LUA")) do
	print("Loading "..v)
	include("sv/"..v)
end

resource.AddFile("/materials/gwenskin/gmstation.png")
resource.AddFile("/materials/gmstation/ui/hover_popup.png")
resource.AddFile("/materials/gmstation/ui/ply_gradient.png")

// add every file from /sound/gmstation/music/ and /sound/gmstation/sfx/ to the download list
for k, v in ipairs(file.Find("sound/gmstation/music/*.mp3", "GAME")) do
	MsgN("Adding "..v.." to download list")
	resource.AddFile("sound/gmstation/music/"..v)
end

for k, v in ipairs(file.Find("sound/gmstation/sfx/*.mp3", "GAME")) do
	MsgN("Adding "..v.." to download list")
	resource.AddFile("sound/gmstation/sfx/"..v)
end