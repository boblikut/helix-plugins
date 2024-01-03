ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Money Printer"
ENT.Description = "Ilegal money priner, that can print money."
ENT.Spawnable = true
ENT.PrinterSound = "ambient/levels/labs/equipment_printer_loop1.wav"
ENT.PrinterModel = "models/props_c17/consolebox03a.mdl"
ENT.PrinterInterval = 0.75
ENT.WarmInterval = 1
ENT.ColdInterval = 1
ENT.EnergyInterval = 0.1
ENT.PerfomanceUpgades = {
{profit = 100},
{profit = 200, price = 500},
{profit = 300, price = 1000}
}
ENT.WarmUpgades = {
{WarmSpeed = 5},
{WarmSpeed = 3, price = 500},
{WarmSpeed = 1, price = 1000}
}
ENT.RebootPrice = 500
ENT.ReturnItem = "printer_exemple"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "MoneyAmount")
	self:NetworkVar("Int", 2, "CurrPerfLVL")
	self:NetworkVar("Bool", 1, "IsWorking")
	self:NetworkVar("Int", 3, "Warm")
	self:NetworkVar("Int", 4, "CurrWarmLVL")
	self:NetworkVar("Int", 5, "Energy")
end
