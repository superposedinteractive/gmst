// GMSTBase - NETVARS SERVER

util.AddNetworkString("GMSTBase_NetVarUpdate")
util.AddNetworkString("GMSTBase_FullNetVarUpdate")
util.AddNetworkString("GMSTBase_GetNetVars")

function GMSTBase_NetVarSet(var, value)
	if networkVariables[var] == nil then
		MsgN("ERROR: GMSTBase_NetVarSet - " .. var .. " is not a valid netvar!")
		return
	end

	if networkVariables[var] == value then
		MsgN("ERROR: GMSTBase_NetVarSet - " .. var .. " is already set to " .. tostring(value))
		return
	end

	MsgN("UPDATING A NETVAR")
	MsgN("DEBUG: GMSTBase_NetVarSet - " .. var .. " = " .. tostring(value))
	MsgN("UPDATING A NETVAR")
	networkVariables[var] = value

	net.Start("GMSTBase_NetVarUpdate")
		net.WriteString(var)
		net.WriteType(value)
	net.Broadcast()
end

net.Receive("GMSTBase_GetNetVars", function(len, ply)
	MsgN("DEBUG: (NET) GMSTBase_GetNetVars - " .. ply:Nick() .. " a full update of netvars.")
	net.Start("GMSTBase_FullNetVarUpdate")
		net.WriteTable(networkVariables)
	net.Send(ply)
end)