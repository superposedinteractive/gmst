include("shared.lua")

if(!table.IsEmpty(GUIElements or {})) then
	for v in pairs(GUIElements) do
		GUIElements[v]:Remove()
		print("Removing "..v)
	end
end

if(!IsValid(GUIElements)) then
	GUIElements = {}
end

for k,v in ipairs(file.Find("cataclysm_lobby/gamemode/cl/*.lua", "LUA")) do
	print("Loading "..v)
	include("cl/"..v)
end