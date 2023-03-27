// cataclysm - NETVARS SERVER

util.AddNetworkString("cataclysm_NetVarUpdate")
util.AddNetworkString("cataclysm_FullNetVarUpdate")
util.AddNetworkString("cataclysm_GetNetVars")

function cataclysm_NetVarSet(var, value)
	if networkVariables[var] == nil then
		MsgN("ERROR: cataclysm_NetVarSet - " .. var .. " is not a valid netvar!")
		return
	end

	if networkVariables[var] == value then
		MsgN("ERROR: cataclysm_NetVarSet - " .. var .. " is already set to " .. tostring(value))
		return
	end

	print("UPDATING A NETVAR")
	print("DEBUG: cataclysm_NetVarSet - " .. var .. " = " .. tostring(value))
	print("UPDATING A NETVAR")
	networkVariables[var] = value

	net.Start("cataclysm_NetVarUpdate")
		net.WriteString(var)
		net.WriteType(value)
	net.Broadcast()
end

net.Receive("cataclysm_GetNetVars", function(len, ply)
	print("DEBUG: (NET) cataclysm_GetNetVars - " .. ply:Nick() .. " a full update of netvars.")
	net.Start("cataclysm_FullNetVarUpdate")
		net.WriteTable(networkVariables)
	net.Send(ply)
end)