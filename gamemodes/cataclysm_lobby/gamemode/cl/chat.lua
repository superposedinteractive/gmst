// cataclysm - Chat system

net.Receive("cataclysm_chat", function()
	local zone = net.ReadString()
	local color = net.ReadVector()
	local nick = net.ReadString()
	local msg = net.ReadString()


	chat.AddText(Color(100, 100, 100), zone .. " | ", Color(color.x * 255, color.y * 255, color.z * 255), nick .. ": ", Color(255, 255, 255), msg)

	chat.PlaySound()
end)