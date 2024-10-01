local PLUGIN = PLUGIN

PLUGIN.name = "Generators pack"
PLUGIN.author = "boblikut"
PLUGIN.description = "Generators for factions, classes, items"

function ix.class.Generate(args)
	local CLASS = {} 
	local index = #ix.class.list + 1
	CLASS.index = index
	CLASS.limit = 0
	for k, v in pairs(args) do
		CLASS[k] = v
	end
	ix.class.list[index] = CLASS
	return CLASS
end

local CITIZEN_MODELS = {
	"models/humans/group01/male_01.mdl",
	"models/humans/group01/male_02.mdl",
	"models/humans/group01/male_04.mdl",
	"models/humans/group01/male_05.mdl",
	"models/humans/group01/male_06.mdl",
	"models/humans/group01/male_07.mdl",
	"models/humans/group01/male_08.mdl",
	"models/humans/group01/male_09.mdl",
	"models/humans/group02/male_01.mdl",
	"models/humans/group02/male_03.mdl",
	"models/humans/group02/male_05.mdl",
	"models/humans/group02/male_07.mdl",
	"models/humans/group02/male_09.mdl",
	"models/humans/group01/female_01.mdl",
	"models/humans/group01/female_02.mdl",
	"models/humans/group01/female_03.mdl",
	"models/humans/group01/female_06.mdl",
	"models/humans/group01/female_07.mdl",
	"models/humans/group02/female_01.mdl",
	"models/humans/group02/female_03.mdl",
	"models/humans/group02/female_06.mdl",
	"models/humans/group01/female_04.mdl"
}

function ix.faction.Generate(args)
    local FACTION = {}
    FACTION.models = CITIZEN_MODELS
    FACTION.index = table.Count(ix.faction.teams) + 1
    FACTION.color = ix.config.Get("color", Color(150, 125, 100, 255))
    FACTION.isDefault = false
    for k, v in pairs(args) do
	FACTION[k] = v
    end
    team.SetUp(FACTION.index, FACTION.name or "Unknown", FACTION.color)
    for _, v2 in pairs(FACTION.models) do
	if (isstring(v2)) then
		util.PrecacheModel(v2)
	elseif (istable(v2)) then
		util.PrecacheModel(v2[1])
	end
    end
    if (!FACTION.GetModels) then
	function FACTION:GetModels(client)
		return self.models
	end
    end
    ix.faction.indices[FACTION.index] = FACTION
    ix.faction.teams[FACTION.uniqueID] = FACTION
    _G[FACTION.enum] = FACTION.index
    return FACTION
end

function ix.item.Generate(uniqueID, base, args)
	local ITEM = ix.item.Register(uniqueID , "base_"..base, nil, nil, true )
	for k, v in pairs(args) do
		ITEM[k] = v
	end
end

--FIELDS TO FILL IN

local classes = {
	--{uniqueID = "lmao", name = "Lmao", faction = FACTION_CITIZEN}, 
	--{uniqueID = "cool_class", name = "Cool class", limit = 3, faction = FACTION_CITIZEN}
}

local factions = {
	--{uniqueID = "lmao_faction", name = "LMAO faction", enum = "FACTION_LMAO"},
	--{uniqueID = "gmans", name = "G - mans party", enum = "FACTION_GMANS", models = {"models/player/gman_high.mdl",},}
}

local items = {
--[[
	weapons = {
		physgun = {
			name = "Physgun",
			description = "Lmao gun",
			model = "models/weapons/w_Physics.mdl",
			class = "weapon_physgun",
			width = 2,
			height = 2,
		},
		gravitygun = {
			name = "Gravitygun",
			description = "Super Lmao Gun",
			model = "models/weapons/w_Physics.mdl",
			class = "weapon_physcannon",
			width = 2,
			height = 2,
		},
	},
	permits = {
		case = {
			name = "Nerd case",
			description = "This case only for nerds",
			model = "models/props_c17/SuitCase_Passenger_Physics.mdl",
			permit = "nerd"
		}
	}
]]
}

function PLUGIN:InitializedPlugins()
	for k, v in ipairs(classes) do
		ix.class.Generate(v)
	end
	for k, v in ipairs(factions) do
		ix.faction.Generate(v)
	end
	for base, based_items in pairs(items) do
		for uniqueID, item in pairs(based_items) do
			ix.item.Generate(uniqueID, base, item)
		end
	end
end
