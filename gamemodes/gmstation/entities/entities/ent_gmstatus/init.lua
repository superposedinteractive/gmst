include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
util.AddNetworkString("gmstation_bulletin")
util.AddNetworkString("gmstation_queue")

function ENT:KeyValue(key, value)
	if key == "gamemode" then
		self.gamemode = value
	end
end

function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	net.Start("gmstation_bulletin")
		net.WriteString(self.gamemode || "rocketeers")
		net.WriteEntity(self)
	net.Send(activator)
end

net.Receive("gmstation_queue", function(len, ply)
	local ent = net.ReadEntity()
	if not IsValid(ent) then return end

	local gm = net.ReadString()
	if not gm then return end

	local queue = ent:GetQueue()
	if not queue then return end

	if queue[ply] then
		queue[ply] = nil
		return
	end

	queue[ply] = gm
end)