ITEM.name = "Radio"
ITEM.model = Model("models/props_junk/wood_crate001a.mdl")
ITEM.description = "Base"

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("enabled")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

function ITEM:GetDescription()
	local enabled = self:GetData("enabled")
	return string.format(self.description, enabled and "on" or "off", self:GetData("frequency", "00.000"))
end

ITEM:Hook("drop", function(item)
	item:SetData("enabled", false)
end)

ITEM.functions.Frequency = {
	OnRun = function(itemTable)
		if !SERVER then return end
		net.Start("FrequencyRequest")
		net.WriteString(itemTable:GetData("frequency", "00.000"))
		net.WriteInt(itemTable:GetID(), 32)
		net.Send(itemTable.player)
		return false
	end
}

ITEM.functions.Toggle = {
	OnRun = function(itemTable)
		local character = itemTable.player:GetCharacter()
		local radios = character:GetInventory():GetItemsByBase("base_radio", true)
		local bCanToggle = true

		if (#radios > 1) then
			for k, v in ipairs(radios) do
				if (v != itemTable and v:GetData("enabled", false)) then
					bCanToggle = false
					break
				end
			end
		end

		if (bCanToggle) then
			itemTable:SetData("enabled", !itemTable:GetData("enabled", false))
			itemTable.player:EmitSound("buttons/lever7.wav", 50, math.random(170, 180), 0.25)
		else
			itemTable.player:NotifyLocalized("radioAlreadyOn")
		end

		return false
	end
}