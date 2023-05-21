// GMStation - Player manager
util.AddNetworkString("gmstation_chat")
util.AddNetworkString("gmstation_taunt")
util.AddNetworkString("gmstation_reward")
util.AddNetworkString("gmstation_achievement")
util.AddNetworkString("gmstation_update")
util.AddNetworkString("gmstation_deleteAccount")

function PlayerMessage(ply, ...)
	local args = {...}

	net.Start("gmstation_chat")
	net.WriteString("GMStation")
	net.WriteEntity(nil)
	net.WriteTable(args)

	if ply then
		if IsValid(ply) && ply:IsPlayer() then
			net.Send(ply)
		else
			MsgN("[GMSTBase] Invalid player passed to PlayerMessage.")
		end
	else
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

	function ply:GetMoney()
		apiCall("player_info", ply:SteamID64(), function(body) return body["money"] end)
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