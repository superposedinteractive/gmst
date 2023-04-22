util.AddNetworkString("gmstation_first_join")
util.AddNetworkString("gmstation_first_join_done")

local function apiPanic()
	MsgN("[GMST] API is down. Kicking all players.")
	gameevent.Listen("player_connect")
	hook.Add("player_connect", "gmstation_kick", function(data)
		game.KickID(data.networkid, "\nGMStation is currently experiencing API downtime. Please try again later.\nSorry.")
	end)
	for k, v in pairs(player.GetAll()) do
		ULib.kick(v, "\nGMStation is currently experiencing API downtime. Please try again later.\nSorry.")
	end
end

function apiCall(url, args, callback)
	local get = ""
	for k, v in pairs(args) do
		get = get .. k .. "=" .. v .. "&"
	end
	get = string.sub(get, 1, string.len(get) - 1)

	MsgN("http://" .. GLOBALS.url .. "/api/" .. url .. ".php" .. "?" .. get)

	http.Fetch("http://" .. GLOBALS.url .. "/api/" .. url .. ".php" .. "?" .. get, function(body, len, headers, code)
		if callback then
			callback(body, len, headers, code)
		end
	end, function(error)
		MsgN(error)
		apiPanic()
	end)
end

function GM:PlayerInitialSpawn(ply)
	apiCall("gmstPlayerExists", {steamid = ply:SteamID64()}, function(body, len, headers, code)
		if body != "0" then
			MsgN("[GMST] Player " .. ply:Name() .. " is not registered, registering...")
			net.Start("gmstation_first_join")
			net.Send(ply)

			ply:Lock()

			timer.Simple(5, function()
				apiCall("gmstRegisterPlayer", {steamid = ply:SteamID64(), password = GLOBALS.password}, function(body, len, headers, code)
					if body == "0" then
						MsgN("[GMST] Registered " .. ply:Name())
						net.Start("gmstation_first_join_done")
						net.Send(ply)
						ply:UnLock()
					end
				end)
			end)
		else
			net.Start("gmstation_first_join_done")
			net.Send(ply)
		end
	end)

	if timer.Exists("gmstation_map_restart") then
		net.Start("gmstation_map_restart")
			net.WriteFloat(timer.TimeLeft("gmstation_map_restart"))
		net.Send(ply)
	end
end

apiCall("gmstHello", {}, function(body, len, headers, code)
	if body != "0" then
		apiPanic()
	else
		MsgN("[GMST] API Ok")
	end
end, function(error)
	apiPanic()
end)