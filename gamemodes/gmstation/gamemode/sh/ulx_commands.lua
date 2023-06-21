if SERVER then
	util.AddNetworkString("gmstation_announcement")
end

local CATEGORY_NAME = "GMStation"

function ulx.terms(calling_ply)
	if !calling_ply:IsPlayer() then return end
	calling_ply:SendLua("OpenTerms(true)")
end

local opentos = ulx.command(CATEGORY_NAME, "ulx terms", ulx.terms, "!terms")
opentos:defaultAccess(ULib.ACCESS_ALL)
opentos:help("Opens the terms of service for GMStation.")

function ulx.announcement(calling_ply, announcement)
	net.Start("gmstation_announcement")
	net.WriteString(announcement)
	net.Broadcast()
end

local announcement = ulx.command(CATEGORY_NAME, "ulx announcement", ulx.announcement, "!announcement")

announcement:addParam{
	type = ULib.cmds.StringArg,
	hint = "announcement",
	ULib.cmds.takeRestOfLine
}

announcement:defaultAccess(ULib.ACCESS_ADMIN)
announcement:help("Sends an announcement to all players.")
