include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/humans/group01/female_02.mdl")

	self:SetSolid( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_STEP )
end

net.Receive("gmstation_store", function()
	local type = net.ReadString()
	if GUIElements.store then GUIElements.store:Remove() end

	if GLOBALS.currentSound then
		GLOBALS.currentSound:ChangeVolume(0.01, 0.5)
	end

	local music = CreateSound(LocalPlayer(), "gmstation/music/store.mp3")

	timer.Simple(0.5, function()
		music:PlayEx(GLOBALS.volume, 100)
	end)

	timer.Create("gmstation_store_music", 60, 0, function()
		music:Stop()
		music:Play()
	end)

	GUIElements.store = vgui.Create("DFrame")
	GUIElements.store:SetSize(1000, 600)
	GUIElements.store:Center()
	GUIElements.store:SetTitle("Store")
	GUIElements.store:MakePopup()
	GUIElements.store.OnClose = function()
		if GLOBALS.currentSound then
			timer.Remove("gmstation_store_music")
			music:FadeOut(1)
			GLOBALS.currentSound:ChangeVolume(GLOBALS.volume * GLOBALS.ogVolume)
		end
	end

	local store = vgui.Create("DScrollPanel", GUIElements.store)
	store:Dock(FILL)
end)