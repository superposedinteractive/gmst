// GMStation - Player manager
util.AddNetworkString("gmstation_chat")
util.AddNetworkString("gmstation_taunt")

function PlayerMessage(ply, msg)
	net.Start("gmstation_chat")
		net.WriteString("GMStation")
		net.WriteEntity(nil)
		net.WriteString(msg)
	net.Broadcast()
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

function GM:GetFallDamage()
	return 0
end

function GM:PlayerCanPickupWeapon()
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