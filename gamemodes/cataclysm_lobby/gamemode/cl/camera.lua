// cataclysm - Camera controls

local scroll = 0

hook.Add("CalcView", "cataclysm", function(ply, pos, ang, fov)
	local view = {}

	if(!LocalPlayer():IsPlayingTaunt()) then
		view.origin = pos - ang:Forward() * scroll
		view.angles = ang
		view.fov = fov
		view.drawviewer = (scroll != 0)
	end

	return view
end)

hook.Add("InputMouseApply", "cataclysm", function(cmd, x, y, angle)
	scroll = math.Clamp(scroll - (math.Clamp(math.ceil(cmd:GetMouseWheel()) * 10000, -1, 1) * 5), 0, 100)
	cmd:SetMouseWheel(0)
end)

function PLAYER:ShouldDrawLocal