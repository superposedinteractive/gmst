local CATEGORY_NAME = "GMStation"

function ulx.restart(calling_ply, time)
	GMSTRestartMap(time)
end

local test = ulx.command(CATEGORY_NAME, "ulx restartmap", ulx.restart, "!restartmap")
test:defaultAccess(ULib.ACCESS_ADMIN)
test:addParam{
	type = ULib.cmds.NumArg,
	min = 10,
	default = 10,
	hint = "time",
	ULib.cmds.round
}
test:help("Restarts the map in the given time.")