AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:Wake()
	end
	
end

function ENT:OnTakeDamage(dmg)
	self.HP = self.HP - dmg:GetDamage()
	if self.HP <= 0 then
		local pos = self:GetPos()
		local name = self:GetClass()
		ix.item.Spawn(table.Random(self.Items), pos)
		timer.Create("Respawning "..self:EntIndex(), self.RespawnTime, 1, function() 
			local ent = ents.Create(name)
			ent:SetPos(pos)
			ent:Spawn()
		end)
		self:Remove()
	end
end