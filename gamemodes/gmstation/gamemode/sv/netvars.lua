// gmstation - NETVARS SERVER

util.AddNetworkString("gmstation_NetVarUpdate")
util.AddNetworkString("gmstation_FullNetVarUpdate")
util.AddNetworkString("gmstation_GetNetVars")

function gmstation_NetVarSet(var, value)
	if networkVariables[var] == nil then
		MsgN("ERROR: gmstation_NetVarSet - " .. var .. " is not a valid netvar!")
		return
	end

	if networkVariables[var] == value then
		MsgN("ERROR: gmstation_NetVarSet - " .. var .. " is already set to " .. tostring(value))
		return
	end

	print("UPDATING A NETVAR")
	print("DEBUG: gmstation_NetVarSet - " .. var .. " = " .. tostring(value))
	print("UPDATING A NETVAR")
	networkVariables[var] = value

	net.Start("gmstation_NetVarUpdate")
		net.WriteString(var)
		net.WriteType(value)
	net.Broadcast()
end

net.Receive("gmstation_GetNetVars", function(len, ply)
	print("DEBUG: (NET) gmstation_GetNetVars - " .. ply:Name() .. " a full update of netvars.")
	net.Start("gmstation_FullNetVarUpdate")
		net.WriteTable(networkVariables)
	net.Send(ply)
end)