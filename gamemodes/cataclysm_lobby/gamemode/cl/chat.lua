// cataclysm - Chat system

net.Receive("cataclysm_chat", function()
	local zone = net.ReadString()
	local nick = net.ReadString()
	local msg = net.ReadString()

	chat.AddText(Color(100, 100, 100), zone .. " | ", Color(255, 255, 255), nick .. ": ", Color(255, 255, 255), msg)

	chat.PlaySound()
end)