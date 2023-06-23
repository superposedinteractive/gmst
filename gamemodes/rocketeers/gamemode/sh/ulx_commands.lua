local CATEGORY_NAME = "GMStation"

function ulx.beginGamemode(calling_ply, time)
	if type(time) ~= "number" then return end

	MsgN("Beginning gamemode in " .. time .. " seconds.")

	BeginGamemode(time)
end

local beginGamemode = ulx.command(CATEGORY_NAME, "ulx begingamemode", ulx.beginGamemode, "!begingamemode")

beginGamemode:addParam{
	type = ULib.cmds.NumArg,
	min = 30,
	max = 300,
	default = 60,
	hint = "time",
	ULib.cmds.round
}

beginGamemode:defaultAccess(ULib.ACCESS_SUPERADMIN)
beginGamemode:help("Begin the gamemode.")