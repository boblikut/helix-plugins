local PLUGIN = PLUGIN

PLUGIN.name = "Faction colors"
PLUGIN.author = "boblikut"
PLUGIN.description = "Automaticaly set schema color for all factions"

function SetFactionsColor()
	for _, FACTION in ipairs(ix.faction.indices) do
		FACTION.color = ix.config.Get("color", Color(150, 125, 100, 255))
		team.SetUp(FACTION.index, FACTION.name or "Unknown", FACTION.color or Color(125, 125, 125))
	end
end

function PLUGIN:InitializedConfig()
	SetFactionsColor()
end
