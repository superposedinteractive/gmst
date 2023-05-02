local function IsGameInProgress()
    if !timer.Exists("rocketeers_timer") then return false end

    return true
end

local function GetGameTime()
    if !timer.Exists("rocketeers_timer") then return false end

    return timer.TimeLeft("rocketeers_timer")
end

local function CanStartGame()
    return !IsGameInProgress()
end

local function CanEndGame()
    return IsGameInProgress()
end

