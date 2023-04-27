local saveableGlobals = {
	["volume"] = 0.5,
	["tabWaves"] = true,
	["tabBlur"] = true,
	["blurStrength"] = 0.5
}

function apiCall(url, args, callback)
	local get = ""
	for k, v in pairs(args) do
		get = get .. k .. "=" .. v .. "&"
	end
	get = string.sub(get, 1, string.len(get) - 1)

	http.Fetch(CL_GLOBALS.url .. "/api/" .. url .. ".php" .. "?" .. get, function(body, len, headers, code)
		if callback then
			callback(body, len, headers, code)
		end
	end, function(error)
		panic("Failed to to talk to the API: " .. error)
	end)
end

net.Receive("gmstation_first_join_done", function()
	local steamid = net.ReadString() -- LocalPlayer():SteamID64() sometimes player isn't ready yet
	apiCall("gmstGetPlayerMoney", {steamid = steamid}, function(body, len, headers, code)
		CL_GLOBALS.money = tonumber(body)
	end)

	SetupHUD()
end)

function saveSettings(write)
	MsgN("[GMST] Applying settings")

	local settings = {}
	for k, v in pairs(saveableGlobals) do
		if CL_GLOBALS[k] != nil then
			settings[k] = CL_GLOBALS[k]
		else
			settings[k] = saveableGlobals[k]
		end
		
		CL_GLOBALS[k] = settings[k]
	end
	
	if CL_GLOBALS.currentSound then
		CL_GLOBALS.currentSound:ChangeVolume(CL_GLOBALS.volume * CL_GLOBALS.ogVolume)
	end

	if write then
		MsgN("[GMST] Saving settings file")
		file.Write("gmstation/settings.json", util.TableToJSON(settings))
	end
end

if(file.Exists("gmstation/settings.json", "DATA")) then
	MsgN("[GMST] Loading settings file")
	local settings = util.JSONToTable(file.Read("gmstation/settings.json", "DATA"))
	if(settings) then
		for k, v in pairs(settings) do
			CL_GLOBALS[k] = v
		end
	else
		panic("Failed to load settings file")
	end
else
	MsgN("[GMST] Creating settings file & setting default values")
	file.CreateDir("gmstation")
	saveSettings()
end