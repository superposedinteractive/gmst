local items = {}
game.AddParticles("particles/achievement.pcf")
PrecacheParticleSystem("achieved")

function GMSTBase_RetreiveItems()
	MsgN("[GMSTBase] Loading item definitions...")

	apiCall("item_list", {}, function(body)
		for i = 1, #body do
			local item = body[i]

			items[item.item_id] = {
				name = item.name,
				description = item.description,
				type = item.type,
				info = item.info,
				unobtainable = item.unobtainable == 1,
				vip = item.vip == 1,
				tradeable = item.tradeable == 1,
				sellable = item.sellable == 1,
				price = item.price,
				model = item.model
			}

			MsgN("[GMSTBase] Loaded item definition for " .. item.item_id)
		end

		if CLIENT then
			timer.Simple(1, function()
				UpdateHats()
			end)
		end
	end)
end

function GMSTBase_GetItems()
	MsgN("[GMSTBase] Requested item list")
	local ids = {}

	for k, v in pairs(items) do
		table.insert(ids, k)
	end

	return ids
end

function GMSTBase_GetItemInfo(id)
	MsgN("[GMSTBase] Requested item info for " .. id)

	if !items[id] then
		MsgN("[GMSTBase] Item info for " .. id .. " not found!")

		return {
			name = "Unknown",
			description = "Unknown",
			type = "Unknown",
			info = "Unknown",
			unobtainable = true,
			vip = false,
			tradeable = false,
			sellable = false,
			price = 0,
			model = "error.mdl"
		}
	end

	return items[id]
end

concommand.Add("gmst_itemdump", function()
	PrintTable(items)
end, nil, "Dumps all item definitions to console", FCVAR_CHEAT)

concommand.Add("gmst_refreshitems", function()
	GMSTBase_RetreiveItems()
end, nil, "Refreshes the item definitions")

if SERVER then
	hook.Add("PlayerConnect", "GMSTBase_LoadItems", function()
		GMSTBase_RetreiveItems()
	end)
elseif CLIENT then
	hook.Add("InitPostEntity", "GMSTBase_LoadItems", function()
		GMSTBase_RetreiveItems()
		FetchInfo()
	end)

	hook.Add("OnReloaded", "GMSTBase_LoadItems", function()
		GMSTBase_RetreiveItems()
		FetchInfo()
	end)
end