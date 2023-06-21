util.AddNetworkString("rocketeers_damage")
util.AddNetworkString("rocketeers_death")

hook.Add("PlayerSpawn", "rocketeers_spawn", function(ply)
	if !IsGamein_progress() then
		ply:SetTeam(1)
	end

	ply:StripWeapons()
	ply:StripAmmo()
	ply:Give("weapon_rpg")
	ply:SetAmmo(3, "RPG_Round")
	ply:SetHealth(200)
end)

function GM:PlayerCanPickupWeapon(ply, wep)
	if !ply:HasWeapon("weapon_rpg") then return true end

	if wep:GetClass() == "weapon_rpg" && ply:GetAmmoCount("RPG_Round") < 5 then
		ply:GiveAmmo(1, "RPG_Round")
		wep:Remove()
	end

	return false
end

function GM:OnDamagedByExplosion(ply, dmginfo)
	dmginfo:ScaleDamage(0)

	return false
end

function GM:EntityTakeDamage(ent, dmginfo)
	if ent:IsPlayer() && dmginfo:IsExplosionDamage() then
		local dmgforce = dmginfo:GetDamageForce()
		local newforce = dmgforce
		dmginfo:SetDamageForce(newforce)
		dmginfo:ScaleDamage(0.1)

		if ent:KeyDown(IN_DUCK) then
			ent:SetVelocity(newforce / 35)
		else
			ent:SetVelocity(newforce / 70)
		end
	end

	net.Start("rocketeers_damage")
	net.WriteFloat(dmginfo:GetDamage())
	net.WriteEntity(dmginfo:GetAttacker())
	net.WriteEntity(ent)

	net.Send({dmginfo:GetAttacker(), ent})
end

function GM:PlayerDeath(ply, inflictor, attacker)
	wep = ents.Create("weapon_rpg")
	wep:Spawn()
	wep:SetPos(ply:GetPos() + Vector(0, 0, 10))
	wep:SetVelocity(VectorRand() * 100)
	net.Start("rocketeers_death")
	net.WriteEntity(attacker)
	net.Send(ply)

	timer.Simple(5, function()
		ply:Spawn()
	end)
end

function GM:PlayerDeathThink(ply)
	return false
end

function GM:PlayerDeathSound()
	return false
end

timer.Stop("gmstation_globalheal")
