// GMStation - Player manager
util.AddNetworkString("gmstation_chat")

function GM:PlayerSpawn(ply)
	ply:SetModel(ply:GetInfo("cl_playermodel"))
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

	timer.Simple(len, function()
		if(IsValid(ply)) then
			ply:CrosshairEnable()
			
		end
	end)
end

function GM:PlayerSay(ply, text, team)
	net.Start("gmstation_chat")
		net.WriteString(ply:GetNWString("zone") or "Somewhere")
		net.WriteVector(ply:GetPlayerColor())
		net.WriteString(ply:Nick())
		net.WriteString(text)
	net.Broadcast()

	return ""
end