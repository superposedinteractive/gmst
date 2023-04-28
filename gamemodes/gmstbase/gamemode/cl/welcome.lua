MsgN()
MsgN()
MsgN("   Welcome to")
MsgN("   _________  _________   __________  _______ __  ___")
MsgN("  / ____/   |/_  __/   | / ____/ /\\ \\/ / ___//  |/  /")
MsgN(" / /   / /| | / / / /| |/ /   / /  \\  /\\__ \\/ /|_/ / ")
MsgN("/ /___/ ___ |/ / / ___ / /___/ /___/ /___/ / /  / /  ")
MsgN("\\____/_/  |_/_/ /_/  |_\\____/_____/_//____/_/  /_/   ")
MsgN("  BASE                            Enjoy your stay!   ")
MsgN()
MsgN()

CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )

function panic(msg)
	surface.PlaySound("buttons/button11.wav")
	notification.Kill("gms_chat_info")
	notification.AddLegacy("Error: " .. msg .. "\n\nPlease rejoin to (hopefully) fix the issue.\n\nThat's the best we can do to prevent Lua errors...", NOTIFY_ERROR, 10)

	notification.AddProgress("gms_chat_info", "Gathering error info...")
		
	timer.Simple(3, function()
		notification.Kill("gms_chat_info")
		surface.PlaySound("ui/buttonclick.wav")
		notification.AddLegacy("Sucess! Check the console for more info.", NOTIFY_GENERIC, 5)

		MsgN("GMStation error info:\n")
		PrintTable(debug.getinfo(1))
		MsgN(debug.traceback())
		MsgN(debug.Trace())
		MsgN("--------------------")
		MsgN("\nGMStation error info end")
	end)
end


concommand.Add("gms_panic", function(ply, cmd, args)
	if args[1] then
		panic(args[1])
	else
		panic("Test error")
	end
end)

RunConsoleCommand("mat_bloomscale", 0.35)