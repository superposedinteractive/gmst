// GMStation - General UI
local hoz = Material("gmstation/ui/gradients/hoz.png", "noclamp smooth")

function SetupHUD()
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
		money = math.ceil(Lerp(FrameTime() * 4, money, CL_GLOBALS.money || 0))

		surface.SetDrawColor(0, 0, 0)
		surface.SetMaterial(hoz)
		surface.DrawTexturedRect(0, 0, 300, h)

		draw.SimpleText(CL_GLOBALS.zone || "Somewhere", "Trebuchet24Bold", 18, 28, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(money .. "cc", "Trebuchet32", 18, 66, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

function GM:OnScreenSizeChanged(w, h)
	createFonts()

	if IsValid(GUIElements.quick_hud) then
		SetupHUD()
	end
end

function displaySpeech(icon, text, name)
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

function GM:OnReloaded()
	if CL_GLOBALS.steamid != nil then
		FetchInfo()
	end
end

net.Receive("gmstation_first_join", function()
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
	apiCall("player_info", {
		steamid = CL_GLOBALS.steamid
	}, function(body, len, headers, code)
		MsgN("[GMST] Info received, updated global variables")
		CL_GLOBALS.money = body["money"] || "ERROR"
	end)
end

net.Receive("gmstation_first_join_done", function()
	CL_GLOBALS.steamid = net.ReadString() // LocalPlayer():SteamID64() sometimes player isn't ready yet
	if GUIElements.registering != nil then
		GUIElements.registering:Remove()
	end
	FetchInfo()
end)

net.Receive("gmstation_update", function()
	MsgN("[GMST] Update received, updating...")
	FetchInfo()
end)

SetupHUD()

Derma_Message("Welcome to GMStation!\nThis is a very early version of the gamemode, so expect bugs and missing features.\nIf you find any bugs, please report them on the Discord (https://discord.gg/EnadGnaAGm).\n\nHave fun!", "GMStation", "Sounds neat.")