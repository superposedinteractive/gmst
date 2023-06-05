include("shared.lua")

for k, v in ipairs(file.Find("rocketeers/gamemode/cl/*.lua", "LUA")) do
	MsgN("[Rocketeers] Loading " .. v)
	include("cl/" .. v)
end

MsgN("Rocketeers Client Loaded!")
