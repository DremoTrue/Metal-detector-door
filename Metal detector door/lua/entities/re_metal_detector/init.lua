AddCSLuaFile( "shared.lua" )
include('shared.lua')
resource.AddFile( "sound/roleplay/beep.mp3" )

function ENT:Initialize()
	self:SetModel("models/grinchfox/rp/frame.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:GetPhysicsObject():Wake();
end

-- WEAPON DETECTED / ARME DETECTER
local willSetOff = {"weapon_ak472", 
					"weapon_deagle2", 
					"weapon_fiveseven2", 
					"weapon_glock2", 
					"weapon_m42", 
					"weapon_mac102", 
					"weapon_mp52", 
					"weapon_p2282", 
					"weapon_pumpshotgun2", 
					"lockpick", 
					"ls_sniper"}




----------------------------------------------------------------------------------------- NE PAS TOUCHER LES FUNCTIONS / DON'T TOUCHE FUNCTION
function ENT:Think ( )
	if (self.goingOff && (self.goingOff + 5) > CurTime()) then return end

	local min = self:OBBMins()
	local cen = self:OBBCenter()
	local real = self:LocalToWorld(Vector(cen.x, cen.y, min.z))

	for _, each in pairs(player.GetAll()) do
		if (each:GetPos():Distance(real) < 50) then
			local foundMetal = false
			for _, each in pairs(each:GetWeapons()) do
				local cl = string.lower(each:GetClass())

				for _, class in pairs(willSetOff) do
					if cl == class then
						foundMetal = true
						break
					end
				end
				if foundMetal == true then break end
			end

			if foundMetal == true then
				self.goingOff = CurTime()
				self:EmitSound( "roleplay/beep.mp3" ) ---------------------------------- LE SON DE DETECTION / SOUND DETECT
				return
			end
		end
	end
end
