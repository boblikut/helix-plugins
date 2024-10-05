
--/////////////////////////////////////////
--NOTICE: this plugin isn't the best example of overriding character's tooltip and didn't teste well. But in general this work)))
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

local PLUGIN = PLUGIN

PLUGIN.name = "Character's tooltip rework"
PLUGIN.author = "boblikut"
PLUGIN.description = "Simple rework of character's tooltip"

local disapearTime = 1.5 --How long will char name disapear
local apearTime = 1 --How long will char name apear

local disapearTimeCalculated = 3.86 / disapearTime
local apearTimeCalculated = 3.86 / apearTime

if CLIENT then
	local name
	local alpha = 0
	local lastEntity
	function PLUGIN:InitializedPlugins()
		local aimLength = 0.35
		local aimTime = 0
		local aimEntity
		local lastTrace = {}
		local hookRun = hook.Run
		timer.Adjust("ixCheckTargetEntity", 0.1, 0, function() 
			local client = LocalPlayer()
			local time = SysTime()

			if (!IsValid(client)) then
				return
			end

			local character = client:GetCharacter()

			if (!character) then
				return
			end

			lastTrace.start = client:GetShootPos()
			lastTrace.endpos = lastTrace.start + client:GetAimVector(client) * 160
			lastTrace.filter = client
			lastTrace.mask = MASK_SHOT_HULL

			lastEntity = util.TraceHull(lastTrace).Entity

			if (lastEntity != aimEntity) then
				aimTime = time + aimLength
				aimEntity = lastEntity
			end

			local panel = ix.gui.entityInfo
			local bShouldShow = time >= aimTime and (!IsValid(ix.gui.menu) or ix.gui.menu.bClosing) and
				(!IsValid(ix.gui.characterMenu) or ix.gui.characterMenu.bClosing)
			local bShouldPopulate = lastEntity.OnShouldPopulateEntityInfo and lastEntity:OnShouldPopulateEntityInfo() or true

			if (bShouldShow and IsValid(lastEntity) and hookRun("ShouldPopulateEntityInfo", lastEntity) != false and
				(lastEntity.PopulateEntityInfo or bShouldPopulate)) then

				if (!IsValid(panel) or (IsValid(panel) and panel:GetEntity() != lastEntity)) then
					if (IsValid(ix.gui.entityInfo)) then
					ix.gui.entityInfo:Remove()
					end

					local infoPanel = vgui.Create(ix.option.Get("minimalTooltips", false) and "ixTooltipMinimal" or "ixTooltip")
					local entityPlayer = lastEntity:GetNetVar("player")
					if (entityPlayer) then
						local target = lastEntity:GetCharacter()
						if (target) then
						      name = hookRun("GetCharacterName", lastEntity) or target:GetName()
						end
					else
						infoPanel:SetEntity(lastEntity)
					end

					infoPanel:SetDrawArrow(true)
					ix.gui.entityInfo = infoPanel
				end
			elseif (IsValid(panel)) then
				panel:Remove()
			end
		end)
	end
	
	surface.CreateFont("ixNameFont", {
		font = "Roboto Th",
		size = ScreenScale(20),
		shadow = true,
		extended = true,
		weight = 300
	})
	local lastName
	function PLUGIN:HUDPaint()
		if alpha < 255 and lastEntity and lastEntity:IsValid() and (lastEntity:GetNetVar("player") or lastEntity:IsPlayer()) then
			alpha = math.min(alpha + apearTimeCalculated, 255)
		elseif alpha > 0 then
			alpha = math.max(alpha - disapearTimeCalculated, 0)
		end
		if lastName != name then
			alpha = 0
		end
		lastName = name
		draw.SimpleText(name or "", "ixNameFont", ScrW()/2, ScrH()*0.55, Color(255,255,255,alpha), 1, 1)
	end
end
