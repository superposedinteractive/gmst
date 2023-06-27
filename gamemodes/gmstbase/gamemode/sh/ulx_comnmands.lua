local CATEGORY_NAME = "GMStation"

function ulx.restart(calling_ply, time)
	GMSTBase_RestartMap(time)
end

local restart = ulx.command(CATEGORY_NAME, "ulx restartmap", ulx.restart, "!restartmap")
restart:defaultAccess(ULib.ACCESS_ADMIN)
restart:help("Restarts the map in the given time.")

restart:addParam{
	type = ULib.cmds.NumArg,
	min = 10,
	max = 120,
	default = 10,
	hint = "time",
	ULib.cmds.round
}

function ulx.devmode(calling_ply)
	SV_GLOBALS.devmode = !SV_GLOBALS.devmode || false
	ulx.fancyLogAdmin(calling_ply, "#A has toggled devmode to #s", SV_GLOBALS.devmode && "on" || "off")
end

local devmode = ulx.command(CATEGORY_NAME, "ulx devmode", ulx.devmode, "!devmode")
devmode:defaultAccess(ULib.ACCESS_SUPERADMIN)
devmode:help("Toggles devmode.")

function ulx.copydiscord(calling_ply)
	if !calling_ply:IsPlayer() then return end
	calling_ply:SendLua([[SetClipboardText("https://discord.gg/EnadGnaAGm")]])
	PlayerMessage(calling_ply, "Copied discord link to clipboard.")
end

local copydiscord = ulx.command(CATEGORY_NAME, "ulx discord", ulx.copydiscord, "!discord")
copydiscord:defaultAccess(ULib.ACCESS_ALL)
copydiscord:help("Copies the discord link to your clipboard.")

function ulx.givemoney(calling_ply, target_ply, amount)
	if !target_ply:IsPlayer() then return end
	if !target_ply:Alive() then return end
	if !calling_ply:IsAdmin() then return end
	if !amount then return end
	target_ply:MoneyAdd(amount)
	ulx.fancyLogAdmin(calling_ply, "#A has given #T #scc", target_ply, amount)
end

local givemoney = ulx.command(CATEGORY_NAME, "ulx givemoney", ulx.givemoney, "!givemoney")

givemoney:addParam{
	type = ULib.cmds.PlayerArg,
	default = function(ply) return ply end,
	hint = "player"
}

givemoney:addParam{
	type = ULib.cmds.NumArg,
	default = 0,
	hint = "amount",
	max = 1000000,
	ULib.cmds.round
}

givemoney:defaultAccess(ULib.ACCESS_ADMIN)
givemoney:help("Gives the target player money.")


function ulx.reward(calling_ply, target_plys, rewards)
	rewards = string.Split(rewards, ",")
	local processed_rewards = {}
	for k, v in pairs(rewards) do
		local split = string.Split(v, "=")
		if #split != 2 then continue end
		local name = split[1]
		local amount = tonumber(split[2])
		if !amount then continue end
		table.insert(processed_rewards, {name, amount})
	end
	
	for k, v in pairs(target_plys) do
		v:Payout(processed_rewards)
	end
end

local reward = ulx.command(CATEGORY_NAME, "ulx reward", ulx.reward, "!reward")
reward:defaultAccess(ULib.ACCESS_ADMIN)
reward:addParam{
	type = ULib.cmds.PlayersArg,
	default = function(ply) return ply end,
	hint = "players"
}

reward:addParam{
	type = ULib.cmds.StringArg,
	hint = "rewards"
}

reward:help("Gives the target players rewards.")