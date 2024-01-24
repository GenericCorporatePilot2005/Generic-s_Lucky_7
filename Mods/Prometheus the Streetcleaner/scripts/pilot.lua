local this={}

-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- read out other files and add what they return to variables.
local mod = modApi:getCurrentMod()
local scriptPath = modApi:getCurrentMod().scriptPath
local replaceRepair = require(scriptPath.."replaceRepair/replaceRepair")

local pilot = {
	Id = "Nico_Pilot_Prom",					-- id must be unique. Used to link to art assets.
	Personality = "Vek",        -- must match the id for a personality you have added to the game.
	Name = "Prometheus",
	Rarity = 1,
	PowerCost = 0,
	Voice = "/voice/ai",				-- audio. look in pilots.lua for more alternatives.
	Skill = "Nico_Promskill",				-- pilot's ability - Must add a tooltip for new skills.
}

CreatePilot(pilot)

-- add assets - notice how the name is identical to pilot.Id
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Prom.png", path .."img/portraits/Nico_Pilot_Prom.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Prom_2.png", path .."img/portraits/Nico_Pilot_Prom_2.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Prom_blink.png", path .."img/portraits/Nico_Pilot_Prom_blink.png")

function this:init(mod)

	replaceRepair:addSkill{
		Name = "Flame Thrower",
		Description = "Instead of repairing, uses flamethrower, if Mech's on fire, fires projectile. Removes fire from self.",
		weapon = "Nico_Promskill",
		pilotSkill = "Nico_Promskill",
		Icon = "img/weapons/streetcleaner_repair.png",
		iconFrozen = "img/weapons/streetcleaner_repairfrozen.png",
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}

	---- Flame Thrower ----
	Nico_Promskill = Skill:new{
		Name = "Flame Thrower",
		Description = "Instead of repairing, uses a flamethrower, if Mech is on fire, fires a firey projectile, and removes fire from self.\nReactivates Mech if it removes fire or unfreezes.",
		Icon = "img/weapons/streetcleaner_repair.png",
		PathSize = 1,
		Damage = 0,
		ProjectileArt = "effects/shot_mechtank",
		LaunchSound = "/weapons/flamethrower",
		ImpactSound = "/impact/generic/explosion",
		Fire = 1,
		Explo = "explopush1_",
		TipImage = {
			Unit = Point(2,4),
			Fire = Point(2,4),
			Enemy = Point(2,2),
			Target = Point(2,2),
		},
	}

	function Nico_Promskill:GetTargetArea(p1)
		local ret = PointList()
		if Board:IsFire(p1) then
			for dir = DIR_START, DIR_END do
				for i = 1, 8 do
					local curr = Point(p1 + DIR_VECTORS[dir] * i)
					if not Board:IsValid(curr) then
						break
					end
					ret:push_back(curr)				
					if Board:IsBlocked(curr,PATH_PROJECTILE) then
						break
					end
				end
			end
		elseif Board:GetPawn(p1):IsFrozen() then
			ret:push_back(p1)
		else
			for i = DIR_START, DIR_END do
				for k = 1, self.PathSize do
					local curr = DIR_VECTORS[i]*k + p1
					ret:push_back(curr)
					if not Board:IsValid(curr) then  -- AE change or Board:GetTerrain(curr) == TERRAIN_MOUNTAIN 
						break
					end
				end
			end
		end
		
		return ret
	end

	function Nico_Promskill:GetSkillEffect(p1, p2)
		local ret = SkillEffect()
		local direction = GetDirection(p2 - p1)

		if Board:GetSize() == Point(6,6) then
			local x = math.random(0,1)
			if x==0 then
				self.TipImage = {
					Unit = Point(2,4),
					Fire = Point(2,4),
					Enemy = Point(2,2),
					Target = Point(2,2),
				}
			else
				self.TipImage = {
					Unit = Point(2,3),
					Enemy = Point(2,2),
					Target = Point(2,2),
				}
			end
		end

		if Board:IsFire(p1) or Board:GetPawn(p1):IsFrozen() then
			if Board:IsFire(p1) then
				local target = GetProjectileEnd(p1,p2)
				local damage = SpaceDamage(target, self.Damage,direction)
				damage.iFire = 1
				ret:AddProjectile(damage, "effects/shot_mechtank",FULL_DELAY)
				ret:AddBounce(damage.loc, 1)
				local remfire = SpaceDamage(p1)
				remfire.iFire = EFFECT_REMOVE
				remfire.sImageMark = "combat/icons/icon_fire_immune_glow.png"
				ret:AddDamage(remfire)
			elseif Board:GetPawn(p1):IsFrozen() then
				local addfire = SpaceDamage(p1)
				addfire.iFire = 1
				ret:AddDamage(addfire)
			end
			ret:AddScript(string.format("Board:GetPawn(%s):SetActive(true)", p1:GetString()))
			ret:AddScript(string.format("Board:GetPawn(%s):SetMovementSpent(false)", p1:GetString()))
			ret:AddScript(string.format("Board:Ping(%s,GL_Color(255,226,52))", p1:GetString())) -- cool animation part 1
			ret:AddDelay(0.125)
			ret:AddScript(string.format("Board:Ping(%s,GL_Color(255,162,52))", p1:GetString())) -- cool animation part 2
			ret:AddDelay(0.125)
			ret:AddScript(string.format("Board:Ping(%s,GL_Color(253,79,66))", p1:GetString())) -- cool animation part 3
		else
			local distance = p1:Manhattan(p2)
			for i = 1, distance do
				local curr = p1 + DIR_VECTORS[direction]*i
				local damage = SpaceDamage(p1 + DIR_VECTORS[direction]*i,0, direction)
				damage.iFire = EFFECT_CREATE
				if i == distance then 	
					damage.sAnimation = "flamethrower"..distance.."_"..direction 
				end
				ret:AddDamage(damage)
			end
		end
		return ret
	end
end
return this
