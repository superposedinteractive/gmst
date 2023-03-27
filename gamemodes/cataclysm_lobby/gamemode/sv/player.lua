// cataclysm - Player manager

function GM:PlayerSpawn(ply)
	ply:SetModel(ply:GetInfo("cl_playermodel"))
	ply:SetPlayerColor(Vector(ply:GetInfo("cl_playercolor")))
	ply:SetupHands()
	ply:UnSpectate()
	ply:CrosshairEnable()
end