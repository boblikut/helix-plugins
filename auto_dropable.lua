local PLUGIN = PLUGIN

PLUGIN.name = "Auto dropable"
PLUGIN.author = "boblikut"
PLUGIN.description = "Automaticaly set bDropOnDeath flag on items that you need"

--set bDropOnDeath flag on all items except that have this bases:
local base_list = {
base_weapon = true,
base_armor = true,
base_autfit = true,
base_writing = true
}

function PLUGIN:InitializedPlugins() 
	for _, v in pairs(ix.item.list) do
		if !base_list[v.base] then
			v.bDropOnDeath = true
		end
	end
end

