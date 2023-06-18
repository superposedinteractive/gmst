// GMStation - General UI
local hoz = Material("gmstation/ui/gradients/hoz.png", "noclamp smooth")

function OpenTerms(closebutton)
	GUIElements.terms = vgui.Create("DPanel")
	GUIElements.terms:SetSize(ScrW(), ScrH())
	GUIElements.terms:MakePopup()
	GUIElements.terms.html = vgui.Create("DHTML", GUIElements.terms)
	GUIElements.terms.html:Dock(FILL)
	GUIElements.terms.html:OpenURL("https://superposed.xyz/gmstation/terms")

	if closebutton then
		GUIElements.terms.close = vgui.Create("DButton", GUIElements.terms)
		GUIElements.terms.close:SetSize(100, 30)
		GUIElements.terms.close:SetX(ScrW() - GUIElements.terms.close:GetWide() - 32)
		GUIElements.terms.close:SetY(ScrH() - GUIElements.terms.close:GetTall() - 16)
		GUIElements.terms.close:SetText("Close")

		GUIElements.terms.close.DoClick = function()
			GUIElements.terms:Remove()
		end
	end
end

function SetupHUD()
	GMSTBase_Notification("Welcome", {"Your profile has been loaded."})

	Derma_Message("Welcome to GMStation!\nThis is a very early version of the gamemode, so expect bugs and missing features.\nIf you find any bugs, please report them on the Discord (https://discord.gg/EnadGnaAGm).\n\nHave fun!", "GMStation", "Sounds neat.")
	local money = 0

	if IsValid(GUIElements.registering) then
		GUIElements.registering:Remove()
	end

	if IsValid(GUIElements.quick_hud) then
		GUIElements.quick_hud:Remove()
	end

	if IsValid(GUIElements.info_box) then
		GUIElements.info_box:Remove()
	end

	surface.SetFont("Trebuchet32")
	GUIElements.quick_hud = vgui.Create("DPanel")
	GUIElements.quick_hud:SetSize(ScrW(), 100)
	GUIElements.quick_hud:SetPos(0, ScrH() - 100 - 32)

	GUIElements.quick_hud.Paint = function(self, w, h)
		money = math.Round(Lerp(FrameTime() * 4, money, CL_GLOBALS.money || 0))
		surface.SetDrawColor(0, 0, 0)
		surface.SetMaterial(hoz)
		surface.DrawTexturedRect(0, 0, 300, h)
		draw.SimpleText(CL_GLOBALS.zone || "Somewhere", "Trebuchet24Bold", 18 + 2, 28 + 2, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(CL_GLOBALS.zone || "Somewhere", "Trebuchet24Bold", 18, 28, Color(190, 190, 190), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(CL_GLOBALS.money) .. "cc", "Trebuchet32", 18 + 2, 66 + 2, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(CL_GLOBALS.money) .. "cc", "Trebuchet32", 18, 66, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

function GM:OnScreenSizeChanged(w, h)
	createFonts()

	if IsValid(GUIElements.quick_hud) then
		SetupHUD()
	end
end

function GMST_DisplaySpeech(icon, text, name)
	timer.Remove("gmstation_textbox")

	if IsValid(GUIElements.speech) then
		GUIElements.speech:Remove()
	end

	local time = math.max(string.len(text) * 0.05, 3)

	if icon == nil then
		icon = "missigno-cat"
	end

	icon = Material("gmstation/ui/textbox/" .. icon .. ".png", "noclamp smooth")
	local texttext = ""

	timer.Simple(0.15, function()
		for i = 1, string.len(text) do
			timer.Simple(i * 0.025, function()
				texttext = string.sub(text, 1, i)
				surface.PlaySound("/gmstation/sfx/chat" .. math.random(1, 2) .. ".wav")
			end)
		end
	end)

	GUIElements.speech = vgui.Create("DPanel")
	GUIElements.speech:SetSize(math.min(ScrW() - 64, 750), 132)
	GUIElements.speech:CenterHorizontal()
	GUIElements.speech:SetY(ScrH())
	GUIElements.speech:MoveTo(GUIElements.speech:GetX(), ScrH() - 100 - 64, 0.5, 0, 0.5)

	GUIElements.speech.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 32, w, h - 32, Color(0, 0, 0, 200))
		draw.RoundedBox(4, 16, 16, w / 4, 32, Color(0, 0, 0))
		draw.SimpleText(name || "Missingno", "Trebuchet16", w / 7, 32, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(icon)
		surface.DrawTexturedRectRotated(48, h / 2 + 22, 64, 64, math.sin(CurTime() * 2) * 5)
		draw.DrawText(texttext, "Trebuchet16", 96, 24 + 32, Color(255, 255, 255), TEXT_ALIGN_TOP)
	end

	timer.Create("gmstation_textbox", time, 1, function()
		if IsValid(GUIElements.speech) then
			GUIElements.speech:MoveTo(GUIElements.speech:GetX(), ScrH(), 0.5, 0, 0.5, function()
				GUIElements.speech:Remove()
			end)
		end
	end)
end

function GMST_ScrollingAnnouncement(text)
	if IsValid(GUIElements.announcement) then
		GUIElements.announcement:Remove()
	end

	local dialouge = string.Replace(string.Replace(string.Replace(string.lower(text), " ", ""), "'", ""), ".", "")
	dialouge = string.sub(dialouge, 1, 8)

	MsgN("Announcement: " .. dialouge)

	if file.Exists("sound/gmstation/sfx/announcer/" .. dialouge .. ".wav", "GAME") then
		timer.Simple(3, function()
			surface.PlaySound("gmstation/sfx/announcer/" .. dialouge .. ".wav")
		end)
	end

	surface.PlaySound("gmstation/sfx/announcer/announce_start.wav")

	surface.SetFont("Trebuchet32Bold")
	local w, h = surface.GetTextSize(text)

	GUIElements.announcement = vgui.Create("DPanel")
	GUIElements.announcement:SetSize(w, 64)
	GUIElements.announcement:SetPos(ScrW(), 128)

	GUIElements.announcement.Paint = function(self, w, h)
		draw.SimpleText(text, "Trebuchet32Bold", 2, h / 2 + 2, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(text, "Trebuchet32Bold", 0, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	GUIElements.announcement:MoveTo(-w, GUIElements.announcement:GetY(), 10, 3.5, 1, function()
		if IsValid(GUIElements.announcement) then
			GUIElements.announcement:Remove()
		end
	end)
end

net.Receive("gmstation_announcement", function()
	GMST_ScrollingAnnouncement(net.ReadString())
end)

function GM:OnReloaded()
	GMSTBase_RetreiveItems()
	if CL_GLOBALS.steamid != nil then
		SetupHUD()
		FetchInfo()
	end
end

net.Receive("gmstation_first_join", function()
	if IsValid(GUIElements.terms) then
		GUIElements.terms:Remove()
	end

	if IsValid(GUIElements.registering) then
		GUIElements.registering:Remove()
	end

	GUIElements.registering = vgui.Create("DPanel")
	GUIElements.registering:SetSize(ScrW(), ScrH())

	GUIElements.registering.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 250))
		draw.SimpleText("Please wait while we register you...", "Trebuchet32", w / 2, h / 2 - 16, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("This may take a few seconds.", "Trebuchet16", w / 2, h / 2 + 16, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

function FetchInfo()
	MsgN("[GMST] Fetching info...")

	local oldMoney = CL_GLOBALS.money || 0

	apiCall("player_info", {
		steamid = CL_GLOBALS.steamid
	}, function(body, len, headers, code)
		MsgN("[GMST] Info received, updated global variables")

		CL_GLOBALS.money = body["money"] || "ERROR"
		CL_GLOBALS.inventory = body["inventory"] || {}

		if oldMoney != 0 then
			if oldMoney > CL_GLOBALS.money then
				surface.PlaySound("/mvm/mvm_bought_upgrade.wav")
				GMSTBase_Notification("GMSTBank", "You lost " .. string.Comma(oldMoney - CL_GLOBALS.money) .. "cc.")
			else
				surface.PlaySound("/mvm/mvm_money_pickup.wav")
				GMSTBase_Notification("GMSTBank", "You got " .. string.Comma(CL_GLOBALS.money - oldMoney) .. "cc.")
			end
		end
	end)
end

net.Receive("gmstation_terms", function()
	OpenTerms()
	GUIElements.terms.accept = vgui.Create("DButton", GUIElements.terms)
	GUIElements.terms.accept:SetText("I accept the Terms of Service")
	GUIElements.terms.accept:SetSize(255, 64)
	GUIElements.terms.accept:SetX(ScrW() - GUIElements.terms.accept:GetWide() - 32)
	GUIElements.terms.accept:SetY(ScrH() - 64 - 32)
	GUIElements.terms.deny = vgui.Create("DButton", GUIElements.terms)
	GUIElements.terms.deny:SetText("I do not accept the Terms of Service")
	GUIElements.terms.deny:SetSize(255, 64)
	GUIElements.terms.deny:SetX(ScrW() - GUIElements.terms.deny:GetWide() - 32)
	GUIElements.terms.deny:SetY(ScrH() - 64 - 32 - 64 - 16)

	GUIElements.terms.accept.DoClick = function()
		net.Start("gmstation_terms")
		net.SendToServer()
		GUIElements.terms:Remove()
	end

	GUIElements.terms.deny.DoClick = function()
		RunConsoleCommand("disconnect")
	end
end)

net.Receive("gmstation_first_join_done", function()
	CL_GLOBALS.steamid = net.ReadString() // LocalPlayer():SteamID64() sometimes player isn't ready yet

	if IsValid(GUIElements.terms) then
		GUIElements.terms:Remove()
	end

	if IsValid(GUIElements.registering) then
		GUIElements.registering:Remove()
	end

	SetupHUD()
	FetchInfo()
end)

net.Receive("gmstation_update", function()
	MsgN("[GMST] Update received, updating...")
	FetchInfo()
end)

net.Receive("gmstation_gmabouttostart", function()
	local gm = net.ReadString()
	local time = net.ReadInt(32)
	local timeLeft = time - os.time()

	if CL_GLOBALS.watching == gm then
		GMST_ScrollingAnnouncement(string.upper(gm) .. " is about to start in " .. string.NiceTime(timeLeft) .. "!")
	end
end)