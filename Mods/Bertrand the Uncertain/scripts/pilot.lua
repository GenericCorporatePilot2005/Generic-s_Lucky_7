local this={}
local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = modApi:getCurrentMod()
local scriptPath = modApi:getCurrentMod().scriptPath
local trait = require(mod_loader.mods.Nico_pilots.scriptPath .."trait")

local pilot = {
    Id = "Nico_Pilot_RNG",
    Personality = "Vek",
    Name = "Bertrand",
    Rarity = 1,
    PowerCost = 0,
    Voice = "/voice/ai",
    Skill = "NicoRNGskill",
}

local oldGetSkillInfo = GetSkillInfo
function GetSkillInfo(skill)
	if skill == "NicoRNGskill" then
    	return PilotSkill("Stochastic Matrix", "Damage randomized per turn. Check outcome on the pilot's trait.")
    end
    return oldGetSkillInfo(skill)
end
CreatePilot(pilot)

-- Append Assets
modApi:appendAsset("img/portraits/pilots/Nico_Pilot_RNG.png", path .."img/portraits/Nico_Pilot_RNG.png")
modApi:appendAsset("img/portraits/pilots/Nico_Pilot_RNG_2.png", path .."img/portraits/Nico_Pilot_RNG_2.png")
modApi:appendAsset("img/portraits/pilots/Nico_Pilot_RNG_blink.png", path .."img/portraits/Nico_Pilot_RNG_blink.png")
modApi:appendAsset("img/portraits/pilots/Nico_Pilot_RNG_glare.png", path .."img/portraits/Nico_Pilot_RNG_glare.png")

