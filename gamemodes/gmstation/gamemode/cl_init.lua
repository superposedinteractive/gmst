include("shared.lua")

CL_GLOBALS = {}
CL_GLOBALS.url = "local.loopback/gmstation"
CL_GLOBALS.money = "0"

if !oldChat then
	MsgN("[GMST] Overriding chat.AddText")
	oldChat = chat.AddText
end

if not IsValid(GUIElements) then
	GUIElements = {}
end

if not table.IsEmpty(GUIElements or {}) then
	for v in pairs(GUIElements) do
		GUIElements[v]:Remove()
		MsgN("[GMST] Removing "..v)
	end
end

for k, v in ipairs(file.Find("gmstation/gamemode/cl/*.lua", "LUA")) do
	MsgN("[GMST] Loading "..v)
	include("cl/"..v)
end