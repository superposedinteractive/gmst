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
	
	if text == "pyytt" then
		for k, v in pairs(player.GetAll()) do
			local rewards = {
				{"Test reward", 100},
				{"Test reward", 200},
				{"Test reward", 300},
				{"Test reward", 400},
				{"Test reward", 500},
				{"Test reward", 600},
				{"Test reward", 700},
				{"Test reward", 800},
				{"Test reward", 900},
				{"Test reward", 1000},
			}
			v:Payout(rewards)
		end
		return ""
	end

	local words = string.Explode(" ", text)

	for k, v in pairs(words) do
		for word, replacement in pairs(bad_words) do
			if string.match(string.lower(v), string.lower(word)) then
				words[k] = replacement
				hook.Run("gmstation_chat_bad_word", ply, word)
			end
		end
	end

	text = string.Implode(" ", words)

	net.Start("gmstation_chat")
		net.WriteString(ply:GetNWString("zone") or "Somewhere")
		net.WriteEntity(ply)
		net.WriteTable({text})
	net.Broadcast()

	return ""
end