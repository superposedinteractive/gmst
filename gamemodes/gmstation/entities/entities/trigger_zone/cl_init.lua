include("shared.lua")

local Sounds = {
	[ "Trainstation" ] = {
		[ "Volume" ] = 0.25,
		[ "Sounds" ] = {"/ambient/atmosphere/station_ambience_loop2.wav"}
	},
	[ "Lobby" ] = {
		[ "Loop" ] = true,
		[ "Duration" ] = {220.16, 294.50, 240.09},
		[ "Sounds" ] = {"/gmstation/music/lobby1.mp3", "/gmstation/music/lobby2.mp3", "/gmstation/music/lobby3.mp3"}
	},
	[ "Outside" ] = {
		[ "Loop" ] = true,
		[ "Duration" ] = {139.23, 214.15},
		[ "Sounds" ] = {"/gmstation/music/lakeside.mp3", "/gmstation/music/lakeside2.mp3"}
	},
	[ "Seaside" ] = {
		[ "Loop" ] = true,
		[ "Duration" ] = {94.17},
		[ "Sounds" ] = {"/gmstation/music/lobbyroof.mp3"}
	},
	[ "Comedically long tunnel that serves no purpose" ] = {
		[ "Sounds" ] = {"ambient/tones/tunnel_wind_loop.wav"}
	}
}

local LoadedSounds = {}

net.Receive("gmstation_zone", function()
	local zone = net.ReadString()
	if zone == CL_GLOBALS.zone then return end
	CL_GLOBALS.zone = zone

	if Sounds[ zone ] then
		local snd = Sounds[ zone ]
		local loop = snd[ "Loop" ] || false

		if IsValid(LocalPlayer()) then
			PlaySound(snd, loop)
		else
			timer.Simple(1, function()
				PlaySound(snd, loop)
			end)
		end
	else
		if CL_GLOBALS.currentSound != nil && zone != CL_GLOBALS.zone then
			CL_GLOBALS.currentSound:FadeOut(3)
		end
	end
end)

function PlaySound(snd, loop)
	local roll = math.random(#snd[ "Sounds" ])
	local sndFile = snd[ "Sounds" ][ roll ]
	local volume = (snd[ "Volume" ] || 1) * CL_GLOBALS.volume
	CL_GLOBALS.ogVolume = snd[ "Volume" ] || 1
	timer.Remove("gmstation_looping_music")

	if LoadedSounds[ sndFile ] == nil then
		if IsValid(LocalPlayer()) then
			LoadedSounds[ sndFile ] = CreateSound(LocalPlayer(), sndFile)
		end
	end

	if CL_GLOBALS.currentSound != nil then
		CL_GLOBALS.currentSound:FadeOut(3)
	end

	if IsValid(LocalPlayer()) then
		CL_GLOBALS.currentSound = LoadedSounds[ sndFile ]
		CL_GLOBALS.currentSound:PlayEx(0, 100)

		if loop then
			local dur = snd[ "Duration" ][ roll ]

			timer.Create("gmstation_looping_music", dur - 3, 0, function()
				CL_GLOBALS.currentSound:Stop()
				CL_GLOBALS.currentSound:PlayEx(0, 100)
				CL_GLOBALS.currentSound:ChangeVolume(volume)
			end)
		end

		CL_GLOBALS.currentSound:ChangeVolume(volume)
	else
		timer.Simple(1, function()
			PlaySound(snd)
		end)
	end
end
