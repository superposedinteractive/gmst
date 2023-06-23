util.AddNetworkString("gmstation_terms")
util.AddNetworkString("gmstation_first_join")
util.AddNetworkString("gmstation_first_join_done")

function apiCall(url, args, callback)
	local get = ""

	for k, v in pairs(args) do
		get = get .. k .. "=" .. v .. "&"
	end

	get = string.sub(get, 1, string.len(get) - 1)
	MsgN("[GMSTBase] Requesting: " .. SV_GLOBALS.url .. "/api/" .. url .. ".php" .. "?" .. get)

	http.Fetch(SV_GLOBALS.url .. "/api/" .. url .. ".php" .. "?" .. get, function(body, len, headers, code)
		MsgN("[GMSTBase] API Response: " .. body)
		body = util.JSONToTable(body)

		if body["error"] != nil then
			MsgN("[GMSTBase] API Error!")

			timer.Simple(240, function()
				apiPanic()
			end)

			return
		end

		if callback then
			callback(body, len, headers, code)
		end
	end, function(error)
		MsgN(error)
		apiPanic()
	end)
end

local function apiPanic()
	MsgN("[GMSTBase] API is down. Kicking all players.")
	gameevent.Listen("player_connect")

	hook.Add("player_connect", "gmstation_kick", function(data)
		game.KickID(data.networkid, "GMStation is currently experiencing an API outage. Please try again later.\nSorry...")
	end)

	for k, v in pairs(player.GetAll()) do
		if ULib then
			ULib.kick(v, "GMStation is currently experiencing an API outage. Please try again later.\n\nSorry...")
		else
			v:Kick("GMStation is currently experiencing an API outage. Please try again later.\n\nSorry...")
		end
	end
end

local function regPlayer(ply)
	net.Start("gmstation_first_join")
	net.Send(ply)
	ply:Freeze(true)

	timer.Simple(1, function()
		apiCall("player_register", {
			steamid = ply:SteamID64(),
			password = SV_GLOBALS.password
		}, function(body, len, headers, code)
			MsgN("[GMSTBase] Registered " .. ply:Name())
			net.Start("gmstation_first_join_done")
			net.WriteString(ply:SteamID64())
			net.Send(ply)
			PlayerInit(ply)
			ply:Freeze(false)
		end)
	end)
end

function GM:PlayerInitialSpawn(ply)
	if GMSTInitialSpawn then
		GMSTInitialSpawn(ply)
	end

	ply:Freeze(true)

	apiCall("player_exists", {
		steamid = ply:SteamID64()
	}, function(body, len, headers, code)
		if body["exists"] == false then
			if !ply:IsBot() then
				MsgN("[GMSTBase] Player " .. ply:Name() .. " has not accepted ToS yet, sending...")
				net.Start("gmstation_terms")
				net.Send(ply)
			else
				MsgN("[GMSTBase] Player " .. ply:Name() .. " is a bot, skipping ToS...")
				regPlayer(ply)
			end
		else
			net.Start("gmstation_first_join_done")
			net.WriteString(ply:SteamID64())
			net.Send(ply)
			PlayerInit(ply)
			ply:Freeze(false)
		end
	end)

	if timer.Exists("gmstation_map_restart") then
		net.Start("gmstation_map_restart")
		net.WriteFloat(timer.TimeLeft("gmstation_map_restart"))
		net.Send(ply)
	end
end

net.Receive("gmstation_terms", function(_, ply)
	apiCall("player_exists", {
		steamid = ply:SteamID64()
	}, function(body, len, headers, code)
		if body["exists"] == true then
			MsgN("[GMSTBase] Player " .. ply:Name() .. " has already accepted ToS, skipping...")
			net.Start("gmstation_first_join_done")
			net.WriteString(ply:SteamID64())
			net.Send(ply)
			ply:Freeze(false)

			return
		end
	end)

	MsgN("[GMSTBase] Player " .. ply:Name() .. " accepted ToS, registering...")
	regPlayer(ply)
end)

apiCall("hello", {}, function(body, len, headers, code)
	MsgN("[GMSTBase] API Ok")
end)
