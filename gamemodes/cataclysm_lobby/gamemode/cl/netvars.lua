// cataclysm - NETVARS CLIENT

net.Receive("cataclysm_NetVarUpdate", function()
	local var = net.ReadString()
	local val = net.ReadType()
	
	print("NETVAR UPDATE")
	print("DEBUG: (NET) cataclysm_NetVarUpdate " .. var .. " = " .. tostring(val))
	print("NETVAR UPDATE")

	networkVariables[var] = val
end)

net.Receive("cataclysm_FullNetVarUpdate", function()
	print("FULL NETVAR UPDATE")
	print("DEBUG: (NET) cataclysm_FullNetVarUpdate")
	print("FULL NETVAR UPDATE")

	networkVariables = net.ReadTable()
end)