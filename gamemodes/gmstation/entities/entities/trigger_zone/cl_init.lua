include("shared.lua")

local Sounds = {
	["Trainstation"] = {
		["Volume"] = 0.25,
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
	},
	["MUM I'M OOB!!!"] = {
		["Loop"] = true,
		["Duration"] = {272.44},
		["Sounds"] = {"/gmstation/music/camcum.mp3"}
	}
}

local LoadedSounds = {}

function GMST_Zone(name)
	if name == CL_GLOBALS.zone then return end
	CL_GLOBALS.zone = name

	if Sounds[name] then
		local snd = Sounds[name]
		local loop = snd["Loop"] || false
		MsgN("[GMST] Playing sound for zone " .. name .. ", " .. tostring(snd["Sounds"][1]))

		if IsValid(LocalPlayer()) then
			PlaySound(snd, loop)
		else
			timer.Simple(1, function()
				PlaySound(snd, loop)
			end)
		end
	else
		MsgN("[GMST] No sound for zone " .. name .. "!")

		if CL_GLOBALS.currentSound != nil && name != CL_GLOBALS.zone then
			CL_GLOBALS.currentSound:FadeOut(3)
		end
	end
end

net.Receive("gmstation_zone", function()
	local zone = net.ReadString()
	GMST_Zone(zone)
end)

function PlaySound(snd, loop)
	local roll = math.random(#snd["Sounds"])
	local sndFile = snd["Sounds"][roll]
	local volume = (snd["Volume"] || 1) * CL_GLOBALS.volume
	CL_GLOBALS.ogVolume = snd["Volume"] || 1
	timer.Remove("gmstation_looping_music")

	if LoadedSounds[sndFile] == nil then
		if IsValid(LocalPlayer()) then
			LoadedSounds[sndFile] = CreateSound(LocalPlayer(), sndFile)
		end
	end

	if CL_GLOBALS.currentSound != nil then
		CL_GLOBALS.currentSound:FadeOut(3)
	end

	if IsValid(LocalPlayer()) then
		CL_GLOBALS.currentSound = LoadedSounds[sndFile]
		CL_GLOBALS.currentSound:PlayEx(0, 100)

		if loop then
			local dur = snd["Duration"][roll]

			timer.Create("gmstation_looping_music", dur - 3, 0, function()
				MsgN("[GMST] Looping music at " .. volume .. " volume")
				CL_GLOBALS.currentSound:Stop()
				CL_GLOBALS.currentSound:PlayEx(volume, 100)
			end)
		end

		CL_GLOBALS.currentSound:ChangeVolume(volume)
	else
		timer.Simple(1, function()
			PlaySound(snd)
		end)
	end
end

concommand.Add("gmst_zone", function(ply, cmd, args)
	local zone = args[1]

	if zone == nil then
		MsgN("[GMST] No zone specified")

		return
	end

	MsgN("[GMST] Changing zone to " .. zone)
	GMST_Zone(zone)
end, nil, "Change the zone")
