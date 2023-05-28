// GMStation - Player manager
util.AddNetworkString("gmstation_chat")
util.AddNetworkString("gmstation_taunt")
util.AddNetworkString("gmstation_reward")
util.AddNetworkString("gmstation_achievement")
util.AddNetworkString("gmstation_update")
util.AddNetworkString("gmstation_deleteAccount")
util.AddNetworkString("gmstation_hatchange")
util.AddNetworkString("gmstation_pmchange")

function PlayerMessage(ply, ...)
	local args = {...}

	net.Start("gmstation_chat")
	net.WriteString("GMStation")
	net.WriteEntity(nil)
	net.WriteTable(args)

	if ply then
		if IsValid(ply) && ply:IsPlayer() then
			MsgN("[GMSTBase] Telling " .. ply:Nick() .. " \"" .. args[1] .. "\".")
			net.Send(ply)
		else
			MsgN("[GMSTBase] Invalid player passed to PlayerMessage.")
		end
	else
		MsgN("[GMSTBase] Broadcasting " .. args[1] .. ".")
		net.Broadcast()
	end
end

function GM:PlayerSpawn(ply)
	ply:SetModel(player_manager.TranslatePlayerModel(ply:GetInfo("cl_playermodel")))
	ply:SetPlayerColor(Vector(ply:GetInfo("cl_playercolor")))
	ply:SetupHands()
	ply:UnSpectate()
	ply:CrosshairEnable()
	ply:SetCrouchedWalkSpeed(0.3)
	ply:AllowFlashlight(true)
end

function PlayerInit(ply)
	MsgN("[GMSTBase] " .. ply:Nick() .. " joined.")
	PlayerMessage(nil, ply:Nick() .. " has entered the station.")

	function ply:UpdateInfo()
		MsgN("[GMSTBase] Updating " .. ply:Nick() .. " info.")

		apiCall("player_info", {
			steamid = ply:SteamID64()
		}, function(body)
			for k, v in pairs(body) do
				MsgN("[GMSTBase] " .. ply:Nick() .. " " .. k .. " = " .. v)
				ply:SetNW2String(k, v)
			end

			MsgN("[GMSTBase] Sending " .. ply:Nick() .. " hat info.")
			net.Start("gmstation_hatchange")
			net.WriteEntity(ply)
			net.WriteString(ply:GetNW2String("hat", ""))
			net.Broadcast()
			MsgN("[GMSTBase] Updated " .. ply:Nick() .. " info.")
		end)
	end

	function ply:GetMoney()
		return ply.money
	end

	function ply:CanAfford(amount)
		return ply:GetMoney() >= amount
	end

	function ply:Payout(rewards)
		local sum = 0

		for i = 1, #rewards do
			sum = sum + rewards[i][2]
		end

		net.Start("gmstation_reward")
		net.WriteTable(rewards)
		net.Send(ply)
		ply:MoneyAdd(sum)
	end

	function ply:MoneyAdd(amount)
		apiCall("player_addmoney", {
			["steamid"] = ply:SteamID64(),
			["amount"] = amount,
			["password"] = SV_GLOBALS.password
		}, function(body)
			MsgN("[GMSTBase] " .. ply:Nick() .. " has been given " .. amount .. " cc.")
			net.Start("gmstation_update")
			net.Send(ply)
		end)
	end

	function ply:Achievement(name, desc, image, reward)
		net.Start("gmstation_achievement")
		net.WriteString(name)
		net.WriteString(desc)
		net.WriteString(image)
		net.WriteInt(100, 21)
		net.WriteEntity(ply)
		net.Broadcast()
		ply:MoneyAdd(reward)
	end

	function ply:FetchInfo()
		local info = {}

		for k, v in pairs(ply) do
			if type(v) != "function" then
				info[k] = v
			end
		end
	end

	timer.Simple(1, function()
		ply:UpdateInfo()
	end)
end

function GM:GetFallDamage()
	return 0
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if wep:GetClass() == "weapon_physgun" then return true end

	return false
end

function GM:PlayerStartTaunt(ply, actid, len)
	ply:CrosshairDisable()
	net.Start("gmstation_taunt")
	net.WriteInt(len, 32)
	net.Send(ply)

	timer.Simple(len, function()
		if IsValid(ply) then
			ply:CrosshairEnable()
		end
	end)
end

function GM:PlayerConnect(name)
	MsgN("[GMSTBase] " .. name .. " is joining.")
end

function GM:PlayerDisconnected(ply)
	PlayerMessage(nil, ply:Nick() .. " has left the station.")
	MsgN("[GMSTBase] " .. ply:Nick() .. " left.")
	apiCall("player_leave", {
		["steamid"] = ply:SteamID64(),
		["password"] = SV_GLOBALS.password
	}, function(body)
		MsgN("[GMSTBase] Updated last seen.")
	end)
end

function GM:PlayerAuthed(ply, steamid, uniqueid)
	if ply:SteamID64() != ply:OwnerSteamID64() then
		MsgN("[GMSTBase] " .. ply:Nick() .. " doesn't own Garry's Mod.")
		ply:Kick("Sorry, but you need to own Garry's Mod to play on this server. Using a family shared copy is not allowed.")

		return
	end
end

net.Receive("gmstation_deleteAccount", function(len, ply)
	MsgN("[GMSTBase] " .. ply:Nick() .. " is deleting their account.")

	apiCall("player_delete", {
		["steamid"] = ply:SteamID64(),
		["password"] = SV_GLOBALS.password
	}, function(body)
		MsgN("[GMSTBase] " .. ply:Nick() .. " has deleted their account.")
		ply:Kick("Farewell!\nThank you for being a part of our journey. We'll miss you and your unique contributions. Wishing you all the best in your future endeavors!\n- GMStation Team")
	end)
end)

net.Receive("gmstation_hatchange", function(len, ply)
	local hat = net.ReadString()
	if hat == ply:GetNW2String("hat", "") then return end

	if hat == "" then
		hat = "none"
	end

	apiCall("player_drip", {
		["steamid"] = ply:SteamID64(),
		["type"] = "hat",
		["to"] = hat,
		["password"] = SV_GLOBALS.password
	}, function(body)
		if body["success"] then
			MsgN("[GMSTBase] " .. ply:Nick() .. " changed their hat to " .. hat .. ".")

			if hat == "none" then
				hat = ""
			end

			ply:SetNW2String("hat", hat)
			net.Start("gmstation_hatchange")
			net.WriteEntity(ply)
			net.WriteString(hat)
			net.Broadcast()
		else
			MsgN("[GMSTBase] " .. ply:Nick() .. " failed to change their hat to " .. hat .. ".")
		end
	end)
end)


net.Receive("gmstation_pmchange", function(len, ply)
	local model = net.ReadString()

	ply:SetModel(model)
	ply:SetupHands()	
end)