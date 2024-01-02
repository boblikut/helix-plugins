ITEM.name = "Money printer"
ITEM.model = "models/props_c17/consolebox03a.mdl"
ITEM.description = "Ilegal money priner, that can print money."
ITEM.width = 2
ITEM.height = 2
ITEM.PrinterEntity = "money_printer"

function ITEM:GetDescription()
if self:GetData("PrinterData", false) then
local data = self:GetData("PrinterData", false)
return string.format("%s\nMoney amount: %d\nPerfomance LVL: %d\nCooling LVL: %d", self.description, data["MoneyAmount"], data["CurrPerfLVL"], data["CurrWarmLVL"])
else
return self.description
end
end

ITEM.functions.Apply = {
	name = "Place",
	icon = "icon16/add.png",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local printer = ents.Create(item.PrinterEntity)
		if item:GetData("PrinterData", false) then
			printer:SetNetVar("PrinterData", item:GetData("PrinterData", false))
		end
		local ang = client:EyeAngles()
		local dir = ang:Forward()
		local SpawnPos = client:GetShootPos() + dir * 30
		printer:SetPos(SpawnPos)
		printer:Spawn()	
	end
}