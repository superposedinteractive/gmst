// GMStation - Chat system

function chat.AddText( ... )
	local args = {...}

	GUIElements.chatbox.box:InsertColorChange( 255, 255, 255, 255 )

	for _, obj in ipairs( args ) do
		if !IsValid(GUIElements.chatbox.box) then continue end
		if type( obj ) == "table" then
			GUIElements.chatbox.box:InsertColorChange( obj.r, obj.g, obj.b, 255 )
		elseif type( obj ) == "string"  then
			GUIElements.chatbox.box:AppendText( obj )
		elseif obj:IsPlayer() then
			local col = obj:GetPlayerColor() * 255
			GUIElements.chatbox.box:InsertColorChange( col.r, col.g, col.b, 255 )
			GUIElements.chatbox.box:AppendText( obj:Nick() )
		end
	end

	GUIElements.chatbox.box:AppendText( "\n" )

	if oldChat then
		oldChat(...)
	else
		panic("Failed to send the chat message to the old chat system.\nChat logs will NOT be saved in the console.")
	end
end

net.Receive("gmstation_chat", function()
	local zone = net.ReadString()
	local ply = net.ReadEntity()
	local msg = net.ReadString()

	chat.AddText(Color(100, 100, 100), zone .. " | ", ply, ": ", Color(255, 255, 255), msg)

	chat.PlaySound()
end)

GUIElements.chatbox = vgui.Create("DFrame")
GUIElements.chatbox:SetSize(math.min(ScrW() * 0.5, 700), math.min(ScrH() * 0.5, 250))
GUIElements.chatbox:SetMinimumSize(GUIElements.chatbox:GetWide(), GUIElements.chatbox:GetTall())
GUIElements.chatbox:SetPos(32, ScrH() - GUIElements.chatbox:GetTall() - 32 - 100 - 32)
GUIElements.chatbox:SetTitle("")
GUIElements.chatbox:SetDraggable(true)
GUIElements.chatbox:ShowCloseButton(false)
GUIElements.chatbox:SetSizable(true)
GUIElements.chatbox.Paint = function(self, w, h)
	if GUIElements.chatbox:IsActive() then
		surface.SetDrawColor(0, 0, 0, 200)
	else
		surface.SetDrawColor(0, 0, 0, 0)
	end
	surface.DrawRect(0, 0, w, h)
end

GUIElements.chatbox.box = vgui.Create("RichText", GUIElements.chatbox)
GUIElements.chatbox.box:Dock(FILL)
GUIElements.chatbox.box:SetContentAlignment(1)
GUIElements.chatbox.box:SetWrap(true)
GUIElements.chatbox.box.PerformLayout = function(self)
	self:SetFontInternal("TrebuchetChat")
	self:SetFGColor(Color(255, 255, 255))
	self:SetContentAlignment(1)
	if GUIElements.chatbox:IsActive() then
		GUIElements.chatbox.box:SetVerticalScrollbarEnabled(true)
	else
		GUIElements.chatbox.box:SetVerticalScrollbarEnabled(false)
	end
end

GUIElements.chatbox.text = vgui.Create("DTextEntry", GUIElements.chatbox)
GUIElements.chatbox.text:Dock(BOTTOM)
GUIElements.chatbox.text:SetVisible(false)
GUIElements.chatbox.text.OnKeyCodeTyped = function(self, key)
	if key == KEY_ESCAPE then
		self:SetText("")

		GUIElements.chatbox.close()
		gui.HideGameUI()
	end

	if key == KEY_ENTER then
		local trimmed = string.Trim(self:GetText())
		trimmed = string.gsub(trimmed, "\"", "'")
	
		if trimmed == "" then GUIElements.chatbox.close() return end
	
		LocalPlayer():ConCommand("say " .. trimmed)
	
		GUIElements.chatbox.close()
	
		self:SetText("")
	end
end

GUIElements.chatbox.open = function()
	if !IsValid(GUIElements.chatbox) then return end

	GUIElements.chatbox:SetVisible(true)
	GUIElements.chatbox:MakePopup()

	hook.Run("StartChat")

	GUIElements.chatbox:SetMouseInputEnabled(true)
	GUIElements.chatbox:SetKeyboardInputEnabled(true)

	GUIElements.chatbox.text:SetVisible(true)
	GUIElements.chatbox.text:RequestFocus()
end

GUIElements.chatbox.close = function()
	if !IsValid(GUIElements.chatbox) then return end

	hook.Run("FinishChat")

	GUIElements.chatbox:SetMouseInputEnabled(false)
	GUIElements.chatbox:SetKeyboardInputEnabled(false)

	GUIElements.chatbox.text:SetVisible(false)

	gui.EnableScreenClicker(false)
end

hook.Add("PlayerBindPress", "gmstation_chat", function(ply, bind, pressed)
	if bind == "messagemode" || bind == "messagemode2" then
		if !IsValid(GUIElements.chatbox) then return end
		GUIElements.chatbox.open()

		return true
	end
end)

function GM:ChatText( index, name, text, type )
	if type == "joinleave" || type == "none" || type == "servermsg" then 
		GUIElements.chatbox.box:AppendText( text .. "\n" )
	end
end
