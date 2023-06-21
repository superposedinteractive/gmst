local bad_chars = {"!", "?", ".", ",", ":", ";", "'", '"', "(", ")", "[", "]", "{", "}", "<", ">", "/", "\\", "|", "-", "_", "=", "+", "*", "&", "^", "%", "$", "#", "@", "~", "`",}

function GM:PlayerSay(ply, text, team)
	text = string.Trim(text)
	if text == "" then return "" end

	if string.sub(text, 1, 1) == "!" then
		PlayerMessage(ply, "Used a command, not a chat message.")

		return ""
	end

	local temptext = string.lower(text)

	for i = 1, #bad_chars do
		temptext = string.Replace(temptext, bad_chars[i], "")
	end

	local words = string.Explode(" ", string.lower(temptext))

	for k, v in pairs(words) do
		for word, replacement in pairs(bad_words) do
			if string.match(string.lower(v), string.lower(word)) then
				words[k] = replacement
				hook.Run("gmstation_chat_bad_word", ply, word)
			end
		end
	end

	for k, v in pairs(words) do
		if v == "a" then continue end

		if string.len(v) == 1 then
			words[k] = " "
		end
	end

	text = string.Trim(string.Implode(" ", words))

	if string.len(text) == 0 then
		text = "I tried to bypass the chat filter!! I faild thus making me a big fat idiot!!"
		hook.Run("gmstation_chat_bad_word", ply, "***")
	end

	net.Start("gmstation_chat")
	net.WriteString(ply:GetNW2String("zone") || "Somewhere")
	net.WriteEntity(ply)

	net.WriteTable({text})

	net.Broadcast()

	return ""
end
