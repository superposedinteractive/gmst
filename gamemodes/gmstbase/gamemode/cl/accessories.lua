local hats = {}
local hatids = {}

function GM:PostPlayerDraw(ply)
	if (!IsValid(ply)) then return end

	local hat = hats[ply]
	if (!IsValid(hat)) then return end

	local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
	if (!bone) then return end

	local pos, ang = ply:GetBonePosition(bone)
	if (!pos) then return end

	hat:SetPos(pos + ang:Forward() * 2)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	hat:SetAngles(ang)
	hat:SetModelScale(1.1, 0)
	hat:SetupBones()
	hat:DrawModel()
end

timer.Create("GMSTBase_GetHats", 3, 0, function()
	for k, v in pairs(player.GetAll()) do
		if (!IsValid(v)) then continue end
		if (v:GetNW2String("hat") == "") then continue end

		if(v:GetNW2String("hat") != hatids[v]) then
			MsgN("[GMSTBase] Updating hat for " .. v:Nick())
			if(IsValid(hats[v])) then
				hats[v]:Remove()
			end

			hatids[v] = v:GetNW2String("hat")
			hats[v] = ClientsideModel(GMSTBase_GetItemInfo(v:GetNW2String("hat"))["model"] || "error", RENDERGROUP_OPAQUE)
			hats[v]:SetNoDraw(true)
		end
	end
end)