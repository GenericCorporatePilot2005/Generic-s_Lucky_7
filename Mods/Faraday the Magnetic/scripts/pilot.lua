local this={}

-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- read out other files and add what they return to variables.
local mod = modApi:getCurrentMod()
local scriptPath = modApi:getCurrentMod().scriptPath
local replaceRepair = require(scriptPath.."replaceRepair/replaceRepair")

local pilot = {
	Id = "Nico_Pilot_Magneto",					-- id must be unique. Used to link to art assets.
	Personality = "Vek",        -- must match the id for a personality you have added to the game.
	Name = "Shin Leva",
	PowerCost = 1,
	Rarity = 2,
	Voice = "/voice/ai",				-- audio. look in pilots.lua for more alternatives.
	Skill = "Nico_Magneto_Skill",				-- pilot's ability - Must add a tooltip for new skills.
}

CreatePilot(pilot)

-- add assets - notice how the name is identical to pilot.Id
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Magneto.png", path .."img/portraits/pilots/Nico_Pilot_Magneto.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Magneto_2.png", path .."img/portraits/pilots/Nico_Pilot_Magneto_2.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Magneto_blink.png", path .."img/portraits/pilots/Nico_Pilot_Magneto_blink.png")

function this:init(mod)

	local path = mod_loader.mods[modApi.currentMod].resourcePath
	--magnet icon
		modApi:appendAsset("img/combat/icons/icon_magnet_glow.png", path.. "img/combat/icons/icon_magnet_glow.png")
		Location["combat/icons/icon_magnet_glow.png"] = Point(-10,9)
	--animation for magnetizing a unit
		modApi:appendAsset("img/effects/tosx_magflare1.png",path.."img/effects/tosx_magflare1.png")
		ANIMS.tosx_magflare = Animation:new{
			Image = "effects/tosx_magflare1.png",
			PosX = -42,
			PosY = -8,
			Time = 0.03,
			NumFrames = 9,
		}
	--magnetic healing icon's animation
		modApi:appendAsset("img/combat/icons/icon_magnet_glowAnim.png",path.."img/combat/icons/icon_magnet_glowAnim.png")
		Location["combat/icons/icon_magnet_glowAnim.png"] = Point(-22,10)

		ANIMS.tosx_magnetic_icon = Animation:new{
			Image = "combat/icons/icon_magnet_glowAnim.png",
			PosX = -28,
			PosY = 10,
			Time = 0.15,
			Loop = true,
			NumFrames = 4,
		}
	--magnetic healing icon's animation
		modApi:appendAsset("img/combat/icons/icon_heal_magnet_glowAnim.png",path.."img/combat/icons/icon_heal_magnet_glowAnim.png")
		Location["combat/icons/icon_heal_magnet_glowAnim.png"] = Point(-22,10)

		ANIMS.tosx_magnetic_heal_icon = Animation:new{
			Image = "combat/icons/icon_heal_magnet_glowAnim.png",
			PosX = -28,
			PosY = 10,
			Time = 0.15,
			Loop = true,
			NumFrames = 4,
		}
	local previewer = require(scriptPath .."libs/weaponPreview")
	local function IsTipImage()
		return Board:GetSize() == Point(6, 6)
	end
	
	local function IsMagnetic(point)
		if not Board:IsPawnSpace(point) then return false end
		if magscorps and Board:GetPawn(point):GetType() == "Scorpion1" then return true end
	
		if not IsTipImage() then
			if GAME then
				GAME.tosx_PosPolarities = GAME.tosx_PosPolarities or {}
				if GAME.tosx_PosPolarities[Board:GetPawn(point):GetId()] then return true end
			end
		end
		
		return false
	end

	local function ShowPolarities()
		local allpawns = extract_table(Board:GetPawns(TEAM_ANY))
		for i,id in pairs(allpawns) do
			local point = Board:GetPawnSpace(id)
			if IsMagnetic(point) then
				if Board:GetPawnTeam(point) == TEAM_PLAYER then
					previewer:AddAnimation(point, "tosx_magnetic_heal_icon")
				else
					previewer:AddAnimation(point, "tosx_magnetic_icon")
				end
			end
		end
	end

	-- Functions to display a hacky animated sImageMark (equivalent to weaponPreview) in a TipImage
	local tippolarity = false

	function tosx_resetTipPolarity()
		tippolarity = false
	end

	local function ShowPolaritiesTip(point)
		if tippolarity then return false end
		local effect = SkillEffect()
		local damage = SpaceDamage(point,0)
		damage.bHide = true
		damage.sAnimation = "tosx_magnetic_iconTip"
		effect:AddDelay(.6)
		effect:AddDamage(damage)
		Board:AddEffect(effect)
		tippolarity = true
	end
	replaceRepair:addSkill{
		Name = "Magneto",
		Description = "Repairing mangnetizes all adjacent units. Already magnetized allies will get healed, already magnetized enemies will suffer 1 damage and get flipped.",
		weapon = "Nico_Magneto_Skill",
		pilotSkill = "Nico_Magneto_Skill",
		Icon = "img/weapons/MagnetoRepair.png",
		iconFrozen = "img/weapons/MagnetoRepair_frozen.png",
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}
	Nico_Magneto_Skill = Skill_Repair:new{
		Icon = "img/weapons/MagnetoRepair.png",
		Name = "Magnetic repairs",
		Description = "Repairing mangnetizes all adjacent units.\nAlready magnetized allies will get healed, already magnetized enemies will suffer 1 damage and get flipped.",
		Amount = -1,
		Flip = true,
		TipImage = {
			Unit = Point(2,2),
			Enemy = Point(2,3),
			Enemy2 = Point(3,2),
			Friendly2 = Point(1,2),
			Friendly3 = Point(2,1),
			Target = Point(2,3),
			Second_Origin = Point(2,2),
			Second_Target = Point(2,2),
			CustomEnemy = "Leaper1",
		}
	}

	function Nico_Magneto_Skill:GetTargetArea(point)
		local ret = PointList()	--create an empty pointlist
		
		-- iterate all 4 directions
		for dir = DIR_START, DIR_END do
			local curr = point + DIR_VECTORS[dir]
			-- if point is inside the board limits,
			if Board:IsValid(curr) then
				-- add it to the pointlist.
				ret:push_back(curr)
			end
		end
		ret:push_back(point)
	
		ShowPolarities()
		
		return ret
	end

	function Nico_Magneto_Skill:GetSkillEffect(p1,p2)
		local ret = SkillEffect()
		local damage = SpaceDamage(p1,self.Amount)
		damage.iFire = EFFECT_REMOVE
		damage.iAcid = EFFECT_REMOVE
		local magthis = false
		ret:AddScript("tosx_resetTipPolarity()")
		
		ret:AddDamage(damage)

		for dir = DIR_START, DIR_END do
			local curr = p1 + DIR_VECTORS[dir]
			if Board:IsPawnSpace(curr) and not IsMagnetic(curr) then
				if not IsTipImage() then
					local damage = SpaceDamage(curr, self.Damage)
					damage.sImageMark = "combat/icons/icon_magnet_glow.png"
					damage.sAnimation = "tosx_magflare"
					ret:AddDamage(damage)
					ret:AddBounce(damage.loc,2)
					magthis = Board:GetPawn(damage.loc):GetId()
					local turn = IsTestMechScenario() and 1 or Game:GetTurnCount()
					ret:AddScript("GAME.tosx_PosPolarities["..magthis.."] = "..turn) -- Add to magnetic list
				else
					if Board:GetPawnTeam(curr) == TEAM_PLAYER then
						local heal = SpaceDamage(curr,-1)
						ret:AddDamage(heal)
						ret:AddBounce(curr,1)
					elseif Board:GetPawnTeam(curr) == TEAM_ENEMY then
						local damage = SpaceDamage(curr,1,DIR_FLIP)
						damage.sAnimation = "tosx_magflare"
						ret:AddDamage(damage)
						ret:AddBounce(curr,1)
					else
						local damage = SpaceDamage(curr,0,DIR_FLIP)
						damage.sAnimation = "tosx_magflare"
						ret:AddDamage(damage)
						ret:AddBounce(curr,1)
					end
				end
			end
		end

		for i = 0, 7 do
			for j = 0, 7  do
				local point = Point(i,j) -- DIR_LEFT
				if dir == DIR_RIGHT then
					point = Point(7 - i, j)
				elseif dir == DIR_UP then
					point = Point(j,i)
				elseif dir == DIR_DOWN then
					point = Point(j,7-i)
				end
				
				if Board:IsPawnSpace(point) and point ~= p1 then
					if IsMagnetic(point) and Board:GetPawnTeam(point) == TEAM_PLAYER then
						local heal = SpaceDamage(point,-1)
						ret:AddDamage(heal)
						ret:AddBounce(point,1)
					elseif IsMagnetic(point) and Board:GetPawnTeam(point) == TEAM_ENEMY then
						local damage = SpaceDamage(point,1,DIR_FLIP)
						damage.sAnimation = "tosx_magflare"
						damage.sImageMark = "combat/icons/icon_swap_magnet_glowA.png"
						ret:AddDamage(damage)
						ret:AddBounce(point,1)
					else
						local damage = SpaceDamage(point,0,DIR_FLIP)
						damage.sAnimation = "tosx_magflare"
						ret:AddDamage(damage)
						ret:AddBounce(curr,1)
					end
				end
			end
		end
		return ret
	end
end

return this
