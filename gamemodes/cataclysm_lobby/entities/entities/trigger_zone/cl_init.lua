include("shared.lua")

local music = {
    ["Trainstation"] = "music/lobby1.mp3",
    ["Lobby"] = "music/lobby2.mp3"
}

if LoadedSounds == nil then
    LoadedSounds = {}

    for key, value in pairs(music) do
        LoadedSounds[value] = CreateSound(LocalPlayer(), value)
    end
end

local currentSound = nil

net.Receive("cataclysm_zone", function()
    local zone = net.ReadString()
    print("Entering zone " .. zone)

    if music[zone] then
        print("Playing " .. music[zone])

        if currentSound ~= nil then
            currentSound:FadeOut(3)
        end

        currentSound = LoadedSounds[music[zone]]
        currentSound:Play()
        currentSound:ChangeVolume(0)
        currentSound:ChangeVolume(1, 3)
    end
end)