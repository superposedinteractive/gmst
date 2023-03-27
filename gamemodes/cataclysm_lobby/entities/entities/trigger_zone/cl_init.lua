include("shared.lua")

local music = {
    ["Trainstation"] = "music/lobby1.mp3",
    ["Lobby"] = "music/lobby2.mp3"
}

if LoadedSounds == nil then
    LoadedSounds = {}
end

local currentSound = nil

net.Receive("cataclysm_zone", function()
    local zone = net.ReadString()
    print("Entering zone " .. zone)

    if music[zone] then
        local snd = music[zone]
        print("Playing " .. zone)

        if LoadedSounds[snd] == nil then
            LoadedSounds[snd] = CreateSound(LocalPlayer(), snd)
        end

        if currentSound ~= nil then
            currentSound:FadeOut(3)
        end

        currentSound = LoadedSounds[snd]
        currentSound:Play()
        currentSound:ChangeVolume(0)
        currentSound:ChangeVolume(1, 3)
    end
end)