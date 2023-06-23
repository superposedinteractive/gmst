util.AddNetworkString("rocketeers_gameupdate")

local playerList = {}

function GetGameTime()
	if !timer.Exists("rocketeers_timer") then return false end

	return timer.TimeLeft("rocketeers_timer")
end

function IsGamein_progress()
	return timer.Exists("rocketeers_timer")
end

local function isEveryoneOn()
	return false
end

function ModifyGameTime(time)
	if !timer.Exists("rocketeers_timer") then return false end

	MsgN("[Rocketeers] Modifying game time to " .. time .. " seconds")
	timer.Adjust("rocketeers_timer", time)

	net.Start("rocketeers_gameupdate")
		net.WriteString("time")
		net.WriteFloat(GetGameTime())
	net.Broadcast()
end

function BeginGamemode(time)
	MsgN("[Rocketeers] Starting gamemode")

	timer.Adjust("rocketeers_timer", time)

	timer.Start("rocketeers_timer")

	net.Start("rocketeers_gameupdate")
		net.WriteString("start")
		net.WriteFloat(GetGameTime())
	net.Broadcast()
end

// API CALL
function GMSTBase_InitialSpawn(ply)
	MsgN("[Rocketeers] Initialising " .. ply:Nick())
	ply:Freeze(true)
end

timer.Create("rocketeers_timer", 0, 1, function()
	MsgN("[Rocketeers] Game timer has ended")
end)

timer.Stop("rocketeers_timer")