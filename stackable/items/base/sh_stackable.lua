ITEM.name = "Stackable"
ITEM.model = Model("models/props_junk/wood_crate001a.mdl")
ITEM.description = "Base"
ITEM.max = 10 -- Max amount of items at the stack

function ITEM:GetName()
	if self:GetData("amount", false) then
		return self.name.." ("..self:GetData("amount","")..")"
	else
		return self.name
	end
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		draw.SimpleText(
			item:GetData("amount", 1), "DermaDefault", w - 5, h - 5,
			color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black
		)
	end
end

ITEM.functions.combine = {
    OnRun = function(item, data)
        local i = ix.item.instances[data[1]]
        if i and i.uniqueID == item.uniqueID then
			local amount = item:GetData("amount", 1) + i:GetData("amount", 1)
			if amount > item.max then
				local client = item:GetOwner()
				client:Notify("You are trying stack more items that you can")
			end
			item:SetData("amount", math.min(amount, item.max))
			local difference = amount - item.max
			if difference > 0 then
				i:SetData("amount", difference)
			else
				i:Remove()
			end
        end
        return false
    end,
	OnCanRun = function()
		return true
	end
}

function ITEM:ReduceAmount()
	local amount = self:GetData("amount", 1)
	if amount > 0 then
		if (amount - 1) <= 0 then 
			return true
		end
		self:SetData("amount", amount - 1)
	end
	return false
end