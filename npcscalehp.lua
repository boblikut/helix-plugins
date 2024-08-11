local PLUGIN = PLUGIN

PLUGIN.name = "NPC HP Scale"
PLUGIN.author = "boblikut"
PLUGIN.description = "Scale NPC HP when they spawn"

local scale = 2 -- scale amount

function PLUGIN:PlayerSpawnedNPC(client, npc)
	npc:SetMaxHealth(npc:GetMaxHealth() * scale)
	npc:SetHealth(npc:GetMaxHealth())
end
