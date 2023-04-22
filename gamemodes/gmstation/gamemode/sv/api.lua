util.AddNetworkString("gmstation_first_join")
util.AddNetworkString("gmstation_first_join_done")

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
	end)
end

function GM:PlayerInitialSpawn(ply)
	apiCall("gmstPlayerExists", {steamid = ply:SteamID64()}, function(body, len, headers, code)
		if body != "0" then
			MsgN("[GMST] Player " .. ply:Name() .. " is not registered, registering...")
			net.Start("gmstation_first_join")
			net.Send(ply)

			ply:Freeze(true)

			timer.Simple(2, function()
				apiCall("gmstRegisterPlayer", {steamid = ply:SteamID64(), password = GLOBALS.password}, function(body, len, headers, code)
					if body == "0" then
						MsgN("[GMST] Registered " .. ply:Name())
						net.Start("gmstation_first_join_done")
						net.Send(ply)
						ply:Freeze(false)
					end
				end)
			end)
		else
			net.Start("gmstation_first_join_done")
			net.Send(ply)
		end
	end)

end