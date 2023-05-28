local items = {}
game.AddParticles("particles/achievement.pcf")
PrecacheParticleSystem("achieved")
MsgN("[GMSTBase] Loading item definitions...")

timer.Simple(1, function()
	apiCall("item_list", {}, function(body)
		for i = 1, #body do
			local item = body[i]

			items[item.item_id] = {
				name = item.name,
				description = item.description,
				type = item.type,
				info = item.info,
				unobtainable = item.unobtainable,
				price = item.price,
				model = item.model
			}

			MsgN("[GMSTBase] Loaded item definition for " .. item.item_id)
		end

		if CLIENT then
			UpdateHats()
		end
	end)
end)

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
			price = 0,
			model = "error.mdl"
		}
	end

	return items[id]
end

concommand.Add("gmst_itemdump", function()
	PrintTable(items)
end, nil, "Dumps all item definitions to console", FCVAR_CHEAT)
