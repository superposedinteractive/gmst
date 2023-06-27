local hats = {}

hatoffsets = {
	css_urban = {
		x = 0.425,
		y = 1.2,
		s = 1.15
	},
	css_gasmask = {
		x = 0.425,
		y = 1,
		s = 1.1
	},
	css_leet = {
		x = 0.425,
		y = 1,
		s = 1.1
	},
	css_phoenix = {
		x = 0.425,
		y = 1,
		s = 1.1
	},
	css_guerilla = {
		x = 0.425,
		y = 1,
		s = 1.1
	},
	css_arctic = {
		x = 0.425,
		y = 1,
		s = 1.1
	},
	css_swat = {
		x = 0.425,
		y = 1,
		s = 1.1
	},
	css_riot = {
		x = 0.425,
		y = 1,
		s = 1.1
	},
	dod_american = {
		x = 0,
		y = 0,
		s = 1
	},
	dod_german = {
		x = 0,
		y = 0,
		s = 1
	},
	alyx = {
		x = 0,
		y = 0,
		s = 1
	},
	kleiner = {
		x = 0,
		y = 0,
		s = 1
	},
	eli = {
		x = 0,
		y = 0,
		s = 1
	},
	mossman = {
		x = 0,
		y = 0,
		s = 1
	},
	odessa = {
		x = 0,
		y = 0,
		s = 1
	},
	breen = {
		x = 0,
		y = 0,
		s = 1
	},
	barney = {
		x = 0,
		y = 0,
		s = 1
	},
	monk = {
		x = 0,
		y = 0,
		s = 1
	},
	skeleton = {
		x = 0,
		y = 0,
		s = 1
	},
	magnusson = {
		x = 0,
		y = -1,
		s = 1
	},
	charple = {
		x = -1,
		y = -2,
		s = 1
	},
	gman = {
		x = 0,
		y = 0,
		s = 1
	},
	corpse = {
		x = 0,
		y = 0,
		s = 1
	},
	stripped = {
		x = 0,
		y = -1.5,
		s = 1
	},
	chell = {
		x = 0,
		y = 0,
		s = 1
	},
	mossmanarctic = {
		x = 0,
		y = 0,
		s = 1
	},
	zombie = {
		x = 0,
		y = 0,
		s = 1
	},
	zombine = {
		x = 0,
		y = -6.8,
		s = 1.3
	},
	zombiefast = {
		x = 0,
		y = -3,
		s = 1
	},
	police = {
		x = 0,
		y = 1.35,
		s = 1
	},
	policefem = {
		x = 0,
		y = 0,
		s = 1
	},
	combine = {
		x = -0.85,
		y = 1.5,
		s = 1
	},
	combineprison = {
		x = -0.85,
		y = 1.5,
		s = 1
	},
	combineelite = {
		x = -0.85,
		y = 2,
		s = 1
	},
	male01 = {
		x = 0,
		y = 0,
		s = 1
	},
	male02 = {
		x = 0,
		y = 0,
		s = 1
	},
	male03 = {
		x = 0,
		y = 0,
		s = 1
	},
	male04 = {
		x = 0,
		y = 0,
		s = 1
	},
	male05 = {
		x = 0,
		y = 0,
		s = 1
	},
	male06 = {
		x = 0,
		y = 0,
		s = 1
	},
	male07 = {
		x = 0,
		y = 0,
		s = 1
	},
	male08 = {
		x = 0,
		y = 0,
		s = 1
	},
	male09 = {
		x = 0,
		y = 0,
		s = 1
	},
	male10 = {
		x = 0,
		y = 0,
		s = 1
	},
	male11 = {
		x = 0,
		y = 0,
		s = 1
	},
	male12 = {
		x = 0,
		y = 0,
		s = 1
	},
	male13 = {
		x = 0,
		y = 0,
		s = 1
	},
	male14 = {
		x = 0,
		y = 0,
		s = 1
	},
	male15 = {
		x = 0,
		y = 0,
		s = 1
	},
	male16 = {
		x = 0,
		y = 0,
		s = 1
	},
	male17 = {
		x = 0,
		y = 0,
		s = 1
	},
	male18 = {
		x = 0,
		y = 0,
		s = 1
	},
	male19 = {
		x = 0,
		y = 0,
		s = 1
	},
	female01 = {
		x = 0,
		y = 0,
		s = 1
	},
	female02 = {
		x = 0,
		y = 0,
		s = 1
	},
	female03 = {
		x = 0,
		y = 0,
		s = 1
	},
	female04 = {
		x = 0,
		y = 0,
		s = 1
	},
	female05 = {
		x = 0,
		y = 0,
		s = 1
	},
	female06 = {
		x = 0,
		y = 0,
		s = 1
	},
	female07 = {
		x = 0,
		y = 0,
		s = 1
	},
	female08 = {
		x = 0,
		y = 0,
		s = 1
	},
	female09 = {
		x = 0,
		y = 0,
		s = 1
	},
	female10 = {
		x = 0,
		y = 0,
		s = 1
	},
	female11 = {
		x = 0,
		y = 0,
		s = 1
	},
	female12 = {
		x = 0,
		y = 0,
		s = 1
	},
	female13 = {
		x = 0,
		y = 0,
		s = 1
	},
	female14 = {
		x = 0,
		y = 0,
		s = 1
	},
	female15 = {
		x = 0,
		y = 0,
		s = 1
	},
	female16 = {
		x = 0,
		y = 0,
		s = 1
	},
	female17 = {
		x = 0,
		y = 0,
		s = 1
	},
	female18 = {
		x = 0,
		y = 0,
		s = 1
	},
	female19 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic01 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic02 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic03 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic04 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic05 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic06 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic07 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic08 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic09 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic11 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic12 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic13 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic14 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic15 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic16 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic17 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic18 = {
		x = 0,
		y = 0,
		s = 1
	},
	medic19 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee01 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee02 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee03 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee04 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee05 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee06 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee07 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee08 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee09 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee11 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee12 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee13 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee14 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee15 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee16 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee17 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee18 = {
		x = 0,
		y = 0,
		s = 1
	},
	refugee19 = {
		x = 0,
		y = 0,
		s = 1
	},
	hostage01 = {
		x = 0,
		y = 0,
		s = 1
	},
	hostage02 = {
		x = 0,
		y = 0,
		s = 1
	},
	hostage03 = {
		x = 0,
		y = 0,
		s = 1
	},
	hostage04 = {
		x = 0,
		y = 0,
		s = 1
	},
}

