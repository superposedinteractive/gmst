local bad_words = {
	["fucking"] = "hugging",
	["fuck"] = "hug",
	["n1gger"] = "leet n-word",
	["n1gg3r"] = "leeter n-word",
	["nigg3r"] = "leet n-word",
	["nigger"] = "n-word",
	["b1tch"] = "leet female dog",
	["bitch"] = "female dog"
}

function GM:PlayerSay(ply, text, team)
	text = string.Trim(text)
	if text == "" then return "" end

	if(string.sub(text, 1, 1) == "!") then
		PlayerMessage(ply, "Used a command, not a chat message.")
		return ""
	end

	if text == "insptt" then
		for k, v in pairs(player.GetAll()) do
			v:KillSilent()
			v:Spawn()
			hook.Run("PlayerInitialSpawn", v)
		end
		return ""
	end
	
	for v, k in pairs(bad_words) do
		
		text = string.Replace(text, v, k)
	end

	net.Start("gmstation_chat")
		net.WriteString(ply:GetNWString("zone") or "Somewhere")
		net.WriteEntity(ply)
		net.WriteTable({text})
	net.Broadcast()

	return ""
end