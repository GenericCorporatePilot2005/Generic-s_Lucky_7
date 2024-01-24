local this={}

-- read out other files and add what they return to variables.
local mod = modApi:getCurrentMod()
local scriptPath = modApi:getCurrentMod().scriptPath
local replaceRepair = require(scriptPath.."replaceRepair/replaceRepair")
local path = mod_loader.mods[modApi.currentMod].resourcePath
local taunt = require(scriptPath.."taunt/taunt")

	--Lemon's Real Mission Checker
	local function isRealMission()
		local mission = GetCurrentMission()
		
		return true
			and mission ~= nil
			and mission ~= Mission_Test
			and Board
			and Board:IsMissionBoard()
		end
local pilot = {
	Id = "Nico_Pilot_Taunt",					-- id must be unique. Used to link to art assets.
	Personality = "NicoTaunt",			        -- must match the id for a personality you have added to the game.
	Name = "Alexander Zachary",
	Sex = SEX_MALE,
	Rarity = 2,
	Voice = "/voice/ai",						-- audio. look in pilots.lua for more alternatives.
	Skill = "Nico_Tauntskill",					-- pilot's ability - Must add a tooltip for new skills.
}

CreatePilot(pilot)

modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Taunt.png", path .."img/portraits/Nico_Pilot_Taunt.png")
modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Taunt_2.png", path .."img/portraits/Nico_Pilot_Taunt_2.png")
modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Taunt_blink.png", path .."img/portraits/Nico_Pilot_Taunt_blink.png")
modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Taunt_glare.png", path .."img/portraits/Nico_Pilot_Taunt_glare.png")
modApi:appendAsset("img/combat/icons/Nico_icon_Drained.png",path.."img/combat/icons/Nico_icon_Drained.png")
modApi:appendAsset("img/effects/shot_tauntshot_R.png",path.."img/effects/shot_tauntshot_R.png")
modApi:appendAsset("img/effects/shot_tauntshot_U.png",path.."img/effects/shot_tauntshot_U.png")
	Location["combat/icons/Nico_icon_Drained.png"] = Point(0,0)
local BURST_DOWN = "Nico_HpDrained"
Nico_HpDrained = Emitter:new{
	image = "combat/icons/Nico_icon_Drained.png",
	x = -10,
	y = -5,
	max_alpha = 0.5,
	min_alpha = 0.5,
	angle = 90,
	rot_speed = 0,
	angle_variance = 0,
	random_rot = false,
	lifespan = 1,
	burst_count = 1,
	speed = 0.75,
	birth_rate = 0,
	gravity = false,
	layer = LAYER_FRONT
}
--weapon
function this:init(mod)

	replaceRepair:addSkill{
		Name = "Tauntful",
		Description = "Instead of repairing, fires a projectile and taunts target. Shields self if it taunts.\nStarts missions with 1 HP.",
		weapon = "Nico_Tauntskill",
		pilotSkill = "Nico_Tauntskill",
		Icon = "img/weapons/Nico_Tauntskill.png",
		IsActive = function(pawn)
			return pawn:IsAbility(pilot.Skill)
		end
	}

	---- Parry ----
	Nico_Tauntskill = TankDefault:new{
		Icon = "img/weapons/Nico_Tauntskill.png",
		Name = "Taunting Cannon",
		Description = "Fires a powerful projectile that damages and taunts its target to the mech.\nShields self if it succesfully taunts.", 
		Damage = 1,
		Explosion = "",
		Sound = "/general/combat/explode_small",
		ProjectileArt = "effects/shot_tauntshot",
		Damage = 1,
		PowerCost = 1,
		Upgrades = 0,
		Push = 0,
		LaunchSound = "/weapons/modified_cannons",
		ImpactSound = "/impact/generic/explosion",
		TipImage = StandardTips.Ranged,
		ZoneTargeting = ZONE_DIR,
	}

	function Nico_Tauntskill:GetSkillEffect(p1, p2)
		local ret = SkillEffect()
		local dir = GetDirection(p2 - p1)
		local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)

		local damage = SpaceDamage(target, 0)
		ret:AddProjectile(damage, self.ProjectileArt)
		local gotTaunted = taunt.addTauntEffectSpace(ret, target, p1, self.Damage)
		if gotTaunted and not Board:GetPawn(p1):IsFrozen() then
			local shield = SpaceDamage(p1,0)
			shield.iShield = 1
			shield.iFire = -1
			shield.iAcid = -1
			shield.bHide = true
			ret:AddBounce(p1,-1)
			ret:AddDamage(shield)
			ret:AddScript(string.format("Board:GetPawn(%s):SetInfected(false)", p1:GetString()))
		end
		return ret
	end
end

--hooks
local Nico_HpDrained = function(mission)--Health Drain
	if not isRealMission() then return end
	if Game:GetTurnCount() == 1 and Game:GetTeamTurn() == TEAM_PLAYER then
		for k = 0,2 do
			local pawn = Board:GetPawn(k)
			if pawn:IsAbility("Nico_Tauntskill") then
				Board:Ping(pawn:GetSpace(),GL_Color(255,50,50))
				Board:AddBurst(pawn:GetSpace(),BURST_DOWN,DIR_NONE)
				Board:AddAlert(pawn:GetSpace(),"HEALTH DRAINED")
				pawn:SetHealth(1)
				return
			end
		end
	end
end

local HOOK_pawnTracked = function(mission, pawn)--Funny hehehaha Easter Egg
	if pawn:IsAbility("Nico_Tauntskill") and mission.ID == "Mission_Repair" then
		local TotalHP = pawn:GetMaxHealth()
		pawn:SetHealth(TotalHP)
	end
end

local function EVENT_onModsLoaded()
	modApi:addNextTurnHook(Nico_HpDrained)
	modapiext:addPawnTrackedHook(HOOK_pawnTracked)
end
	
modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)


return this