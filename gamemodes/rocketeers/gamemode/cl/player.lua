local gradient_h = Material("rocketeers/hoz.png", "smooth")
local gradient_v = Material("rocketeers/vert.png", "smooth")

local cur_ammo = 3

function GM:CreateMove(uc)
	if uc:KeyDown(IN_JUMP) && LocalPlayer():WaterLevel() < 2 && LocalPlayer():GetMoveType() == MOVETYPE_WALK then
		if LocalPlayer():IsOnGround() then
			uc:SetButtons(bit.bor(uc:GetButtons(), IN_JUMP))
		else
			uc:SetButtons(bit.band(uc:GetButtons(), bit.bnot(IN_JUMP)))
		end
	end
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

	local hp = 100
	if IsValid(LocalPlayer()) then
		hp = LocalPlayer():Health()
		if hp < 0 then
			hp = "Probably dead"
		end
	end

	draw.SimpleText(hp, "Trebuchet32", 16, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(ammo, "Trebuchet24", 16, h - 8, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
end

GUIElements.timer = vgui.Create("DPanel")
GUIElements.timer:SetSize(300, 64)
GUIElements.timer:CenterHorizontal()
GUIElements.timer.Paint = function(self, w, h)
	surface.SetMaterial(gradient_v)
	surface.SetDrawColor(0, 0, 0)
	surface.DrawTexturedRect(0, 0, w, h)
	draw.SimpleText(string.FormattedTime(0, "%02i:%02i"), "Trebuchet32Bold", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function GM:PlayerAmmoChanged(ply, ammo, oldcount, newcount)
	if ammo != game.GetAmmoID("RPG_Round") then return end

	cur_ammo = newcount

	if newcount > oldcount && ammo == game.GetAmmoID("RPG_Round") then
		surface.PlaySound("friends/friend_online.wav")
		GUIElements.hudglow = vgui.Create("DPanel")
		GUIElements.hudglow:SetSize(600, 24)
		GUIElements.hudglow:SetPos(0, ScrH() - GUIElements.HUD:GetTall() + 36)
		GUIElements.hudglow.Paint = function(self, w, h)
			surface.SetMaterial(gradient_h)
			surface.SetDrawColor(0, 255, 0)
			surface.DrawTexturedRect(0, 0, w, h)
		end
		GUIElements.hudglow:AlphaTo(0, 1, 0, function()
			GUIElements.hudglow:Remove()
		end)
	end

	if newcount == 0 then
		surface.PlaySound("buttons/button10.wav")
	end
end

net.Receive("rocketeers_damage", function()
	local dmg = net.ReadFloat()
	local attacker = net.ReadEntity()
	local victim = net.ReadEntity()

	if victim == LocalPlayer() then

		local nick
		if IsValid(attacker) && attacker:IsPlayer() then
			nick = attacker:Nick() .. "!"
		else
			nick = "something..."
		end

		if dmg >= LocalPlayer():Health() then
			if GUIElements.death then
				GUIElements.death:Remove()
			end

			timer.Create("rocketeers_respawn", 3, 1, function() end)

			GUIElements.death = vgui.Create("DPanel")
			GUIElements.death:SetSize(ScrW(), ScrH())
			GUIElements.death.Paint = function(self, w, h)
				local time = timer.TimeLeft("rocketeers_respawn") or 0

				surface.SetMaterial(gradient_v)
				surface.SetDrawColor(0, 0, 0, 300)
				surface.DrawTexturedRect(0, 0, w, h)
				for i = 1, 5 do
					draw.SimpleText("YOU DIED", "Trebuchet48", w / 2 + math.random(-2, 2) + i, h / 2 + math.random(-2, 2) + i - 32, Color(255, 255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				draw.SimpleText("You were killed by " .. nick, "Trebuchet24", w / 2 + math.random(-2, 2), h / 2 + math.random(-2, 2) + 16, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Respawning in " .. math.Round(time, 1) .. " seconds", "Trebuchet24", w / 2 + math.random(-2, 2), h / 2 + math.random(-2, 2) + 48, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			timer.Simple(3, function()
				GUIElements.death:AlphaTo(0, 1, 0, function()
					GUIElements.death:Remove()
				end)
			end)
		else
			GUIElements.hudglow = vgui.Create("DPanel")
			GUIElements.hudglow:SetSize(600, 32)
			GUIElements.hudglow:SetPos(0, ScrH() - GUIElements.HUD:GetTall() - 14)
			GUIElements.hudglow.Paint = function(self, w, h)
				surface.SetMaterial(gradient_h)
				surface.SetDrawColor(255, 0, 0)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			GUIElements.hudglow:AlphaTo(0, 1, 0, function()
				GUIElements.hudglow:Remove()
			end)
		end
	end
end)