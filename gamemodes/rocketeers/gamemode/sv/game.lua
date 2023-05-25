local playerList = {}

function IsGameInProgress()
	if timer.Exists("rocketeers_timer") then return true end
	return false
end

local function GetGameTime()
	if !timer.Exists("rocketeers_timer") then return false end

	return timer.TimeLeft("rocketeers_timer")
end

function GMSTInitialSpawn(ply)
	// if !GMSTPlayerIsWhitelisted(ply, "rocketeers") then return end
	MsgN("[Rocketeers] Initialising " .. ply:Nick())
end