local CATEGORY_NAME = "GMStation"

function ulx.restart(calling_ply, time)
	GMSTRestartMap(time)
end

local restart = ulx.command(CATEGORY_NAME, "ulx restartmap", ulx.restart, "!restartmap")
restart:defaultAccess(ULib.ACCESS_ADMIN)
restart:help("Restarts the map in the given time.")
restart:addParam{
	type = ULib.cmds.NumArg,
	min = 10,
	max = 120,
	default = 10,
	hint = "time",
	ULib.cmds.round
}

function ulx.devmode(calling_ply)
	SV_GLOBALS.devmode = !SV_GLOBALS.devmode || false
	ulx.fancyLogAdmin(calling_ply, "#A has toggled devmode to #s", SV_GLOBALS.devmode && "on" || "off")
end

local devmode = ulx.command(CATEGORY_NAME, "ulx devmode", ulx.devmode, "!devmode")
devmode:defaultAccess(ULib.ACCESS_SUPERADMIN)
devmode:help("Toggles devmode.")