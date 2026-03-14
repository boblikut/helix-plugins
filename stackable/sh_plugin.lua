local PLUGIN = PLUGIN

PLUGIN.name = "Stackable"
PLUGIN.author = "boblikut"
PLUGIN.description = "Base for stackable items"

function PLUGIN:CanPlayerDropItem(client, id)
	local item = ix.item.instances[id]
	if item and item.base == "base_stackable" then
		local amount = item:GetData("amount", 1)
		if amount == 1 then return true end
		item:SetData("amount", amount - 1)
		ix.item.Spawn(item.uniqueID, client)
		return false
	end
end
