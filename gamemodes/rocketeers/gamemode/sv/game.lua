function IsGameInProgress()
	if timer.Exists("rocketeers_timer") then return true end
	return false
end

local function GetGameTime()
	if !timer.Exists("rocketeers_timer") then return false end

	return timer.TimeLeft("rocketeers_timer")
end