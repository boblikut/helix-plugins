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
		local client = itemTable.player
		client:RequestString("Radio panel", "Enter frequency:", function(text)
			local reg = string.match(text, "^%d%d%.%d%d%d$")
			if reg then
				itemTable:SetData("frequency", reg)
				client:Notify("You changed frequency of handheld radio on "..reg.."!")
			else
				client:Notify("You typed incorect frequency!")
			end
		end, itemTable:GetData("frequency", "00.000"))
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
			local b = !itemTable:GetData("enabled", false)
			itemTable:SetData("enabled", b)
			itemTable.player:EmitSound("buttons/lever7.wav", 50, math.random(170, 180), 0.25)
			if b then
				itemTable.player.isRadioHearing = true
			else
				itemTable.player.isRadioHearing = false
			end
		else
			itemTable.player:NotifyLocalized("radioAlreadyOn")
		end

		return false
	end
}
