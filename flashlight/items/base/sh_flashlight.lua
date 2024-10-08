ITEM.name = "Flashlight"
ITEM.model = Model("models/items/healthkit.mdl")
ITEM.description = "Base"
ITEM.interval = 1

function ITEM:GetDescription()
	return self.description.."\nEnergy: "..self:GetData("energy", 100)
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 20, 8, 8)
		end
		local energy = item:GetData("energy", 100) / 100
		surface.SetDrawColor(255 * (1 - energy), 255 * energy, 0, 200)
		surface.DrawRect(2, h - 6, w * energy - 2, 4)
	end

	function ITEM:PopulateTooltip(tooltip)
		if (self:GetData("equip")) then
			local name = tooltip:GetRow("name")
			name:SetBackgroundColor(derma.GetColor("Success", tooltip))
		end
	end
end

ITEM:Hook("drop", function(item)
	local client = item.player
	local character = client:GetCharacter()
	local name = character.id.." flash timer"
	if timer.Exists(name) then
		item.LeftTime = timer.TimeLeft(name)
		timer.Remove(name)
	end
	client:Flashlight(false)
	item:SetData("equip", false)
	character.flashlight = nil
end)

ITEM.functions.EquipUn = {
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local name = item.id.." flash timer"
		item.LeftTime = timer.TimeLeft(name)
		timer.Remove(name)
		client:Flashlight(false)
		item:SetData("equip", false)
		character:SetData("flashlight", nil)
		item:SetData("equip", false)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false
	end
}

ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		item:SetData("equip", true)
		if !item:GetData("energy") then
			item:SetData("energy", 100)
		end
		item.player:GetCharacter():SetData("flashlight", item)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local energy = item:GetData("energy")
		return !IsValid(item.entity) and IsValid(client) and !character:GetData("flashlight", false) and item:GetData("equip") != true and (!energy or energy > 0) and
			hook.Run("CanPlayerEquipItem", client, item) != false
	end
}

ITEM.functions.combine = {
    OnRun = function(item, data)
        local another = ix.item.instances[data[1]]
        if another and another.base == "base_battery" then
	    item:SetData("energy", math.min(item:GetData("energy", 100) + another.amount, 100))
            if !another.isInfinite then
		another:Remove()
	    end
        end
        return false
    end,
	OnCanRun = function()
		return true
	end
}
