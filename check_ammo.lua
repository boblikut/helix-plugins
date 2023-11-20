local PLUGIN = PLUGIN

PLUGIN.name = "Ammo chek"
PLUGIN.description = "Check ammo"
PLUGIN.schema = "Any"
PLUGIN.author = "boblikut"

function PLUGIN:CanDrawAmmoHUD(weapon)
	return false
end

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

local ShouldBreak = false
-------------------------------------------------------------------------------------------------------------------- Begining of general hook
hook.Add("PlayerButtonDown", "PressCheckButtun", function(ply, button) 

if ply:GetActiveWeapon() != ix_hands and ply:GetActiveWeapon() != ix_keys and checkDelay() and button == KEY_O then
setDelay(3)
ShouldBreak = false

hook.Add( "PlayerSwitchWeapon", "StopSwitchWeapon", function( ply, oldWeapon, newWeapon ) -- Player can't swintch weapon
	return true
end )


ply:SetFOV(85,2)
ply:EmitSound("weapons/ar2/npc_ar2_reload.wav", 75, 90, 0.5)
ply:Say('/me проверяет кол - во патронов в магазине')

ply:SetAction('ПРОВЕРЯЮ КОЛ - ВО ПАТРОНОВ В МАГАЗИНЕ...', 2, function()

if not ShouldBreak then
ply:SetFOV(0,0.5)
ply:ChatPrint(string.format('В магазине %d/%d патронов', ply:GetActiveWeapon():Clip1(), ply:GetActiveWeapon():GetMaxClip1()))
ply:Say('/me закончил проверку кол - ва патронов в магазине')
hook.Remove( "PlayerSwitchWeapon", "StopSwitchWeapon" )
end

end)


end

if ply:GetActiveWeapon() != ix_hands and ply:GetActiveWeapon() != ix_keys and checkDelay() and button == KEY_I then
setDelay(3)
ShouldBreak = false

hook.Add( "PlayerSwitchWeapon", "StopSwitchWeapon", function( ply, oldWeapon, newWeapon ) -- Player can't swintch weapon
	return true
end )


ply:SetFOV(85,2)
ply:EmitSound("weapons/ar2/npc_ar2_reload.wav", 75, 90, 0.5)
ply:Say('/me проверяет кол - во патрон с собой')

ply:SetAction('ПРОВЕРЯЮ КОЛ - ВО ПАТРОН В РЮКЗАКЕ...', 2, function()

if not ShouldBreak then 
ply:SetFOV(0,0.5)
ply:ChatPrint(string.format('Вы сможете полностью зарядить оружие ещё %d раз(а)', math.floor(ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType())/ply:GetActiveWeapon():GetMaxClip1())))
ply:Say('/me закончил проверку кол - ва патронов с собой')
hook.Remove( "PlayerSwitchWeapon", "StopSwitchWeapon" )
end

end)


end



end)
-------------------------------------------------------------------------------------------------------------------- Ending of general hook

hook.Add( "EntityFireBullets", "Stop Checking", function( entity, data ) -- Shoot to stop checking
	
	local ply = data.Attacker
	ply:StopSound("weapons/ar2/npc_ar2_reload.wav")
	ShouldBreak = true
	ply:SetFOV(0,0.1)
	ply:SetAction()
	
	
end )