util.AddNetworkString("rocketeers_damage")

hook.Add("PlayerSpawn", "rocketeers_spawn", function(ply)
	timer.Simple(0.1, function()
		ply:StripWeapons()
		ply:Give("weapon_rpg")
		ply:SetAmmo(3, "RPG_Round")
	end)
end)

function GM:PlayerCanPickupWeapon(ply, wep)
	if !ply:HasWeapon("weapon_rpg") then
		return true
	end

	if wep:GetClass() == "weapon_rpg" then
		if ply:GetAmmoCount("RPG_Round") < 5 then
			ply:GiveAmmo(1, "RPG_Round")
			wep:Remove()
		end
	end

	return false
end

function GM:OnDamagedByExplosion(ply, dmginfo)
	dmginfo:ScaleDamage(0)

	return false
end

function GM:EntityTakeDamage(ent, dmginfo)
	if ent:IsPlayer() and dmginfo:IsExplosionDamage() then

		local dmgforce = dmginfo:GetDamageForce()
		local newforce = dmgforce

		dmginfo:SetDamageForce(newforce)
		dmginfo:ScaleDamage(0.05)

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

	timer.Simple(3, function()
		ply:Spawn()
	end)
end

function GM:PlayerDeathThink(ply)
	return false
end

timer.Stop("gmstation_globalheal")