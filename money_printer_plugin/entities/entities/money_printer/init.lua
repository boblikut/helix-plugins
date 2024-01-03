AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

local interval = ENT.PrinterInterval
local warm_interval = ENT.WarmInterval
local cold_interval = ENT.ColdInterval
local energy_interval = ENT.EnergyInterval

local lastUse = 0

local function checkDelay()    
    if CurTime() > lastUse then
        return true
    else
        return false
    end
end

local function setDelay(delay)
    lastUse = CurTime() + delay
end 

local function DoExposion(pos)
local explosion = ents.Create("env_explosion")
    explosion:SetPos(pos)
	explosion:Spawn()
	explosion:SetKeyValue("iMagnitude", "90")
	explosion:Fire("Explode",0,0)
end

util.AddNetworkString("PrinterHUD")
util.AddNetworkString("TakeMoney")
util.AddNetworkString("PerfUpgrade")
util.AddNetworkString("CloseDermaOnDeath")
util.AddNetworkString("OffOn")
util.AddNetworkString("WarmUpgrade")
util.AddNetworkString("Take")
util.AddNetworkString("GetPrinterData")
util.AddNetworkString("Reboot")

function ENT:Initialize()
	self:SetModel(self.PrinterModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	self.timer = CurTime()
	self.warm_timer = CurTime()
	self.energy_timer = CurTime()
	self.healths = self.PrinterHealths
	self:SetCurrPerfLVL(1)
	self:SetCurrWarmLVL(1)
	self:SetIsWorking(true)
	self:SetWarm(0)
	self:SetEnergy(100)
	
	if self:GetNetVar("PrinterData", false) then
		local printer_data_from_item = self:GetNetVar("PrinterData", false)
		self:SetCurrPerfLVL(printer_data_from_item["CurrPerfLVL"])
		self:SetCurrWarmLVL(printer_data_from_item["CurrWarmLVL"])
		self:SetMoneyAmount(printer_data_from_item["MoneyAmount"])
		self:SetWarm(printer_data_from_item["Warm"])
		self:SetEnergy(printer_data_from_item["Energy"])
	end
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:Wake()
	end
	
	self:EmitSound( self.PrinterSound, 75, 100, 0.3) 
end

function ENT:Think()

if (CurTime() > (self.timer + interval)) and self:GetIsWorking()  and self:GetEnergy() > 0 then
	self.timer = CurTime()	
	self:SetMoneyAmount(self:GetMoneyAmount() + self.PerfomanceUpgades[self:GetCurrPerfLVL()].profit)
end

if (CurTime() > (self.warm_timer + warm_interval)) and self:GetIsWorking()  and self:GetEnergy() > 0 then
	self.warm_timer = CurTime()	
	self:SetWarm(math.min(self:GetWarm() + self.WarmUpgades[self:GetCurrWarmLVL()].WarmSpeed, 100))
end

if !self:GetIsWorking() and (CurTime() > (self.warm_timer + cold_interval)) then
	self.warm_timer = CurTime()
	self:SetWarm(math.max(self:GetWarm() - self.WarmUpgades[1].WarmSpeed, 0))
end

if self:GetIsWorking() and self:GetEnergy() > 0 and (CurTime() > self.energy_timer + energy_interval) then
	self.energy_timer = CurTime()
	self:SetEnergy(self:GetEnergy() - 1)
end

if self:GetWarm() == 100 then
	self.ShouldBoom = true
	self:Remove()
end

if self:GetEnergy() == 0 then
	self:StopSound(self.PrinterSound)
end

end

function ENT:OnTakeDamage(dmg)
self.healths = self.healths - dmg:GetDamage()
if self.healths <= 0 then
self.ShouldBoom = true
self:Remove()
end
end

function ENT:Use(activator, caller)
if checkDelay() then
	net.Start("PrinterHUD")
	net.WriteEntity(self)
	net.Send(activator)
	setDelay(0.5)
end
end

function ENT:OnRemove()
	self:StopSound(self.PrinterSound)
	if self.ShouldBoom then
		DoExposion(self:GetPos())
	end
end

net.Receive("TakeMoney", function(lengh, client)
local ent = net.ReadEntity()
if !client.delay_mp or client.delay_mp < CurTime() then
if ent:GetPos():Distance(client:GetPos()) > 200 and client:GetEyeTrace().Entity == ent then return end
client:Notify("You took "..ent:GetMoneyAmount().." tokens from money printer")
local character = client:GetCharacter()
character:SetMoney(ent:GetMoneyAmount() + character:GetMoney())
ent:SetMoneyAmount(0)
client.delay_mp = CurTime() + 1
end
end)

net.Receive("PerfUpgrade", function(lengh, client)
local ent = net.ReadEntity()
if !client.delay_mp or client.delay_mp < CurTime() then
if ent:GetPos():Distance(client:GetPos()) > 200 and client:GetEyeTrace().Entity == ent then return end
local character = client:GetCharacter()
if ent.PerfomanceUpgades[ent:GetCurrPerfLVL() + 1] and (character:GetMoney() >= ent.PerfomanceUpgades[ent:GetCurrPerfLVL() + 1].price) then
	ent:SetCurrPerfLVL(ent:GetCurrPerfLVL() + 1)
	character:SetMoney(character:GetMoney() - ent.PerfomanceUpgades[ent:GetCurrPerfLVL()].price)
	client:Notify("You have upgraded perfomance to LVL "..ent:GetCurrPerfLVL())
elseif ent.PerfomanceUpgades[ent:GetCurrPerfLVL() + 1] then
client:Notify("You haven't enough money to do this upgrade!")
else
	client:Notify("You already have max LVL of perfomance!")
end
client.delay_mp = CurTime() + 1
end
end)

net.Receive("OffOn", function(lengh, client)
local ent = net.ReadEntity()
if !client.delay_mp or client.delay_mp < CurTime() then
if ent:GetPos():Distance(client:GetPos()) > 200 and client:GetEyeTrace().Entity == ent then return end
if ent:GetIsWorking() then
ent:SetIsWorking(false)
ent:StopSound(ent.PrinterSound)
else
ent:SetIsWorking(true)
ent:EmitSound(ent.PrinterSound, 75, 100, 0.3)
end
client.delay_mp = CurTime() + 1
end
end)

net.Receive("WarmUpgrade", function(lengh, client)
if !client.delay_mp or client.delay_mp < CurTime() then
if ent:GetPos():Distance(client:GetPos()) > 200 and client:GetEyeTrace().Entity == ent then return end
local ent = net.ReadEntity()
local character = client:GetCharacter()
if ent.WarmUpgades[ent:GetCurrWarmLVL() + 1] and (character:GetMoney() >= ent.WarmUpgades[ent:GetCurrWarmLVL() + 1].price) then
	ent:SetCurrWarmLVL(ent:GetCurrWarmLVL() + 1)
	character:SetMoney(character:GetMoney() - ent.WarmUpgades[ent:GetCurrWarmLVL()].price)
	client:Notify("You have upgraded cooling to LVL "..ent:GetCurrWarmLVL())
elseif ent.WarmUpgades[ent:GetCurrWarmLVL() + 1] then
client:Notify("You haven't enough money to do this upgrade!")
else
	client:Notify("You already have max LVL of cooling!")
end
client.delay_mp = CurTime() + 1
end
end)

net.Receive("Take", function(lengh, client)
local ent = net.ReadEntity()
if !client.delay_mp or client.delay_mp < CurTime() then
if ent:GetPos():Distance(client:GetPos()) > 200 and client:GetEyeTrace().Entity == ent then return end
local character = client:GetCharacter()
local inventory = character:GetInventory()
client:Notify("Printer was added to your inventory")
local x,y = inventory:Add(ent.ReturnItem)
local item = inventory:GetItemAt(x, y)
local printer_data = {
MoneyAmount = ent:GetMoneyAmount(),
CurrPerfLVL = ent:GetCurrPerfLVL(),
CurrWarmLVL = ent:GetCurrWarmLVL(),
Warm = ent:GetWarm(),
Energy = ent:GetEnergy()
}
item:SetData("PrinterData", printer_data)
ent:Remove()
client.delay_mp = CurTime() + 1
end
end)

net.Receive("Reboot", function(lengh, client)
local ent = net.ReadEntity()
if !client.delay_mp or client.delay_mp < CurTime() then
if ent:GetPos():Distance(client:GetPos()) > 200 and client:GetEyeTrace().Entity == ent then return end
local character = client:GetCharacter()
if character:GetMoney() >= ent.RebootPrice then
	client:Notify("You rebooted the printer!")
	ent:SetEnergy(100)
	ent:StopSound(ent.PrinterSound)
	ent:EmitSound(ent.PrinterSound, 75, 100, 0.3)
	ent:SetIsWorking(true)
else
	client:Notify("You haven't enough money to buy this")
end
client.delay_mp = CurTime() + 1
end
end)
