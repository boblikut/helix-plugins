include("shared.lua")

function ENT:Draw()

	self:DrawModel()

end

ENT.PopulateEntityInfo = true

local COLOR_UNLOCKED = Color(135, 211, 124, 200)

function ENT:OnPopulateEntityInfo(tooltip)
	local ply = LocalPlayer()
	surface.SetFont("ixIconsSmall")

	if (tooltip:IsMinimal()) then
		local icon = tooltip:AddRow("icon")
		icon:SetFont("ixIconsSmall")
		icon:SetTextColor(COLOR_UNLOCKED)
		icon:SetText("L")
		icon:SizeToContents()
	end

	local title = tooltip:AddRow("name")
	title:SetImportant()
	title:SetText(self.PrintName)
	title:SetBackgroundColor(ix.config.Get("color"))
	title:SizeToContents()

	local subtitle = tooltip:AddRow("desc")
	subtitle:SetText(self.Description)
	subtitle:SetBackgroundColor(Color(0,0,0,255))
	subtitle:SizeToContents()
	
	if (!tooltip:IsMinimal()) then
		title.Paint = function(panel, width, height)
			panel:PaintBackground(width, height)

			surface.SetFont("ixIconsSmall")
			surface.SetTextColor(COLOR_UNLOCKED)
			surface.SetTextPos(4, height * 0.5)
		end
	end
end

net.Receive("PrinterHUD", function()
local ent = net.ReadEntity()
local ply = LocalPlayer()
local frame = vgui.Create("DFrame")
	frame:SetSize(800,600)
	frame:Center()
	frame:SetVisible(true)
	frame:SetTitle(ent.PrintName)
	frame:MakePopup()
local TakeMoneyBtn = vgui.Create("DButton", frame)
	TakeMoneyBtn:SetPos(550,50)
	TakeMoneyBtn:SetSize(200,50)
	TakeMoneyBtn:SetText("Take money")
	function TakeMoneyBtn:DoClick()
	net.Start("TakeMoney")
	net.WriteEntity(ent)
	net.SendToServer()
	end
local MoneyCount = vgui.Create("DLabel", frame)
	MoneyCount:SetPos(50,50)
	MoneyCount:SetSize(500,50)
	MoneyCount:SetFont("CloseCaption_Bold")
	hook.Add( "Think", "MoneyCounter"..ply:Nick(), function()
		MoneyCount:SetText("Current money amount: "..ent:GetMoneyAmount())
	end )
local PerfUpgradeBtn = vgui.Create("DButton", frame)
	PerfUpgradeBtn:SetPos(550,150)
	PerfUpgradeBtn:SetSize(200,50)
	hook.Add( "Think", "PerfUpgradeBtn Text Update"..ply:Nick(), function()
	if ent.PerfomanceUpgades[ent:GetCurrPerfLVL() + 1] == nil then
		PerfUpgradeBtn:SetText("You have max LVL of perfomence")
	else
		PerfUpgradeBtn:SetText("Perfomance Upgrade(LVL "..(ent:GetCurrPerfLVL() + 1)..") - "..ent.PerfomanceUpgades[ent:GetCurrPerfLVL() + 1].price.." tokens")
	end
	end)
	function PerfUpgradeBtn:DoClick()
	net.Start("PerfUpgrade")
	net.WriteEntity(ent)
	net.SendToServer()
	end
local OffOnBtn = vgui.Create("DButton", frame)
	OffOnBtn:SetPos(550,450)
	OffOnBtn:SetSize(200,50)
	hook.Add( "Think", "OffOnBtn Text Update"..ply:Nick(), function()
	if ent:GetIsWorking() then
		OffOnBtn:SetText("Off")
	else
		OffOnBtn:SetText("On")
	end
	end)
	function OffOnBtn:DoClick()
	net.Start("OffOn")
	net.WriteEntity(ent)
	net.SendToServer()
	end
local WarmUpgradeBtn = vgui.Create("DButton", frame)
	WarmUpgradeBtn:SetPos(550,250)
	WarmUpgradeBtn:SetSize(200,50)
	hook.Add( "Think", "WarmUpgradeBtn Text Update"..ply:Nick(), function()
	if ent.PerfomanceUpgades[ent:GetCurrWarmLVL() + 1] == nil then
		WarmUpgradeBtn:SetText("You have max LVL of cooling")
	else
		WarmUpgradeBtn:SetText("Cooling Upgrade(LVL "..(ent:GetCurrWarmLVL() + 1)..") - "..ent.WarmUpgades[ent:GetCurrWarmLVL() + 1].price.." tokens")
	end
	end)
	function WarmUpgradeBtn:DoClick()
	net.Start("WarmUpgrade")
	net.WriteEntity(ent)
	net.SendToServer()
	end
local TakeBtn = vgui.Create("DButton", frame)
	TakeBtn:SetPos(550,350)
	TakeBtn:SetSize(200,50)
	TakeBtn:SetText("Take printer")
	function TakeBtn:DoClick()
	net.Start("Take")
	net.WriteEntity(ent)
	net.SendToServer()
	frame:Close()
	end
local WarmLabel = vgui.Create("DLabel", frame)
	WarmLabel:SetPos(50,150)
	WarmLabel:SetSize(500,50)
	WarmLabel:SetFont("CloseCaption_Bold")
	hook.Add( "Think", "WarmCounter"..ply:Nick(), function()
		WarmLabel:SetText("Warm: "..ent:GetWarm().." %")
	end )
	
frame.PaintOver = function( self, w, h )
  if ( LocalPlayer():Alive()  ) then return end
  self:Remove()
end

local EnergyCount = vgui.Create("DLabel", frame)
	EnergyCount:SetPos(50,250)
	EnergyCount:SetSize(500,50)
	EnergyCount:SetFont("CloseCaption_Bold")
	hook.Add( "Think", "EnergyCounter"..ply:Nick(), function()
		EnergyCount:SetText("Energy: "..ent:GetEnergy().." %")
	end )
local RebootBtn = vgui.Create("DButton", frame)
	RebootBtn:SetPos(300,450)
	RebootBtn:SetSize(200,50)
	RebootBtn:SetText("Reboot - "..ent.RebootPrice.." $")
	function RebootBtn:DoClick()
	net.Start("Reboot")
	net.WriteEntity(ent)
	net.SendToServer()
	end
function frame:OnClose()
	hook.Remove( "Think", "Close on death"..ply:Nick())
	hook.Remove("Think", "MoneyCounter"..ply:Nick())
	hook.Remove("Think", "PerfUpgradeBtn Text Update"..ply:Nick())
	hook.Remove( "Think", "OffOnBtn Text Update"..ply:Nick())
	hook.Remove( "Think", "WarmUpgradeBtn Text Update"..ply:Nick())
	hook.Remove( "Think", "WarmCounter"..ply:Nick())
	hook.Remove("Think", "EnergyCounter"..ply:Nick())
end
end)
