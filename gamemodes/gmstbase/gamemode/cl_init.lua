include("shared.lua")

CL_GLOBALS = {}
CL_GLOBALS.url = "https://superposed.xyz/gmstation"
CL_GLOBALS.money = "0"

if not oldChat then
	MsgN("[GMSTBase] Overriding chat.AddText")
	oldChat = chat.AddText
end

if not GUIElements then
	GUIElements = {}
end

if not table.IsEmpty(GUIElements or {}) then
	for v in pairs(GUIElements) do
		GUIElements[v]:Remove()
		MsgN("[GMSTBase] Removing "..v)
	end
end

for k, v in ipairs(file.Find("gmstbase/gamemode/cl/*.lua", "LUA")) do
	MsgN("[GMSTBase] Loading "..v)
	include("cl/"..v)
end

MsgN("GMSTBase Client Loaded!")