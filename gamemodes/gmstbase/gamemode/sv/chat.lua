function GM:PlayerSay(ply, text, team)
	text = string.Trim(text)
	if text == "" then return "" end

	if string.sub(text, 1, 1) == "!" then
		PlayerMessage(ply, "Used a command, not a chat message.")

		return ""
	end

	local temptext = string.lower(text)

	local words = string.Explode(" ", string.lower(temptext))

	for k, v in pairs(words) do
		for word, replacement in pairs(bad_words) do
			if v == word then
				words[k] = replacement
				hook.Run("gmstation_chat_bad_word", ply, word)
			end
		end
	end

	text = string.Implode(" ", words)

	net.Start("gmstation_chat")
	net.WriteString(ply:GetNW2String("zone") || "Somewhere")
	net.WriteEntity(ply)

	net.WriteTable({text})

	net.Broadcast()

	return ""
end
