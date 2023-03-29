// GMStation - NETVARS CLIENT

net.Receive("gmstation_NetVarUpdate", function()
	local var = net.ReadString()
	local val = net.ReadType()
	
	print("NETVAR UPDATE")
	print("DEBUG: (NET) gmstation_NetVarUpdate " .. var .. " = " .. tostring(val))
	print("NETVAR UPDATE")

	networkVariables[var] = val
end)

net.Receive("gmstation_FullNetVarUpdate", function()
	print("FULL NETVAR UPDATE")
	print("DEBUG: (NET) gmstation_FullNetVarUpdate")
	print("FULL NETVAR UPDATE")

	networkVariables = net.ReadTable()
end)