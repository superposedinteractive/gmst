// GMStation - Player manager
util.AddNetworkString("gmstation_chat")
util.AddNetworkString("gmstation_taunt")

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
			MsgN("[GMST] Invalid player passed to PlayerMessage.")
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
	function ply:GetMoney()
		apiCall("gmstGetPlayerMoney", ply:SteamID64(), function(body)

		end)
	end
end

function GM:GetFallDamage()
	return 0
end

function GM:PlayerCanPickupWeapon()
	return true
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

	gmstRestartMap(5)
end

function GM:PlayerConnect(name, ip)
	PlayerMessage(nil, name .. " has entered the station.")
	MsgN("[GMST] " .. name .. " joined.")
end

function GM:PlayerDisconnected(ply)
	PlayerMessage(nil, ply:Nick() .. " has left the station.")
	MsgN("[GMST] " .. ply:Nick() .. " left.")
end

function GM:PlayerSay(ply, text, team)
	if(string.sub(text, 1, 1) == "!") then
		PlayerMessage(ply, "Used a command, not a chat message.")
		return ""
	end

	if text == "insptt" then
		ply:KillSilent()
		ply:Spawn()
		hook.Run("PlayerInitialSpawn", ply)
		return ""
	end
	
	net.Start("gmstation_chat")
		net.WriteString(ply:GetNWString("zone") or "Somewhere")
		net.WriteEntity(ply)
		net.WriteString(text)
	net.Broadcast()

	return ""
end