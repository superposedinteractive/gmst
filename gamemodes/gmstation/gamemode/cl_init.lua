include("shared.lua")

GLOBALS = {}
GLOBALS.url = "local.loopback"
GLOBALS.money = "???"
GLOBALS.volume = 0.5

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

if(!table.IsEmpty(LocalVars or {})) then
	for v in pairs(LocalVars) do
		LocalVars[v] = nil
		MsgN("[GMST] Removing "..v)
	end
end

if(!IsValid(GUIElements)) then
	GUIElements = {}
end

if(!IsValid(LocalVars)) then
	LocalVars = {}
end

for k,v in ipairs(file.Find("gmstation/gamemode/cl/*.lua", "LUA")) do
	MsgN("[GMST] Loading "..v)
	include("cl/"..v)
end