include("shared.lua")

local Sounds = {
    ["Trainstation"] = {
        ["Volume"] = 0.1,
        ["Dsp"] = 1,
        ["Sounds"] = {"/ambient/atmosphere/station_ambience_loop2.wav"}
    },
    ["Lobby"] = {
        ["Dsp"] = 2,
        ["Sounds"] = {"/cataclysm/music/lobby1.mp3", "/cataclysm/music/lobby2.mp3", "/cataclysm/music/lobby3.mp3",}
    }
}

local LoadedSounds = {}
local currentSound = nil

net.Receive("cataclysm_zone", function()
    local zone = net.ReadString()
    LocalVars["zone"] = zone

    if Sounds[zone] then
        local snd = Sounds[zone]
        PrintTable(snd)

        if IsValid(LocalPlayer()) then
            PlaySound(snd)
        else
            timer.Simple(1, function()
                PlaySound(snd)
            end)
        end
    else
        if currentSound ~= nil then
            currentSound:FadeOut(3)
        end
    end
end)

function PlaySound(snd)
    local sndFile = snd["Sounds"][math.random(#snd["Sounds"])]

    if LoadedSounds[sndFile] == nil then
        LoadedSounds[sndFile] = CreateSound(LocalPlayer(), sndFile)
    end

    if currentSound ~= nil then
        currentSound:FadeOut(3)
    end

    currentSound = LoadedSounds[sndFile]
    currentSound:PlayEx(0, 100)
    currentSound:SetDSP(snd["Dsp"] or 0)
    currentSound:ChangeVolume(snd["Volume"] or 1, 3)
end