function this:init(mod)
    local options = mod_loader.currentModContent[mod.id].options
    local Nico_color = options["Nico_DIE_Sprite"].value
    modApi:appendAsset("img/combat/icons/Nico_icon_kill_glow_KO.png", path.."img/combat/icons/icon_kill_glow_KO_"..Nico_color..".png")
    Location["combat/icons/Nico_icon_kill_glow_KO.png"] = Point(-16,9)
    modApi:appendAsset("img/combat/icons/icon_dice_damage.png", path.."img/combat/icons/icon_dice_damage_"..Nico_color..".png")
    Location["combat/icons/icon_dice_damage.png"] = Point(-20, 8)

    math.randomseed(os.time())
    math.random()

    if GAME then
        GAME.NicoRNGBoost = GAME.NicoRNGBoost or math.random(1,6)
    end

	local function IsUserPresent()
		for i = 0, 2 do
			local p = Board:GetPawn(i)
			if p and p:IsAbility("NicoRNGskill") then return true end
		end
		return false
	end

    local ApplyEffect = function(mission)
        if IsUserPresent() and (Game:GetTeamTurn() == TEAM_PLAYER or IsTestMechScenario()) then
            GAME.NicoRNGBoost = math.random(1,6)
            local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
            for _, id in pairs(mechs) do
                local p = Board:GetPawn(id)
                local colors = {math.random(0,255),math.random(0,255),math.random(0,255)}
                if p:IsAbility("NicoRNGskill") then
					trait:update(p:GetSpace())
					Board:Ping(p:GetSpace(),GL_Color(colors[math.random(1,3)],colors[math.random(1,3)],colors[math.random(1,3)]))
					Board:AddAlert(p:GetSpace(),"Stochastic Matrix: "..GAME.NicoRNGBoost)
				end
            end
        end
    end

    local ContinueEffect = function(mission)
        modApi:conditionalHook(
            function() return Board ~= nil end,
            function()
                if IsUserPresent() then
                    GAME.NicoRNGBoost = GAME.NicoRNGBoost or 3
                    local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
                    for _, id in pairs(mechs) do
                        local p = Board:GetPawn(id)
                        if p:IsAbility("NicoRNGskill") then trait:update(p:GetSpace()) end
                    end
                end
            end
        )
    end

    local function Nico_RNG_Roll(mission, pawn, weaponId, p1, p2, skillEffect)
        if pawn and pawn:IsAbility("NicoRNGskill") and GAME then
            for i = 1, skillEffect.effect:size() do
                local spaceDamage = skillEffect.effect:index(i)
				if not (spaceDamage.iDamage == DAMAGE_ZERO or
				spaceDamage.iDamage == DAMAGE_DEATH or
				Board:GetCustomTile(spaceDamage.loc) == "tosx_rocks_0.png" or
				Board:GetCustomTile(spaceDamage.loc) == "tosx_whirlpool_0.png") then
                    if spaceDamage.iDamage > 0 then
                        if GAME.NicoRNGBoost == 1 then spaceDamage.iDamage = DAMAGE_ZERO
                        elseif GAME.NicoRNGBoost == 2 then
							spaceDamage.iDamage = math.max(0, spaceDamage.iDamage - 1)
							if spaceDamage.iDamage == 0 then spaceDamage.iDamage = DAMAGE_ZERO end
                        elseif GAME.NicoRNGBoost == 4 then spaceDamage.iDamage = spaceDamage.iDamage + 1
                        elseif GAME.NicoRNGBoost == 5 then spaceDamage.iDamage = spaceDamage.iDamage + 2
                        elseif GAME.NicoRNGBoost == 6 then spaceDamage.iDamage = DAMAGE_DEATH end
                    elseif spaceDamage.iDamage < 0 then
                        if GAME.NicoRNGBoost == 1 then
                            spaceDamage.iDamage = 1
                            spaceDamage.sImageMark = "combat/icons/icon_dice_damage.png"
                        elseif GAME.NicoRNGBoost == 2 then
                            spaceDamage.iDamage = math.max(0, spaceDamage.iDamage + 1)
							if spaceDamage.iDamage == 0 then spaceDamage.iDamage = DAMAGE_ZERO end
                        elseif GAME.NicoRNGBoost == 4 then spaceDamage.iDamage = spaceDamage.iDamage - 1
                        elseif GAME.NicoRNGBoost == 5 then spaceDamage.iDamage = spaceDamage.iDamage - 2
                        elseif GAME.NicoRNGBoost == 6 then spaceDamage.iDamage = -10 end
                    end
                end
            end
        end
    end
	local function Nico_RNG_RollB(mission, pawn, weaponId, p1, p2, p3, skillEffect)
        Nico_RNG_Roll(mission, pawn, weaponId, p1, p2, skillEffect)
    end

    local function onBoardClassInitialized(BoardClass, board)
        local IsDeadlyVanilla = board.IsDeadly
        BoardClass.IsDeadly = function(self, spaceDamage, pawn)
            if IsUserPresent() and GAME and spaceDamage and spaceDamage.iDamage > 0
			and not (Board:GetCustomTile(spaceDamage.loc) == "tosx_rocks_0.png" or Board:GetCustomTile(spaceDamage.loc) == "tosx_whirlpool_0.png") then
                local dmg = spaceDamage.iDamage
                if GAME.NicoRNGBoost == 1 then dmg = 0
                elseif GAME.NicoRNGBoost == 2 then dmg = math.max(0, dmg - 1)
                elseif GAME.NicoRNGBoost == 4 then dmg = dmg + 1
                elseif GAME.NicoRNGBoost == 5 then dmg = dmg + 2
                elseif GAME.NicoRNGBoost == 6 then 
                    spaceDamage.sImageMark = "combat/icons/Nico_icon_kill_glow_KO.png"
                    dmg = 100 
                end
                local copy = SpaceDamage(spaceDamage.loc, dmg)
                return IsDeadlyVanilla(self, copy, pawn)
            end
            return IsDeadlyVanilla(self, spaceDamage, pawn)
        end
    end
    -- Hooks
    modApi.events.onModsLoaded:subscribe(
		function()modApi:addTestMechEnteredHook(function()
			modApi:conditionalHook(
				function()
					return Board ~= nil and IsUserPresent() 
				end,
				function() 
					ApplyEffect() 
				end
			)
		end)

        modApi:addMissionStartHook(function(mission)
            ApplyEffect(mission)
        end)

        modApi:addNextTurnHook(function(mission)
            ApplyEffect(mission)
        end)

        if modapiext then
            modapiext:addResetTurnHook(function(mission)
                ApplyEffect(mission)
            end)
        end
        modApi:addPostLoadGameHook(ContinueEffect)
        modapiext:addSkillBuildHook(Nico_RNG_Roll)
        modapiext:addFinalEffectBuildHook(Nico_RNG_RollB)
    end)
    modApi.events.onBoardClassInitialized:subscribe(onBoardClassInitialized)

    local descriptions = {
        "Damage reduced to 0, Healing deals 1 damage.",
        "Damage and healing reduced by 1.",
        "Damage and healing are not affected.",
        "Damage and healing increased by 1.",
        "Damage and healing increased by 2.",
        "Damage kills instantly, Healing increased to 10 HP."
    }

	for i = 1, 6 do
		local suffix = (i == 4) and "" or "_"..Nico_color
		trait:add{
			func = function(self, pawn) 
				return pawn:IsAbility("NicoRNGskill") and GAME and GAME.NicoRNGBoost == i 
			end,
			pilotSkill = "NicoRNGskill",
			icon = path.."img/combat/icons/icon_dice"..i..suffix..".png",
			icon_glow = path.."img/combat/icons/icon_dice"..i..suffix.."_glow.png",
			icon_offset = Point(0,10),
			desc_title = "Stochastic Matrix: "..i,
			desc_text = "This turn's outcome is: "..i..". "..descriptions[i],
		}
	end
end

return this