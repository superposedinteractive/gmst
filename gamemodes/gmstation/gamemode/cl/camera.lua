// GMStation - Camera controls

local scroll = 0
local realscroll = 0
local tauntAngle = Angle(0, 0, 0)

net.Receive("gmstation_taunt", function()
	tauntAngle = LocalPlayer():EyeAngles()
end)

local function thirdperson(ply, pos, ang, fov)
	scroll = Lerp(0.1, scroll, realscroll)

	local view = {}

	if(LocalPlayer():Alive()) then
		if(!LocalPlayer():IsPlayingTaunt()) then
			if(scroll < 7) then
				view.origin = pos - ang:Forward() * scroll
			else
				view.origin = pos - ang:Forward() * scroll + ang:Right() * 10 * (scroll/100)
			end

			view.angles = ang
			view.drawviewer = (scroll > 7)
		else
			if(scroll < 7) then
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
			view.origin = tr.HitPos
		end
	end

	return view
end

function GM:CalcView(ply, pos, ang, fov)
	return thirdperson(ply, pos, ang, fov)
end

hook.Add("InputMouseApply", "gmstation_zoom", function(cmd, x, y, angle)
	if (!input.IsMouseDown(MOUSE_LEFT)) then
		realscroll = math.Clamp(realscroll - (math.Clamp(math.ceil(cmd:GetMouseWheel()) * 10000, -1, 1) * 5), 0, 100)
		cmd:SetMouseWheel(0)
	end
end)

function GM:CreateMove(cmd)
	if(LocalPlayer():IsPlayingTaunt()) then
		cmd:ClearMovement()
		cmd:ClearButtons()
		// force the player to look at the angles but allow camera movement
		cmd:SetViewAngles(tauntAngle)
	end
end