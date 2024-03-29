﻿// GMStation - Lobby Player
timer.Create("gmstation_globalheal", 0.05, 0, function()
	for k, v in pairs(player.GetAll()) do
		if v:Health() < v:GetMaxHealth() && v:Alive() then
			v:SetHealth(v:Health() + 1)
		end
	end
end)

hook.Add("gmstation_chat_bad_word", "gmstbadword", function(ply, msg)
	MsgN("[GMST] Vaporising " .. ply:Nick() .. " for saying " .. msg)

	if ply:Alive() then
		local e = EffectData()
		e:SetOrigin(ply:GetPos())
		e:SetRadius(200)
		e:SetNormal(Vector(0, 0, 1))
		util.Effect("AR2Explosion", e)
		ply:SetGravity(1)
		local d = DamageInfo()
		d:SetDamage(100000)
		d:SetDamageType(DMG_DISSOLVE)
		d:SetDamageForce(Vector(0, 0, -10000000))
		d:SetAttacker(ply)
		d:SetInflictor(ply)
		ply:EmitSound("npc/scanner/cbot_energyexplosion1.wav")
		ply:TakeDamageInfo(d)
	end
end)

hook.Add("PlayerInitialSpawn", "gmstdosh", function(ply)
	timer.Create("gmstation_dosh_" .. ply:SteamID(), 60 * 5, 0, function()
		PlayerMessage(ply, "Thanks for staying around!")
		ply:MoneyAdd(100)
	end)
end)

hook.Add("PlayerDisconnected", "gmstdosh", function(ply)
	timer.Remove("gmstation_dosh_" .. ply:SteamID())
end)
