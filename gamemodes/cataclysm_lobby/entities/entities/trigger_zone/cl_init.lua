include("shared.lua")

local music = {
    ["Lobby"] = "/cataclysm/music/lobby2.mp3"
}

local LoadedSounds = {}
local currentSound = nil

net.Receive("cataclysm_zone", function()
    local zone = net.ReadString()
	LocalVars["zone"] = zone

    if music[zone] then
        local snd = music[zone]

        if LoadedSounds[snd] == nil then
            if !IsValid(LocalPlayer()) then 
                timer.Simple(1, function() 
                    LoadedSounds[snd] = CreateSound(LocalPlayer(), snd)
                end)
            else
                LoadedSounds[snd] = CreateSound(LocalPlayer(), snd)
            end
        end

        if(currentSound ~= nil) then
            currentSound:FadeOut(3)
        end

        if !IsValid(LocalPlayer()) then 
			timer.Simple(1, function() 
				currentSound = LoadedSounds[snd]
				currentSound:Play()
				currentSound:ChangeVolume(0)
				currentSound:ChangeVolume(1, 3)
			end)
		else
			currentSound = LoadedSounds[snd]
			currentSound:Play()
			currentSound:ChangeVolume(0)
			currentSound:ChangeVolume(1, 3)
		end            
    else
		if currentSound ~= nil then
			currentSound:FadeOut(3)
		end
	end
end)