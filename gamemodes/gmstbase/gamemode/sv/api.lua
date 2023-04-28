util.AddNetworkString("gmstation_first_join")
util.AddNetworkString("gmstation_first_join_done")

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

function apiCall(url, args, callback)
	local get = ""
	for k, v in pairs(args) do
		get = get .. k .. "=" .. v .. "&"
	end
	get = string.sub(get, 1, string.len(get) - 1)

	MsgN(SV_GLOBALS.url .. "/api/" .. url .. ".php" .. "?" .. get)

	http.Fetch(SV_GLOBALS.url .. "/api/" .. url .. ".php" .. "?" .. get, function(body, len, headers, code)
		body = tonumber(body)

		if body == -1 || body == -6 || body == nil then
			MsgN("[GMSTBase] API Error!")
			for i = 1, 6000, 1 do
				timer.Simple(i / 60, function()
					local str = "DUMP"
					for i = 1, math.random(1, 100), 1 do
						str = str .. string.char(math.random(32, 126))
					end
					PlayerMessage(nil, Color(255, 0, 0), str)
				end)
			end
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

function GM:PlayerInitialSpawn(ply)
	apiCall("gmstPlayerExists", {steamid = ply:SteamID64()}, function(body, len, headers, code)
		if body != 0 then
			MsgN("[GMSTBase] Player " .. ply:Name() .. " is not registered, registering...")
			net.Start("gmstation_first_join")
			net.Send(ply)

			ply:Lock()

			timer.Simple(10, function()
				apiCall("gmstRegisterPlayer", {steamid = ply:SteamID64(), password = SV_GLOBALS.password}, function(body, len, headers, code)
					if body == 0 then
						MsgN("[GMSTBase] Registered " .. ply:Name())
						net.Start("gmstation_first_join_done")
							net.WriteString(ply:SteamID64())
						net.Send(ply)
						ply:UnLock()
					end
				end)
			end)
		else
			net.Start("gmstation_first_join_done")
				net.WriteString(ply:SteamID64())
			net.Send(ply)
		end
	end)

	if timer.Exists("gmstation_map_restart") then
		net.Start("gmstation_map_restart")
			net.WriteFloat(timer.TimeLeft("gmstation_map_restart"))
		net.Send(ply)
	end

	PlayerInit(ply)
end

timer.Simple(5, function()
	apiCall("gmstHello", {}, function(body, len, headers, code)
		MsgN("[GMSTBase] API Ok")
	end)
end)