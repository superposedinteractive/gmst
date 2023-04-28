util.AddNetworkString("gmstation_map_restart")

function gmstRestartMap(time)
	MsgN("[GMSTBase] Restarting map in " .. time .. " seconds...")

	net.Start("gmstation_map_restart")
		net.WriteFloat(time)
	net.Broadcast()

	timer.Create("gmstation_map_restart", time, 1, function()
		RunConsoleCommand("changelevel", game.GetMap())
	end)
end