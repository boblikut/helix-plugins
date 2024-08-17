local PLUGIN = PLUGIN

PLUGIN.name = "Auto dropable"
PLUGIN.author = "boblikut"
PLUGIN.description = "Automaticaly set bDropOnDeath flag on items that you need"

--set bDropOnDeath flag on all items except that have this bases:
local base_list = {
base_weapon = true,
base_armor = true,
base_outfit = true,
base_writing = true
}

--and except this items:
local item_list = {
	flashlight = true,
	pda = true
}

function PLUGIN:InitializedPlugins() 
	for _, v in pairs(ix.item.list) do
		if !base_list[v.base] and !item_list[v.uniqueID] then
			v.bDropOnDeath = true
		end
	end
end

