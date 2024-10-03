local PLUGIN = PLUGIN

PLUGIN.name = "Flashlight"
PLUGIN.author = "boblikut"
PLUGIN.description = "Flashlight plugin"

local flashlights = {
	example_flash = {
		name = "Flashlight",
		description = "Regular flashlight",
		model = "models/props_lab/desklamp01.mdl",
		interval = 1 -- how often flashlight energy decrease
	}
}

local batteries = {
	example_battery = {
		name = "Battery",
		description = "Regular battery",
		model = "models/Items/battery.mdl",
		amount = 50 -- how many energy will get flashlight if use it on this flashlight
	}
}

function PLUGIN:InitializedPlugins()
	for k,v in pairs(flashlights) do
		local ITEM = ix.item.Register( k, "base_flashlight", nil, nil, true )
		ITEM.name = v.name or "Flashlight"
		ITEM.description = v.description or "Regular flashlight"
		ITEM.model = v.model or "models/items/healthkit.mdl"
		ITEM.interval = v.interval or 10
		ITEM.width = v.width or 1
		ITEM.height = v.height or 1
	end
	for k,v in pairs(batteries) do
		local ITEM = ix.item.Register( k, "base_battery", nil, nil, true )
		ITEM.name = v.name or "Battery"
		ITEM.description = v.description or "Regular battery"
		ITEM.model = v.model or "models/items/healthkit.mdl"
		ITEM.amount = v.amount or 50
		ITEM.width = v.width or 1
		ITEM.height = v.height or 1
	end
end

ix.util.Include("sv_plugin.lua")