include("shared.lua")

if !oldChat then
	MsgN("Overriding chat.AddText")
	oldChat = chat.AddText
end

if(!table.IsEmpty(GUIElements or {})) then
	for v in pairs(GUIElements) do
		GUIElements[v]:Remove()
		print("Removing "..v)
	end
end

if(!table.IsEmpty(LocalVars or {})) then
	for v in pairs(LocalVars) do
		LocalVars[v] = nil
		print("Removing "..v)
	end
end

if(!IsValid(GUIElements)) then
	GUIElements = {}
end

if(!IsValid(LocalVars)) then
	LocalVars = {}
end

for k,v in ipairs(file.Find("gmstation/gamemode/cl/*.lua", "LUA")) do
	print("Loading "..v)
	include("cl/"..v)
end