function apiCall(url, args, callback)
	local get = ""
	for k, v in pairs(args) do
		get = get .. k .. "=" .. v .. "&"
	end
	get = string.sub(get, 1, string.len(get) - 1)

	http.Fetch("http://" .. GLOBALS.url .. "/api/" .. url .. ".php" .. "?" .. get, function(body, len, headers, code)
		if callback then
			callback(body, len, headers, code)
		end
	end, function(error)
		MsgN(error)
	end)
end

net.Receive("gmstation_first_join_done", function()
	apiCall("gmstGetPlayerMoney", {steamid = LocalPlayer():SteamID64()}, function(body, len, headers, code)
		GLOBALS.money = tonumber(body)
	end)

	SetupHUD()
end)