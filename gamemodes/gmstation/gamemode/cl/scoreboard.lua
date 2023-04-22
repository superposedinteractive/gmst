// GMStation - tab plugin

local bgColor = Color(25, 25, 25, 200)
local headerColor = Color(0, 120, 255, 255)
local rowColor1 = Color(0, 102, 218)
local rowColor2 = Color(0, 78, 167, 200)
local textColor = Color(255, 255, 255, 255)

local matBlurScreen = Material( "pp/blurscreen" )

local tabs = {
	"Players",
	"Settings"
}

function Derma_DrawBackgroundBlurInside( panel )
	local x, y = panel:LocalToScreen( 0, 0 )

	surface.SetMaterial( matBlurScreen )
	surface.SetDrawColor( 255, 255, 255, 255 )

	for i=0.33, 1, 0.33 do
			matBlurScreen:SetFloat( "$blur", 5 * i ) -- Increase number 5 for more blur
			matBlurScreen:Recompute()
			if ( render ) then render.UpdateScreenEffectTexture() end
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end

	-- The line below gives the background a dark tint
	surface.SetDrawColor( 10, 10, 10, 150 )
	surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )
end

hook.Add("ScoreboardShow", "gmstation_tab", function()
	gui.EnableScreenClicker(true)

	if(IsValid(GUIElements.tab)) then
		GUIElements.tab:Remove()
	end

	GUIElements.tab = vgui.Create("DPanel")
	GUIElements.tab:SetSize(800, 500)
	GUIElements.tab:Center()
	GUIElements.tab:SetAlpha(0)
	GUIElements.tab:AlphaTo(255, 0.125, 0)
	GUIElements.tab.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, bgColor)
	end

	// background blur
	GUIElements.tab.blur = vgui.Create("DPanel", GUIElements.tab)
	GUIElements.tab.blur:SetSize(GUIElements.tab:GetWide(), GUIElements.tab:GetTall())
	GUIElements.tab.blur:Center()
	GUIElements.tab.blur.Paint = function(self, w, h)
		Derma_DrawBackgroundBlurInside(self)
	end

	GUIElements.tab.header = vgui.Create("DPanel", GUIElements.tab)
	GUIElements.tab.header:SetSize(GUIElements.tab:GetWide(), 32)
	GUIElements.tab.header:SetPos(0, 0)
	GUIElements.tab.header.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, headerColor)
	end

	GUIElements.tab.header.title = vgui.Create("DLabel", GUIElements.tab.header)
	GUIElements.tab.header.title:SetFont("Trebuchet24Bold")
	GUIElements.tab.header.title:SetText("GMStation")
	GUIElements.tab.header.title:SetTextColor(textColor)
	GUIElements.tab.header.title:SizeToContents()
	GUIElements.tab.header.title:SetX(8)
	GUIElements.tab.header.title:CenterVertical()

	GUIElements.tab.tabs = vgui.Create("DPanelList", GUIElements.tab)
	GUIElements.tab.tabs:SetSize(128, GUIElements.tab:GetTall() - GUIElements.tab.header:GetTall())
	GUIElements.tab.tabs:SetPos(0, GUIElements.tab.header:GetTall())
	GUIElements.tab.tabs:EnableVerticalScrollbar(true)
	GUIElements.tab.tabs:EnableHorizontal(false)
	GUIElements.tab.tabs:SetSpacing(1)
	GUIElements.tab.tabs.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, rowColor2)
	end

	// fill sidepanel with buttons

	for k, v in pairs(tabs) do
		local button = vgui.Create("DButton")
		button:SetText(v)
		button:SetTextColor(textColor)
		button:SetFont("Trebuchet16")
		button:SetSize(GUIElements.tab.tabs:GetWide(), 32)
		button:SetX(20)
		button.Paint = function(self, w, h)
			if(self:IsHovered()) then
				draw.RoundedBox(0, 0, 0, w, h, rowColor1)
			else
				draw.RoundedBox(0, 0, 0, w, h, rowColor2)
			end
		end
		button.DoClick = function()
			if(v == "Players") then
				GUIElements.tab.players:SetVisible(true)
				GUIElements.tab.settings:SetVisible(false)
			elseif(v == "Settings") then
				GUIElements.tab.players:SetVisible(false)
				GUIElements.tab.settings:SetVisible(true)
			end
		end

		GUIElements.tab.tabs:AddItem(button)
	end

	return false
end)

hook.Add("ScoreboardHide", "gmstation_tab", function()
	gui.EnableScreenClicker(false)

	if(IsValid(GUIElements.tab)) then
		GUIElements.tab:AlphaTo(0, 0.125, 0, function()
			GUIElements.tab:Remove()
		end)
	end

	return false
end)