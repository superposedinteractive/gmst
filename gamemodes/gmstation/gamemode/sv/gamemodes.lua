function GMST_BeginGamemode(gm, skipactivecheck)
	if !skipactivecheck then
		apiCall("game_status", {id = gm}, function(body, length, headers, code)
			if body.in_progress then
				MsgN("[GMST] Gamemode is already in progress!")
				return
			end
		end)
	else
		MsgN("[GMST] Skipping active gamemode check!")
	end

	
end