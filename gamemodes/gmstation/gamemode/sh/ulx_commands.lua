local CATEGORY_NAME = "GMStation"

function ulx.terms(calling_ply)
	if !calling_ply:IsPlayer() then return end

	calling_ply:SendLua("OpenTerms(true)")
end

local opentos = ulx.command(CATEGORY_NAME, "ulx terms", ulx.terms, "!terms")
opentos:defaultAccess(ULib.ACCESS_ALL)
opentos:help("Opens the terms of service for GMStation.")