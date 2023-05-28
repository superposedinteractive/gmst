local playerList = {}

function GetGameTime()
	if !timer.Exists("rocketeers_timer") then return false end

	return timer.TimeLeft("rocketeers_timer")
end

function IsGameInProgress()
	return timer.Exists("rocketeers_timer")
end

local function isEveryoneOn()
	return false
end

// API CALL
function GMSTBase_InitialSpawn(ply)
	MsgN("[Rocketeers] Initialising " .. ply:Nick())
	ply:Freeze(true)
end
