include("shared.lua")

GLOBALS = {}
GLOBALS.url = "local.loopback/gmstation"
GLOBALS.money = "0"

if !oldChat then
	MsgN("[GMST] Overriding chat.AddText")
	oldChat = chat.AddText
end

if(!table.IsEmpty(GUIElements or {})) then
	for v in pairs(GUIElements) do
		GUIElements[v]:Remove()
		MsgN("[GMST] Removing "..v)
	end
end

if(!IsValid(GUIElements)) then
	GUIElements = {}
end

for k,v in ipairs(file.Find("gmstation/gamemode/cl/*.lua", "LUA")) do
	MsgN("[GMST] Loading "..v)
	include("cl/"..v)
end