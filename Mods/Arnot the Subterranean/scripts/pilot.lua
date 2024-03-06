local this={}

-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- read out other files and add what they return to variables.
local mod = modApi:getCurrentMod()
local scriptPath = modApi:getCurrentMod().scriptPath

local pilot = {
	Id = "Nico_Pilot_Mole",					-- id must be unique. Used to link to art assets.
	Personality = "Vek",        -- must match the id for a personality you have added to the game.
	Name = "Prometheus",
	Rarity = 1,
	PowerCost = 0,
	Voice = "/voice/ai",				-- audio. look in pilots.lua for more alternatives.
	Skill = "Nico_Moleskill",				-- pilot's ability - Must add a tooltip for new skills.
}

CreatePilot(pilot)

-- add assets - notice how the name is identical to pilot.Id
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Mole.png", path .."img/portraits/Nico_Pilot_Mole.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Mole_2.png", path .."img/portraits/Nico_Pilot_Mole_2.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Mole_blink.png", path .."img/portraits/Nico_Pilot_Mole_blink.png")

function this:init(mod)
	local oldGetSkillInfo = GetSkillInfo
	function GetSkillInfo(skill)
		if skill == "Nico_Moleskill" then
			return PilotSkill("Burrower", "Mech burrows underground instead of walking, -1 move. \nDoesn't work on Flying mechs.")
		end
		return oldGetSkillInfo(skill)
	end

	local oldMove = Move.GetTargetArea
	function Move:GetTargetArea(p, ...)
		local mover = Board:GetPawn(p)
		if mover and (mover:IsAbility("Nico_Moleskill")) then
			local ret = Board:GetReachable(point, Pawn:GetMoveSpeed(), Pawn:GetPathProf())
			local board_size = Board:GetSize()
			for i = 0, 7 do
				for j = 0, 7  do
					local point = Point(i,j) -- DIR_LEFT
					if Board:IsBuilding(point) then
						for l = DIR_START, DIR_END do
							ret:push_back(point + DIR_VECTORS[l])
						end
					end
				end
			end
	
			return ret
		end
	
		return oldMove(self, p, ...)
	end

	local oldMove = Move.GetSkillEffect
	function Move:GetSkillEffect(p1, p2, ...)
		local mover = Board:GetPawn(p1)
		if mover and (mover:IsAbility("Nico_Moleskill")) then
			local ret = SkillEffect()
			local pawn = Board:GetPawn(p1)
			local distance = p1:Manhattan(p2)
			local direction = GetDirection(p2 - p1)
			if pawn:IsFlying() then return ret end
			local damage0 = SpaceDamage(p1,0)
			damage0.bHide = true
			if Board:IsTerrain(damage0.loc,TERRAIN_ICE) then
				damage0.sAnimation = "ExplIce1"
				damage0.sSound = "/impact/generic/ice"
			elseif Board:IsTerrain(damage0.loc,TERRAIN_WATER) and Board:IsAcid(p2) then
				damage0.sAnimation = "Splash_acid"
				damage0.sSound = "/props/acid_splash"
			elseif Board:IsTerrain(damage0.loc,TERRAIN_LAVA) then
				damage0.sAnimation = "Splash_lava"
				damage0.sSound = "/props/lava_splash"
			elseif Board:IsTerrain(damage0.loc,TERRAIN_WATER) then
				damage0.sAnimation = "Splash"
				damage0.sSound = "/props/water_splash"
			else
				damage0.sAnimation = "explodrill"
				damage0.sSound = "/impact/dynamic/rock"
			end
			ret:AddBurst(damage0.loc,"Emitter_Crack_Start",DIR_NONE)
			ret:AddDelay(0.1)
			ret:AddDamage(damage0)
			ret:AddBounce(damage0.loc,5)
			ret:AddDelay(0.45)
			ret:AddScript(string.format("Board:GetPawn(%s):SetInvisible(true)", pawn:GetId()))
			ret:AddDelay(0.1)
			
			local path = extract_table(Board:GetPath(p1, p2, PATH_FLYER))
			local dist = #path - 1
			for i = 1, #path do
				local p = path[i]
				ret:AddBounce(p, -2)
				ret:AddDelay(.32 / dist)
			end
			
			
			local damage0 = SpaceDamage(p2,0)
			damage0.bHide = true
			if Board:IsTerrain(damage0.loc,TERRAIN_ICE) then
				damage0.sAnimation = "ExplIce1"
				damage0.sSound = "/impact/generic/ice"
			elseif Board:IsTerrain(damage0.loc,TERRAIN_WATER) and Board:IsAcid(p2) then
				damage0.sAnimation = "Splash_acid"
				damage0.sSound = "/props/acid_splash"
			elseif Board:IsTerrain(damage0.loc,TERRAIN_LAVA) then
				damage0.sAnimation = "Splash_lava"
				damage0.sSound = "/props/lava_splash"
			elseif Board:IsTerrain(damage0.loc,TERRAIN_WATER) then
				damage0.sAnimation = "Splash"
				damage0.sSound = "/props/water_splash"
			else
				damage0.sAnimation = "rock1d"
				damage0.sSound = "/impact/dynamic/rock"
			end
			ret:AddDamage(damage0)
			local damage0 = SpaceDamage(p2,0)
			damage0.sImageMark = "combat/icons/Nico_icon_emerge_cb_glow.png"
			ret:AddDamage(damage0)
			local damage0 = SpaceDamage(p1,0)
			damage0.sImageMark = "combat/icons/Nico_icon_burrow_cb_glow.png"
			ret:AddDamage(damage0)
			ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(%s)", pawn:GetId(), p2:GetString()))
			ret:AddScript(string.format("Board:GetPawn(%s):SetInvisible(false)", pawn:GetId()))
			ret:AddBounce(damage0.loc,5)
			return ret
		end
		return oldMove(self, p1, p2, ...)
	end
end
return this
