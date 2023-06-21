util.AddNetworkString("gmstation_gmabouttostart")

local gms = {"rocketeers"}

local function checkGamemode(gm, callback)
	apiCall("game_status", {
		id = gm
	}, function(body, length, headers, code)
		if callback then
			callback(body.in_progress)
		end
	end)
end

function GMST_BeginGamemode(gm, skipactivecheck)
	if !skipactivecheck then
		checkGamemode(gm, function(in_progress)
			if in_progress then
				MsgN("[GMST] Gamemode " .. gm .. " is active!")

				return
			end
		end)
	else
		MsgN("[GMST] Skipping active gamemode check!")
	end
end

timer.Create("GMST_SpawnGMTrain", 10, 0, function()
	for i = 1, #gms do
		local gm = gms[i]
		MsgN("[GMST] Checking gamemode " .. gm)

		checkGamemode(gm, function(in_progress)
			if in_progress then
				MsgN("[GMST] Gamemode " .. gm .. " is active! Deleting potential train...")
				local trains = ents.FindByClass("ent_gmtrain")

				for i = 1, #trains do
					local train = trains[i]

					if train.gamemode == gm then
						MsgN("[GMST] Deleting train for gamemode " .. gm .. "!")
						train:Remove()
					end
				end

				return
			end

			MsgN("[GMST] Gamemode " .. gm .. " is not active, spawning train?")
			local trains = ents.FindByClass("ent_gmtrain")

			for i = 1, #trains do
				local train = trains[i]

				if train.gamemode == gm then
					MsgN("[GMST] Train for gamemode " .. gm .. " already exists!")

					return
				end
			end

			MsgN("[GMST] Spawning train for gamemode " .. gm .. "!")
			net.Start("gmstation_gmabouttostart")
			net.WriteString(gm)
			net.Broadcast()
		end)
	end
end)
