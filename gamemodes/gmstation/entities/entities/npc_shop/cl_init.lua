include("shared.lua")

local test_elements = {
	{
		["name"] = "Bench",
		["desc"] = "A nice bench to sit on.",
		["model"] = "models/props_c17/bench01a.mdl",
		["price"] = 100
	},
	{
		["name"] = "Table",
		["desc"] = "A nice table to put things on.",
		["model"] = "models/props_c17/furnituretable002a.mdl",
		["price"] = 100
	}
}

function ENT:Initialize()
	self:SetModel("models/humans/group01/female_02.mdl")

	self:SetSolid( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_STEP )
end

net.Receive("gmstation_store", function()
	local type = net.ReadString()
	if GUIElements.store then GUIElements.store:Remove() end

	if CL_GLOBALS.currentSound then
		CL_GLOBALS.currentSound:ChangeVolume(0.01, 0.5)
	end

	local music = CreateSound(LocalPlayer(), "gmstation/music/store.mp3")

	timer.Simple(0.5, function()
		music:Stop()
		music:PlayEx(CL_GLOBALS.volume, 100)
	end)

	timer.Create("gmstation_store_music", 60, 0, function()
		music:Stop()
		music:PlayEx(CL_GLOBALS.volume, 100)
	end)

	GUIElements.store = vgui.Create("DFrame")
	GUIElements.store:SetSize(math.min(700, ScrW() - 100), math.min(400, ScrH() - 100))
	GUIElements.store:Center()
	GUIElements.store:SetTitle("Store")
	GUIElements.store:MakePopup()
	GUIElements.store.OnClose = function()
		timer.Remove("gmstation_store_music")
		music:FadeOut(1)
		if CL_GLOBALS.currentSound then
			CL_GLOBALS.currentSound:ChangeVolume(CL_GLOBALS.volume * CL_GLOBALS.ogVolume)
		end
	end

	local store = vgui.Create("DScrollPanel", GUIElements.store)
	store:Dock(FILL)

	for v, k in ipairs(test_elements) do
		local item = vgui.Create("DPanel", store)
		item:Dock(TOP)
		item:DockMargin(0, 0, 0, 5)
		item:SetTall(128)
		item.Paint = function(self, w ,h)
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100))
		end

		local model = vgui.Create("DModelPanel", item)
		model:Dock(LEFT)
		model:SetWide(128)
		model:SetModel(k.model)
		model:SetCamPos(Vector(100, 100, 50))
		model:SetLookAt(Vector(0, 0, 0))
		model:SetFOV(40)
		model:SetAnimSpeed(20)

		local buy = vgui.Create("DButton", item)
		buy:Dock(RIGHT)
		buy:DockMargin(32, 32, 32, 32)
		buy:SetWide(128)
		buy:SetText(k.price .. "cc")

		local name = vgui.Create("DLabel", item)
		name:Dock(TOP)
		name:DockMargin(16, 16, 0, 0)
		name:SetText(k.name)
		name:SetFont("Trebuchet32")
		name:SetTall(32)

		local desc = vgui.Create("DLabel", item)
		desc:Dock(TOP)
		desc:DockMargin(16, 2, 0, 0)
		desc:SetFont("Trebuchet8")
		desc:SetText(k.desc)
	end
end)