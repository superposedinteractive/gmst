local saveableGlobals = {
	"volume"
}

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
	local steamid = net.ReadString() -- LocalPlayer():SteamID64() sometimes player isn't ready yet
	apiCall("gmstGetPlayerMoney", {steamid = steamid}, function(body, len, headers, code)
		GLOBALS.money = tonumber(body)
	end)

	SetupHUD()
end)

function saveSettings()
	MsgN("[GMST] Saving & Applying settings file")
	local settings = {}
	for k,v in ipairs(saveableGlobals) do
		settings[v] = GLOBALS[v]
	end
	
	file.Write("gmstation/settings.json", util.TableToJSON(settings))

	if GLOBALS.currentSound then
		GLOBALS.currentSound:ChangeVolume(GLOBALS.volume)
	end
end

if(file.Exists("gmstation/settings.json", "DATA")) then
	MsgN("[GMST] Loading settings file")
	local settings = util.JSONToTable(file.Read("gmstation/settings.json", "DATA"))
	if(settings) then
		GLOBALS.volume = settings.volume
	end
else
	MsgN("[GMST] Creating settings file")
	file.CreateDir("gmstation")
	saveSettings()
end