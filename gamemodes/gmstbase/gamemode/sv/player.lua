// GMStation - Player manager
util.AddNetworkString("gmstation_chat")
util.AddNetworkString("gmstation_taunt")
util.AddNetworkString("gmstation_reward")

function PlayerMessage(ply, ...)
	local args = {...}

	net.Start("gmstation_chat")
		net.WriteString("GMStation")
		net.WriteEntity(nil)
		net.WriteTable(args)
	if(ply) then
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
		apiCall("gmstGetPlayerMoney", ply:SteamID64(), function(body)
			if !string.StartsWith(body, "-") then
				return tonumber(body)
			else
				return 0
			end
		end)
	end

	function ply:Payout(rewards)
		local sum = 0
		for i = 1, #rewards do
			sum = sum + rewards[i][2]
		end

		MsgN("[GMSTBase] " .. ply:Nick() .. " has been paid " .. sum .. " credits in " .. #rewards .. " rewards.")

		net.Start("gmstation_reward")
			net.WriteTable(rewards)
		net.Send(ply)
	end
end

function GM:GetFallDamage()
	return 0
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if wep:GetClass() == "weapon_physgun" then
		return true
	end
	return false
end

timer.Create("gmstation_globalheal", 0.25, 0, function()
	for k, v in pairs(player.GetAll()) do
		if(v:Health() < v:GetMaxHealth() && v:Alive()) then
			v:SetHealth(v:Health() + 1)
		end
	end
end)

function GM:PlayerStartTaunt(ply, actid, len)
	ply:CrosshairDisable()

	net.Start("gmstation_taunt")
		net.WriteInt(len, 32)
	net.Send(ply)

	timer.Simple(len, function()
		if(IsValid(ply)) then
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