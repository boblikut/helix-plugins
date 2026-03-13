ITEM.name = "Health kit"
ITEM.description = "Thanks this kit you can heal yourself or someone"
ITEM.model = Model('models/Items/HealthKit.mdl')
ITEM.max = 5

ITEM.functions.HealSelf = {
	name = "Heal",
	icon = "icon16/add.png",
	sound = "items/medshot4.wav",
	OnRun = function(item)
		local client = item.player
		client:SetHealth(math.min(client:Health() + 50, 100))
		return item:ReduceAmount()
	end
}

ITEM.functions.HealOther = {
	name = "Heal person against you",
	icon = "icon16/add.png",
	sound = "items/medshot4.wav",
	OnRun = function(item)
		local client = item.player
		local ent = client:GetEyeTraceNoCursor().Entity
		ent:SetHealth(math.min(client:Health() + 50, 100))
		return item:ReduceAmount()
	end,
	OnCanRun =  function(item)
		local ent = item.player:GetEyeTraceNoCursor().Entity
		
		return ent:IsPlayer() and ent:GetPos():DistToSqr(item.player:GetPos()) <= 10000
	end
}