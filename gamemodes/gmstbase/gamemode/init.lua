AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

bad_words = {
	["n1gger"] = "leet n-word",
	["n1gg3r"] = "leeter n-word",
	["nigg3r"] = "leet n-word",
	["nigger"] = "n-word",
	["niggers"] = "n-words",
	["n1ggers"] = "leet n-words",
	["n1gg3rs"] = "leeter n-words",
	["nigg3rs"] = "leet n-words",
	["bitch"] = "female dog",
	["b1tch"] = "leet female dog",
	["b1tch3s"] = "leeter female dogs",
	["bitch3s"] = "leet female dogs",
	["faggot"] = "butt pirate",
	["faggots"] = "butt pirates",
	["f4ggots"] = "leet butt pirates",
	["fag"] = "butt pirate",
	["f4g"] = "leet butt pirate",
	["fags"] = "butt pirates",
	["f4gs"] = "leet butt pirates",
	["f4g5"] = "leeter butt pirates",
	["kike"] = "businessman",
	["k1ke"] = "leet businessman",
	["k1k3"] = "leeter businessman",
	["kikes"] = "businessmen",
	["k1k3s"] = "leeter businessmen"
}

SV_GLOBALS = {}
SV_GLOBALS.url = "https://superposed.xyz/gmstation"
SV_GLOBALS.password = "651820566861d3bfe89ac8271aade105"

for k, v in ipairs(file.Find("gmstbase/gamemode/cl/*.lua", "LUA")) do
	MsgN("[GMSTBase] Adding " .. v .. " for client")
	AddCSLuaFile("cl/" .. v)
end

for k, v in ipairs(file.Find("gmstbase/gamemode/sv/*.lua", "LUA")) do
	MsgN("[GMSTBase] Loading " .. v)
	include("sv/" .. v)
end

MsgN("[GMSTBase] Server Loaded!")
resource.AddWorkshop("2966581862")
resource.AddFile("maps/gmst_lobby.bsp")