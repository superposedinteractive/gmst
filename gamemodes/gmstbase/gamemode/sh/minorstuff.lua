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
				desc = item.desc,
				type = item.type,
				info = item.info,
				unobtainable = item.unobtainable,
				price = item.price,
				model = item.model
			}
			MsgN("[GMSTBase] Loaded item definition for " .. item.item_id)
		end
	end)
end)

function GMSTBase_GetItemInfo(id)
	MsgN("[GMSTBase] Requested item info for " .. id)
	if not items[id] then
		MsgN("[GMSTBase] Item info for " .. id .. " not found!")
		return false
	end
	return items[id]
end