include("shared.lua")

local Sounds = {
	["Trainstation"] = {
		["Volume"] = 0.1,
		["Sounds"] = {"/ambient/atmosphere/station_ambience_loop2.wav"}
	},
	["Lobby"] = {
		["Loop"] = true,
		["Sounds"] = {"/gmstation/music/lobby1.mp3", "/gmstation/music/lobby2.mp3", "/gmstation/music/lobby3.mp3"}
	},
	["Outside"] = {
		["Loop"] = true,
		["Sounds"] = {"/gmstation/music/lakeside.mp3", "/gmstation/music/lakeside2.mp3"}
	},
	["Seaside"] = {
		["Loop"] = true,
		["Sounds"] = {"/gmstation/music/lobbyroof.mp3"}
	},
	["Comedically long tunnel that serves no purpose"] = {
		["Sounds"] = {"ambient/tones/tunnel_wind_loop.wav"}
	}
}

local LoadedSounds = {}
local currentSound = nil

net.Receive("gmstation_zone", function()
	local zone = net.ReadString()

	if zone == LocalVars["zone"] then return end

	LocalVars["zone"] = zone

	if Sounds[zone] then
		local snd = Sounds[zone]
		local loop = snd["Loop"] or false

		PrintTable(snd)

		if IsValid(LocalPlayer()) then
			PlaySound(snd, loop)
		else
			timer.Simple(1, function()
				PlaySound(snd, loop)
			end)
		end
	else
		if currentSound ~= nil && zone ~= LocalVars["zone"] then
			currentSound:FadeOut(3)
		end
	end
end)


function PlaySound(snd, loop)
	// We need to rewrite this to IGmodAudioChannel because CSoundPatch is fucked
	// but IGmodAudioChannel has no fade-outs and fade-ins etc

	local sndFile = snd["Sounds"][math.random(#snd["Sounds"])]

	timer.Remove("gmstation_looping_music")

	if LoadedSounds[sndFile] == nil then
		if IsValid(LocalPlayer()) then
			LoadedSounds[sndFile] = CreateSound(LocalPlayer(), sndFile)
		end
	end

	if currentSound ~= nil then
		currentSound:FadeOut(3)
	end

	if IsValid(LocalPlayer()) then
		currentSound = LoadedSounds[sndFile]
		currentSound:PlayEx(0, 100)

		if loop && system.IsWindows() then // Linux GMod breaks SoundDuration on linux so fuck it
			local dur = SoundDuration(sndFile) * 2.0

			timer.Create("gmstation_looping_music", dur, 0, function()
				PlaySound(snd)
			end)
		end

		currentSound:ChangeVolume(snd["Volume"] or 1, 3)
	else
		timer.Simple(1, function()
			PlaySound(snd)
		end)
	end
end