local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character, oldChar)
	character:SetData("flashlight", nil)
	if !oldChar then return end
	local name = oldChar.id.." flash timer"
	local item = oldChar:GetData("flashlight", false)
	if item and timer.Exists(name) then
		item.LeftTime = timer.TimeLeft(name)
		timer.Remove(name)
	end
	client:Flashlight(false)
end

function PLUGIN:PlayerSwitchFlashlight(client, b)
	local character = client:GetCharacter()
	if !character then return end
	if !b then
		local item = character:GetData("flashlight", false)
		local name = character.id.." flash timer"
		if item and timer.Exists(name) then
			item.LeftTime = timer.TimeLeft(name)
			timer.Remove(name)
		end
		return true
	end
	local inventory = character:GetInventory()
	for item in inventory:Iter() do
		if item.base == "base_flashlight" and item:GetData("equip", false) then
			local name = character.id.." flash timer"
			timer.Create(name, item.interval, 0, function()
				timer.Adjust(name, item.interval)
				local energy = item:GetData("energy")
				energy = energy - 1
				item:SetData("energy", energy)
				if energy <= 0 then
					item:SetData("equip", false)
					client:Flashlight(false)
					timer.Remove(name)
					character:SetData("flashlight", nil)
				end
			end)
			if item.LeftTime then
				timer.Adjust(name, item.LeftTime)
				item.LeftTime = nil
			end
			return true
		end
	end
	return false
end