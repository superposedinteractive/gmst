// GMStation - Camera controls

local scroll = 0
local tauntAngle = Angle(0, 0, 0)

net.Receive("gmstation_taunt", function()
	tauntAngle = LocalPlayer():EyeAngles()
end)

local function thirdperson(ply, pos, ang)
	local view = {}

	if(!LocalPlayer():IsPlayingTaunt()) then
		view.origin = pos - ang:Forward() * scroll
		view.angles = ang
		view.fov = fov
		view.drawviewer = (scroll != 0)
	else
		if(scroll == 0) then
			view.origin = pos - ang:Forward() * 100
		else
			view.origin = pos - ang:Forward() * scroll
		end

		view.angles = ang
		view.fov = fov
		view.drawviewer = true
	end

	local tr = util.TraceLine({
		start = pos,
		endpos = view.origin,
		filter = ply
	})

	if(tr.Hit) then
		view.origin = tr.HitPos + tr.HitNormal
	end

	return view
end

function GM:CalcView(ply, pos, ang, fov)
	return thirdperson(ply, pos, ang)
end

hook.Add("InputMouseApply", "gmstation_zoom", function(cmd, x, y, angle)
	scroll = math.Clamp(scroll - (math.Clamp(math.ceil(cmd:GetMouseWheel()) * 10000, -1, 1) * 5), 0, 100)
	cmd:SetMouseWheel(0)
end)

function GM:CreateMove(cmd)
	if(LocalPlayer():IsPlayingTaunt()) then
		cmd:ClearMovement()
		cmd:ClearButtons()
		// force the player to look at the angles but allow camera movement
		cmd:SetViewAngles(tauntAngle)
	end
end