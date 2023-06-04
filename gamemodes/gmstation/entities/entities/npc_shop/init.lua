util.AddNetworkString("gmstation_store")
util.AddNetworkString("gmstation_purchased")
include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	self:SetModel("models/humans/group01/female_02.mdl")
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD)
end

function ENT:KeyValue(key, value)
	self[key] = value
	MsgN("GMStation: ", key, " = ", value)
end

function ENT:Use(activator, caller, useType, value)
	if activator:IsPlayer() then
		net.Start("gmstation_store")
		net.WriteString(self.store || "unknown")
		net.WriteString(self.message || "Welcome!")
		net.WriteString(self.exitMessage || "Goodbye!")
		net.Send(activator)
	end
end

net.Receive("gmstation_store", function(len, ply)
	local items = net.ReadTable()

	local total = 0

	for k, v in pairs(items) do
		local item = GMSTBase_GetItemInfo(k)
		if item then
			total = total + item.price * v
		end
	end

	for k, v in pairs(items) do
		items[k] = math.floor(v)
	end

	ply:UpdateInfo(function()
		if ply:CanAfford(total) then
			apiCall("store_purchase", {password = SV_GLOBALS["password"], steamid = ply:SteamID64(), ["items"] = util.TableToJSON(items)}, function(data)
				if data.success then
					MsgN("[GMStation] ", ply:Nick(), " purchased items for " .. total .. "cc.")
					ply:MoneyAdd(-total)
				end
			end)

			net.Start("gmstation_purchased")
			net.Send(ply)
		else
			MsgN("[GMStation] ", ply:Nick(), " tried to purchase items for " .. total .. "cc, but they only have " .. ply:GetMoney() .. "cc.")
			PlayerMessage(ply, "You don't have enough money to purchase these items!")
		end
	end)
end)