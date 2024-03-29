﻿local gradient_h = Material("gmstation/ui/gradients/hoz.png", "smooth")
local gradient_v = Material("gmstation/ui/gradients/vert.png", "smooth")
local gradient_c = Material("gmstation/ui/gradients/center.png", "smooth")
local cur_ammo = 3

surface.CreateFont("countdown1", {
	font = "Trebuchet MS",
	size = 64,
	weight = 1000,
	antialias = true
})

surface.CreateFont("countdown2", {
	font = "Trebuchet MS",
	size = 128,
	weight = 1000,
	antialias = true
})

surface.CreateFont("countdown3", {
	font = "Trebuchet MS",
	size = 256,
	weight = 1000,
	antialias = true
})

function GM:CreateMove(uc)
	if uc:KeyDown(IN_JUMP) && LocalPlayer():WaterLevel() < 2 && LocalPlayer():GetMoveType() == MOVETYPE_WALK then
		if LocalPlayer():IsOnGround() then
			uc:SetButtons(bit.bor(uc:GetButtons(), IN_JUMP))
		else
			uc:SetButtons(bit.band(uc:GetButtons(), bit.bnot(IN_JUMP)))
		end
	end
end

function rk_notice(text)
	surface.PlaySound("buttons/blip2.wav")
	local notice = vgui.Create("DPanel")
	notice:SetSize(ScrW(), 64)
	local y = ScrH() / 1.5 - notice:GetTall() / 2
	notice:SetPos(ScrW(), y)

	notice.Paint = function(self, w, h)
		surface.SetMaterial(gradient_c)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawTexturedRect(0, 0, w, h)
		draw.SimpleText(text, "Trebuchet32", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	notice:MoveTo(ScrW() / 2 - notice:GetWide() / 2, y, 0.5, 0, 0.25, function()
		timer.Simple(1, function()
			notice:MoveTo(-ScrW(), y, 0.5, 0, 10.25, function()
				notice:Remove()
			end)
		end)
	end)
end

GUIElements.HUD = vgui.Create("DPanel")
GUIElements.HUD:SetSize(300, 100)
GUIElements.HUD:SetPos(0, ScrH() - GUIElements.HUD:GetTall() - 32)

GUIElements.HUD.Paint = function(self, w, h)
	surface.SetMaterial(gradient_h)
	surface.SetDrawColor(0, 0, 0)
	surface.DrawTexturedRect(0, 0, w, h)
	local ammo = string.rep("I", cur_ammo)

	if cur_ammo == 0 then
		ammo = "EMPTY"
	end

	local hp = "Alive"

	if IsValid(LocalPlayer()) then
		hp = LocalPlayer():Health()
	end

	draw.SimpleText(hp, "Trebuchet32", 16, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(ammo, "Trebuchet24", 16, h - 8, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
end

GUIElements.timer = vgui.Create("DPanel")
GUIElements.timer:SetSize(300, 64)
GUIElements.timer:CenterHorizontal()

GUIElements.timer.Paint = function(self, w, h)
	local time = timer.TimeLeft("rocketeers_timer")

	surface.SetMaterial(gradient_v)
	surface.SetDrawColor(0, 0, 0)
	surface.DrawTexturedRect(0, 0, w, h)
	draw.SimpleText(string.FormattedTime(time, "%02i:%02i"), "Trebuchet32Bold", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function GM:PlayerAmmoChanged(ply, ammo, oldcount, newcount)
	if ammo != game.GetAmmoID("RPG_Round") then return end
	cur_ammo = newcount

	if newcount > oldcount && ammo == game.GetAmmoID("RPG_Round") then
		local hudglow = vgui.Create("DPanel")
		hudglow:SetSize(600, 24)
		hudglow:SetPos(0, ScrH() - GUIElements.HUD:GetTall() + 36)

		hudglow.Paint = function(self, w, h)
			surface.SetMaterial(gradient_h)
			surface.SetDrawColor(0, 255, 0)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		hudglow:AlphaTo(0, 1, 0, function()
			hudglow:Remove()
		end)
	end

	if newcount == 0 && LocalPlayer():Alive() then
		surface.PlaySound("buttons/button10.wav")
		local hudglow = vgui.Create("DPanel")
		hudglow:SetSize(600, 24)
		hudglow:SetPos(0, ScrH() - GUIElements.HUD:GetTall() + 36)

		hudglow.Paint = function(self, w, h)
			surface.SetMaterial(gradient_h)
			surface.SetDrawColor(255, 0, 0)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		hudglow:AlphaTo(0, 1, 0, function()
			hudglow:Remove()
		end)
	end

	if newcount == 1 then
		surface.PlaySound("common/warning.wav")
		local hudglow = vgui.Create("DPanel")
		hudglow:SetSize(600, 24)
		hudglow:SetPos(0, ScrH() - GUIElements.HUD:GetTall() + 36)

		hudglow.Paint = function(self, w, h)
			surface.SetMaterial(gradient_h)
			surface.SetDrawColor(255, 150, 0)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		hudglow:AlphaTo(0, 1, 0, function()
			hudglow:Remove()
		end)
	end
end

net.Receive("rocketeers_damage", function()
	local dmg = net.ReadFloat()
	local attacker = net.ReadEntity()
	local victim = net.ReadEntity()
	dmg = math.Round(dmg)
	if !IsValid(victim) || !victim:IsPlayer() then return false end
	if !victim:Alive() then return false end

	if victim == LocalPlayer() then
		local go = 0
		local hudglow = vgui.Create("DPanel")
		hudglow:SetSize(600, 32)
		hudglow:SetPos(0, ScrH() - GUIElements.HUD:GetTall() - 14)

		hudglow.Paint = function(self, w, h)
			go = go + RealFrameTime() * 100
			surface.SetMaterial(gradient_h)
			surface.SetDrawColor(255, 0, 0)
			surface.DrawTexturedRect(0, 0, w, h)
			draw.SimpleText("-" .. dmg, "Trebuchet32Bold", 64 + go, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		hudglow:AlphaTo(0, 1, 0, function()
			hudglow:Remove()
		end)
	else
		surface.PlaySound("rocketeers/hitsound.wav")

		if victim:Health() - dmg <= 0 then
			surface.PlaySound("rocketeers/killsound.wav")
		end

		local hitnumber = vgui.Create("DPanel")
		hitnumber:SetSize(128, 32)
		hitnumber:SetPos(victim:GetPos():ToScreen().x - 64, victim:GetPos():ToScreen().y - 64)

		hitnumber.Paint = function(self, w, h)
			draw.SimpleText(dmg, "Trebuchet16", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		hitnumber:AlphaTo(0, 1, 0, function()
			hitnumber:Remove()
		end)

		hitnumber:MoveTo(hitnumber:GetX(), hitnumber:GetY() - 64, 0.5, 0, 0.5, function()
			hitnumber:MoveTo(hitnumber:GetX(), hitnumber:GetY() + 32, 0.5, 0, 1.5)
		end)
	end
end)

net.Receive("rocketeers_death", function()
	surface.PlaySound("rocketeers/death.ogg")
	local attacker = net.ReadEntity()
	local nick

	if IsValid(attacker) && attacker:IsPlayer() then
		nick = attacker:Nick() .. "!"
	else
		nick = "something..."
	end

	if GUIElements.death then
		GUIElements.death:Remove()
	end

	timer.Create("rocketeers_respawn", 5, 1, function()
		GUIElements.death:AlphaTo(0, 1, 0, function()
			GUIElements.death:Remove()
		end)
	end)

	GUIElements.death = vgui.Create("DPanel")
	GUIElements.death:SetSize(ScrW(), ScrH())

	GUIElements.death.Paint = function(self, w, h)
		local time = timer.TimeLeft("rocketeers_respawn") || 0
		surface.SetMaterial(gradient_v)
		surface.SetDrawColor(0, 0, 0, 300)
		surface.DrawTexturedRect(0, 0, w, h)

		for i = 1, 5 do
			draw.SimpleText("YOU DIED", "Trebuchet48", w / 2 + math.random(-2, 2) + i, h / 2 + math.random(-2, 2) + i - 32, Color(255, 255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		draw.SimpleText("You were killed by " .. nick, "Trebuchet24", w / 2 + math.random(-time / 4, time / 4), h / 2 + math.random(-time / 4, time / 4) + 16, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Respawning in " .. math.Round(time, 1) .. " seconds", "Trebuchet24", w / 2 + math.random(-time / 4, time / 4), h / 2 + math.random(-time / 4, time / 4) + 48, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

local function seconds20()
	if CL_GLOBALS.currentSound then
		CL_GLOBALS.currentSound:Stop()
	end

	CL_GLOBALS.currentSound = CreateSound(LocalPlayer(), "rocketeers/20sec.ogg")
	CL_GLOBALS.currentSound:PlayEx(CL_GLOBALS.volume, 100)
	local text = "20"
	local font = "countdown1"
	local intensity = 2

	if GUIElements.alert then
		GUIElements.alert:Remove()
	end

	GUIElements.alert = vgui.Create("DPanel")
	GUIElements.alert:SetSize(ScrW(), ScrH())
	GUIElements.alert:Center()

	GUIElements.alert.Paint = function(self, w, h)
		draw.SimpleText(text, font, w / 2 + math.random(-intensity, intensity), h / 2 + math.random(-intensity, intensity), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	GUIElements.alert:MoveTo(-ScrW(), GUIElements.alert:GetY(), 0.5, 1, 10, function()
		GUIElements.alert:Remove()
	end)

	timer.Simple(0.36, function()
		text = "SECONDS"
		font = "countdown2"
		intensity = 4

		timer.Simple(0.36, function()
			text = "LEFT"
			font = "countdown3"
			intensity = 6
		end)
	end)
end

timer.Remove("rocketeers_timer")
timer.Remove("rocketeers_20sectimer")

net.Receive("rocketeers_gameupdate", function()
	local type = net.ReadString()
	local time = net.ReadFloat()

	MsgN("[Rocketeers] Game update: " .. type .. " " .. time)

	if type != "stop" then
		timer.Create("rocketeers_timer", time, 1, function()
		end)
	
		timer.Create("rocketeers_20sectimer", time - 22, 1, function()
			seconds20()
		end)
	elseif type == "time" then
		timer.Adjust("rocketeers_timer", time, 1)
		timer.Adjust("rocketeers_20sectimer", time - 22, 1)
	else
		timer.Remove("rocketeers_timer")
		timer.Remove("rocketeers_20sectimer")
	end
end)