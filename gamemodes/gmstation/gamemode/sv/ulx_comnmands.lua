local CATEGORY_NAME = "GMStation"

function ulx.test(calling_ply)
	ulx.fancyLogAdmin(calling_ply, "#A ran a test.")
end

local test = ulx.command(CATEGORY_NAME, "ulx test", ulx.test, "!test", true)
test:defaultAccess(ULib.ACCESS_ALL)
test:help("Test command.")
