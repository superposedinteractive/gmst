include("shared.lua")

CL_GLOBALS = {}
CL_GLOBALS.url = "https://superposed.xyz/gmstation/"
CL_GLOBALS.money = "0"

if not oldChat then
	MsgN("[GMST] Overriding chat.AddText")
	oldChat = chat.AddText
end

if not GUIElements then
	GUIElements = {}
end

if not table.IsEmpty(GUIElements or {}) then
	for v in pairs(GUIElements) do
		GUIElements[v]:Remove()
		MsgN("[GMST] Removing "..v)
		chat.AddText(Color(255, 0, 0), "[GMST] Removing "..v)
	end
end

for k, v in ipairs(file.Find("gmstation/gamemode/cl/*.lua", "LUA")) do
	MsgN("[GMST] Loading "..v)
	include("cl/"..v)
end