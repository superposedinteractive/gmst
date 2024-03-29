﻿local saveableGlobals = {
	["volume"] = 0.5,
	["tabWaves"] = true,
	["tabBlur"] = true,
	["blurStrength"] = 0.05
}

function apiCall(url, args, callback)
	local get = ""

	if args then
		for k, v in pairs(args) do
			get = get .. k .. "=" .. v .. "&"
		end
	end

	get = string.sub(get, 1, string.len(get) - 1)

	http.Fetch(CL_GLOBALS.url .. "/api/" .. url .. ".php" .. "?" .. get, function(body, len, headers, code)
		body = util.JSONToTable(body)

		if code != 200 || !body || body["error"] != nil then
			panic("API error: " .. url .. "?" .. get .. "\nResponse: " .. code .. "\n" .. tostring(body))

			return
		end

		if callback then
			callback(body, len, headers, code)
		end
	end, function(error)
		panic("Failed to to talk to the API: " .. error)
	end)
end

GMSTBase_RetreiveItems()

function saveSettings(write)
	MsgN("[GMSTBase] Applying settings")
	local settings = {}

	for k, v in pairs(saveableGlobals) do
		if CL_GLOBALS[k] != nil then
			settings[k] = CL_GLOBALS[k]
		else
			settings[k] = saveableGlobals[k]
		end

		CL_GLOBALS[k] = settings[k]
	end

	// funny CSoundPatch quirk
	CL_GLOBALS.volume = math.max(CL_GLOBALS.volume, 0.01)

	if CL_GLOBALS.currentSound && CL_GLOBALS.currentSound:IsPlaying() then
		CL_GLOBALS.currentSound:ChangeVolume(CL_GLOBALS.volume * (CL_GLOBALS.ogVolume || 1))
	end

	if write then
		MsgN("[GMSTBase] Saving settings file")
		file.Write("gmstation/settings.json", util.TableToJSON(settings))
	end
end

if file.Exists("gmstation/settings.json", "DATA") then
	MsgN("[GMSTBase] Loading settings file")
	local settings = util.JSONToTable(file.Read("gmstation/settings.json", "DATA"))

	if settings then
		for k, v in pairs(settings) do
			CL_GLOBALS[k] = v
		end
	else
		panic("Failed to load settings file")
	end
else
	MsgN("[GMSTBase] Creating settings file & setting default values")
	file.CreateDir("gmstation")
	saveSettings()
end

function FetchInfo()
	MsgN("[GMSTBase] Fetching info...")
	local oldMoney = CL_GLOBALS.money || 0

	apiCall("player_info", {
		steamid = CL_GLOBALS.steamid || LocalPlayer():SteamID64()
	}, function(body, len, headers, code)
		MsgN("[GMST] Info received, updated global variables")
		CL_GLOBALS.money = body["money"] || "ERROR"
		CL_GLOBALS.inventory = body["inventory"] || {}
		CL_GLOBALS.hat = body["hat"] || "ERROR"

		if oldMoney != 0 && oldMoney != CL_GLOBALS.money then
			if oldMoney > CL_GLOBALS.money then
				surface.PlaySound("/mvm/mvm_bought_upgrade.wav")
				GMSTBase_Notification("GMSTBank", "You lost " .. string.Comma(oldMoney - CL_GLOBALS.money) .. "cc.")
			else
				surface.PlaySound("/mvm/mvm_money_pickup.wav")
				GMSTBase_Notification("GMSTBank", "You got " .. string.Comma(CL_GLOBALS.money - oldMoney) .. "cc.")
			end
		end

		UpdateHats()
	end)
end