function GM:PostPlayerDraw(ply)
	local hat = hats[ply]
	if !IsValid(ply) then return end
	if !IsValid(hat) then return end
	local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
	if !bone then return end
	local pos, ang = ply:GetBonePosition(bone)
	if !pos then return end
	local pm = player_manager.TranslateToPlayerModelName(ply:GetModel())
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 180)
	hat:SetModelScale(hatoffsets[pm].s, 0)
	hat:SetPos(pos + ang:Forward() * 0.5 + ang:Up() * 0.5)
	hat:SetPos(hat:GetPos() + ang:Forward() * hatoffsets[pm].x + ang:Up() * hatoffsets[pm].y)
	hat:SetAngles(ang)
	hat:DrawModel()
end

net.Receive("gmstation_hatchange", function()
	local ply = net.ReadEntity()
	local hat = net.ReadString()

	if !IsValid(ply) then return end

	if ply != LocalPlayer() then
		ply:EmitSound("replay/rendercomplete.wav")
	end

	if !IsValid(ply) then return end
	MsgN("[GMSTBase] Updating hat for " .. ply:Nick() .. " to " .. hat)
	local model = GMSTBase_GetItemInfo(hat).model
	local pm = player_manager.TranslateToPlayerModelName(ply:GetModel())

	if hat == "" then
		if IsValid(hats[ply]) then
			hats[ply]:Remove()
			hats[ply] = nil
		end
	else
		if !IsValid(hats[ply]) then
			hats[ply] = ClientsideModel(model, RENDERGROUP_OPAQUE)
		else
			hats[ply]:SetModel(model)
		end

		hats[ply]:SetNoDraw(true)
		hats[ply]:SetModelScale(hatoffsets[pm].s, 0)
		hats[ply]:SetupBones()
	end
end)

function UpdateHats()
	MsgN("[GMSTBase] Updating hats...")

	for _, ply in pairs(player.GetAll()) do
		local hat = ply:GetNW2String("hat", "")
		MsgN("[GMSTBase] Updating hat for " .. ply:Nick() .. " to " .. hat)
		if hat == "" then continue end
		local model = GMSTBase_GetItemInfo(hat).model

		if !IsValid(hats[ply]) then
			hats[ply] = ClientsideModel(model, RENDERGROUP_OPAQUE)
		else
			hats[ply]:SetModel(model)
		end

		hats[ply]:SetNoDraw(true)
		hats[ply]:SetupBones()
	end
end
