// GMSTBase - NETVARS CLIENT
net.Receive("GMSTBase_NetVarUpdate", function()
	local var = net.ReadString()
	local val = net.ReadType()
	MsgN("[GMSTBase] Netvar update: " .. var .. " = " .. tostring(val))
	networkVariables[var] = val
end)

net.Receive("GMSTBase_FullNetVarUpdate", function()
	MsgN("[GMSTBase] Full netvar update received")
	networkVariables = net.ReadTable()
end)

function GMSTBase_RequestNetVars()
	net.Start("GMSTBase_GetNetVars")
	net.SendToServer()
end
