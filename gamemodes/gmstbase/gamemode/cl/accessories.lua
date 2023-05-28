local hats = {}
hatoffsets = {
	css_urban = {x = 1, y = 1, s = 1.2},
	alyx = {x = -0.25, y = -1.25, s = 1},
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

	hat:SetModelScale(hatoffsets[pm].s, 0)
	hat:SetPos(pos + ang:Forward() * 0.5 + ang:Up() * 0.5)
	hat:SetPos(hat:GetPos() + ang:Forward() * -hatoffsets[pm].x + ang:Up() * hatoffsets[pm].y)
	hat:SetAngles(ang)

	hat:DrawModel()
end

net.Receive("gmstation_hatchange", function()
	local ply = net.ReadEntity()
	local hat = net.ReadString()

	if ply != LocalPlayer() then
		ply:EmitSound("replay/rendercomplete.wav", 50, 100, 1, CHAN_AUTO)
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
		if hat == "" then continue end
		local model = GMSTBase_GetItemInfo(hat).model
		local pm = player_manager.TranslateToPlayerModelName(ply:GetModel())

		if !IsValid(hats[ply]) then
			hats[ply] = ClientsideModel(model, RENDERGROUP_OPAQUE)
		else
			hats[ply]:SetModel(model)
		end
		hats[ply]:SetNoDraw(true)
		hats[ply]:SetupBones()
	end
end