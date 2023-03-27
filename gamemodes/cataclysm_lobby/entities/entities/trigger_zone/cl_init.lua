include("shared.lua")

local music = {
	["Trainstation"] = "/sound/music/lobby1.mp3"
}

net.Receive("cataclysm_zone", function()
	local zone = net.ReadString()
	if music[zone] then
		surface.PlaySound(music[zone])
	end
end)