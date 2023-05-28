include("shared.lua")

if !CL_GLOBALS then
	CL_GLOBALS = {}
end

CL_GLOBALS.url = "https://superposed.xyz/gmstation"
CL_GLOBALS.money = 0

if !oldChat then
	MsgN("[GMSTBase] Overriding chat.AddText")
	oldChat = chat.AddText
end

if !GUIElements then
	GUIElements = {}
end

if !table.IsEmpty(GUIElements || {}) then
	for v in pairs(GUIElements) do
		GUIElements[v]:Remove()
		MsgN("[GMSTBase] Removing " .. v)
	end
end

for k, v in ipairs(file.Find("gmstbase/gamemode/cl/*.lua", "LUA")) do
	MsgN("[GMSTBase] Loading " .. v)
	include("cl/" .. v)
end

function GM:ForceDermaSkin()
	MsgN("Forcing GMStation skin...")

	return "GMStation"
end

MsgN("[GMSTBase] Client Loaded!")
