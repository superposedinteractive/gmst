include("shared.lua")

local Sounds = {
	["Trainstation"] = {
		["Volume"] = 0.5,
		["Sounds"] = {"/ambient/atmosphere/station_ambience_loop2.wav"}
	},
	["Lobby"] = {
		["Loop"] = true,
		["Duration"] = {220.16, 294.50, 240.09},
		["Sounds"] = {"/gmstation/music/lobby1.mp3", "/gmstation/music/lobby2.mp3", "/gmstation/music/lobby3.mp3"}
	},
	["Outside"] = {
		["Loop"] = true,
		["Duration"] = {139.23, 214.15},
		["Sounds"] = {"/gmstation/music/lakeside.mp3", "/gmstation/music/lakeside2.mp3"}
	},
	["Seaside"] = {
		["Loop"] = true,
		["Duration"] = {94.17},
		["Sounds"] = {"/gmstation/music/lobbyroof.mp3"}
	},
	["Comedically long tunnel that serves no purpose"] = {
		["Sounds"] = {"ambient/tones/tunnel_wind_loop.wav"}
	}
}

local LoadedSounds = {}

net.Receive("gmstation_zone", function()
	local zone = net.ReadString()

	if zone == LocalVars["zone"] then return end

	LocalVars["zone"] = zone

	if Sounds[zone] then
		local snd = Sounds[zone]
		local loop = snd["Loop"] or false

		if IsValid(LocalPlayer()) then
			PlaySound(snd, loop)
		else
			timer.Simple(1, function()
				PlaySound(snd, loop)
			end)
		end
	else
		if GLOBALS.currentSound ~= nil && zone ~= LocalVars["zone"] then
			GLOBALS.currentSound:FadeOut(3)
		end
	end
end)

function PlaySound(snd, loop)
	local roll = math.random(#snd["Sounds"])
	local sndFile = snd["Sounds"][roll]
	local volume = (snd["Volume"] or 1) * GLOBALS.volume
	GLOBALS.ogVolume = snd["Volume"] or 1

	print("Playing sound: " .. sndFile)
	print("Volume: " .. volume)

	timer.Remove("gmstation_looping_music")

	if LoadedSounds[sndFile] == nil then
		if IsValid(LocalPlayer()) then
			LoadedSounds[sndFile] = CreateSound(LocalPlayer(), sndFile)
		end
	end

	if GLOBALS.currentSound ~= nil then
		GLOBALS.currentSound:FadeOut(3)
	end

	if IsValid(LocalPlayer()) then
		GLOBALS.currentSound = LoadedSounds[sndFile]
		GLOBALS.currentSound:PlayEx(0, 100)

		if loop then
			local dur = snd["Duration"][roll]

			timer.Create("gmstation_looping_music", dur - 3, 0, function()
				GLOBALS.currentSound:Stop()
				GLOBALS.currentSound:PlayEx(0, 100)
				GLOBALS.currentSound:ChangeVolume(volume)
			end)
		end

		GLOBALS.currentSound:ChangeVolume(volume)
	else
		timer.Simple(1, function()
			PlaySound(snd)
		end)
	end
end