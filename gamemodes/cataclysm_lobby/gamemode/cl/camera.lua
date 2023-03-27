// cataclysm - Camera controls

local scroll = 0
local targetscroll = 0

hook.Add("CalcView", "cataclysm", function(ply, pos, ang, fov)
	targetscroll = Lerp(FrameTime() * 10, targetscroll, scroll)

	local view = {}
	view.origin = pos - ang:Forward() * targetscroll
	view.angles = ang
	view.fov = fov
	view.drawviewer = (scroll != 0)
	return view
end)

hook.Add("InputMouseApply", "cataclysm", function(cmd, x, y, angle)
	scroll = math.Clamp(scroll - cmd:GetMouseWheel() * 5, 0, 100)
	cmd:SetMouseWheel(0)
end)