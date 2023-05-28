local hats = {}

function GM:PostPlayerDraw(ply)
	if !IsValid(ply) then return end
	local hat = hats[ply]
	if !IsValid(hat) then return end
	local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
	if !bone then return end
	local pos, ang = ply:GetBonePosition(bone)
	if !pos then return end
	hat:SetPos(pos + ang:Forward() * 2)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	hat:SetAngles(ang)
	hat:SetModelScale(1.2, 0)
	hat:SetupBones()
	hat:DrawModel()
end

net.Receive("gmstation_hatchange", function()
	local ply = net.ReadEntity()
	local hat = net.ReadString()

	if ply != LocalPlayer() then
		ply:EmitSound("replay/rendercomplete.wav", 50, 100, 1, CHAN_AUTO)
	end

	MsgN("[GMSTBase] Updating hat for " .. ply:Nick() .. " to " .. hat)
	local model = GMSTBase_GetItemInfo(hat).model
	if !IsValid(ply) then return end

	if hat == "" then
		if IsValid(hats[ply]) then
			hats[ply]:Remove()
			hats[ply] = nil
		end
	else
		if !IsValid(hats[ply]) then
			hats[ply] = ClientsideModel(model, RENDERGROUP_OPAQUE)
			hats[ply]:SetNoDraw(true)
		else
			hats[ply]:SetModel(model)
		end
	end
end)

function UpdateHats()
	MsgN("[GMSTBase] Updating hats...")
	local model = GMSTBase_GetItemInfo(LocalPlayer():GetNW2String("hat", "")).model
	MsgN("[GMSTBase] Hat model: " .. model)

	for _, ply in pairs(player.GetAll()) do
		local hat = ply:GetNW2String("hat", "")
		if hat == "" then continue end
		local model = GMSTBase_GetItemInfo(hat).model

		if !IsValid(hats[ply]) then
			hats[ply] = ClientsideModel(model, RENDERGROUP_OPAQUE)
			hats[ply]:SetNoDraw(true)
		else
			hats[ply]:SetModel(model)
		end
	end
end
