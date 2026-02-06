local this = {}
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- 1. Pilot Definition
local pilot = {
    Id = "Nico_Pilot_Orbital",
    Personality = "Vek",
    Name = "John Armstrong",
    Rarity = 2,
    Voice = "/voice/ai",
    Skill = "Nico_Orbital_Skill",
}
CreatePilot(pilot)

-- 2. Assets
modApi:appendAsset("img/portraits/pilots/Nico_Pilot_Orbital.png", path .."img/portraits/Nico_Pilot_Orbital.png")

-- Animation used by orbitalPawn library during the landing phase
ANIMS.tatu_SatelliteLaunch = Animation:new{
    Image = "effects/timetravel.png",
    NumFrames = 19,
    Loop = false,
    PosX = -32,
    Time = 0.02,
    PosY = -145,
}

ANIMS.Orb

-- 3. Satellite Pawn Definition
Nico_Satellite_Pawn = Pawn:new{
    Name = "Recon Satellite",
    Class = "Ranged",
    Health = 1,
    MoveSpeed = 0,
    Flying = true,
    Image = "PullTank2",
    SkillList = { "Nico_Orbital_wep" },
    DefaultTeam = TEAM_PLAYER,
    ImpactMaterial = IMPACT_METAL,
	OrbitalIcon = true,
    Orbital = true, -- Library uses this to manage off-board state
    OrbitalAnim = "tatu_SatelliteLaunch",
	SpaceColor = false,
}

-- 4. The Satellite's Weapon
Nico_Orbital_wep = Skill:new{
    Name = "Confusion Shot",
    Description = "Flip a target and push adjacent tiles. Range scales with Pilot Move Speed.\nPilot kills reload this weapon.",
    Class = "Ranged",
    Icon = "weapons/Nico_Orbital_wep.png",
	Limited = 1,
    LaunchSound = "/weapons/shrapnel",
    Orbital = true, -- Required for Orbital Pawns to use it
    TipImage = {
        Unit = Point(0,5),
        Friendly = Point(1,2),
        Enemy = Point(2,1),
        Target = Point(2,1),
        CustomEnemy = "Leaper1",
    }
}

-- Helper to find the pilot on the board reliably
local function GetUser()
    if not Board then return nil end
    for i = 0, 2 do
        local mech = Board:GetPawn(i)
        if mech and mech:IsAbility("Nico_Orbital_Skill") then
            return mech
        end
    end
    return nil
end

function Nico_Orbital_wep:GetTargetArea(point)
    local ret = PointList()
    local user = GetUser()
    if not user then return ret end
    local userLoc = user:GetSpace()
    
    local userRange = user:GetMoveSpeed() or 3
    local nonUserRange = math.floor(user:GetMoveSpeed()/2) or 1
    local range = 0
    local pawnList = extract_table(Board:GetPawns(TEAM_PLAYER))
    -- Targets area around ALL allies within the Pilot's move range
    for x = 0, 7 do
        for y = 0, 7 do
            local curr = Point(x, y)
            for _, id in pairs(pawnList) do
                local p_ally = Board:GetPawn(id)
                if p_ally and id ~= Board:GetPawn(point):GetId() then
                    if p_ally:GetSpace() == userLoc then range = userRange
                    else range = nonUserRange end
                    if curr:Manhattan(p_ally:GetSpace()) <= range then
                        ret:push_back(curr)
                        break
                    end
                end
            end
        end
    end
    return ret
end

function Nico_Orbital_wep:GetSkillEffect(p1, p2)
    local ret = SkillEffect()
    local flip = SpaceDamage(p2, 0, DIR_FLIP)
    flip.sScript = string.format("Board:Ping(%s, GL_Color(255,255,255))", p2:GetString())
    
    for i = DIR_START, DIR_END do
        local push = SpaceDamage(p2 + DIR_VECTORS[i], 0)
        push.iPush = i
        push.sAnimation = "airpush_" .. i
        ret:AddDamage(push)
    end
    ret:AddDamage(flip)
    return ret
end

-- 5. Main Initialization logic
function this:init(mod)
    -- Tooltip logic
    local oldGetSkillInfo = GetSkillInfo
    function GetSkillInfo(skill)
        if skill == "Nico_Orbital_Skill" then
            return PilotSkill("Recon Satellite", "At mission start, deploys an off-board Satellite ally.")
        end
        return oldGetSkillInfo(skill)
    end

    local function EVENT_onModsLoaded()
		local function StartDeployment()
			modApi:conditionalHook(
				function()
					return Board and Board:GetTurn() == 1 and not Board:IsBusy()
				end,
				function()
					local user = GetUser()
					if user then
						local center = user:GetSpace()
						
						local satellite = PAWN_FACTORY:CreatePawn("Nico_Satellite_Pawn")
						satellite:SetOwner(user:GetId())
						satellite:SetInvisible(true)
						if _G["Nico_Satellite_Pawn"].OrbitalAnim then
							Board:AddAnimation(center, _G["Nico_Satellite_Pawn"].OrbitalAnim, 1)
							Board:AddPawn(satellite, Point(-1, -1))
						end
					end
				end
			)
		end
		
	local function Nico_Orbital_Reload(mission, pawn, weaponId, p1, p2, skillEffect)
		if (weaponId ~= "Move") and pawn and pawn:IsAbility("Nico_Orbital_Skill") then
    		local pawnList = extract_table(Board:GetPawns(TEAM_PLAYER))
			local satellite = nil
            for _, id in pairs(pawnList) do
				if Board:GetPawn(id):GetType() == "Nico_Satellite_Pawn" then
					satellite = id
				end
			end
			for i = 1, skillEffect.effect:size() do
				local spaceDamage = skillEffect.effect:index(i)
				spaceDamage.bKO_Effect = Board:IsDeadly(spaceDamage,Pawn)
				if spaceDamage.bKO_Effect then
					--invert the KO flag afterwards because it overwrites the spaceDamage image mark for some reason
					spaceDamage.bKO_Effect = false
					spaceDamage.sScript = string.format("Board:GetPawn(%s):ResetUses()",satellite)
				end
			end
		end
	end

		modapiext:addSkillBuildHook(Nico_Orbital_Reload)
        modApi:addMissionStartHook(function(mission)
            StartDeployment()
        end)
    end
    modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
end

return this