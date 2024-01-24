local this={}

-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- read out other files and add what they return to variables.
local mod = modApi:getCurrentMod()
local scriptPath = modApi:getCurrentMod().scriptPath
local trait = require(mod.scriptPath .."trait")

local pilot = {
	Id = "Nico_Pilot_RNG",		-- id must be unique. Used to link to art assets.
	Personality = "Vek",        -- must match the id for a personality you have added to the game.
	Name = "Bertrand",
	Rarity = 1,
	PowerCost = 0,
	Voice = "/voice/ai",		-- audio. look in pilots.lua for more alternatives.
	Skill = "NicoRNGskill",		-- pilot's ability - Must add a tooltip for new skills.
}

CreatePilot(pilot)

-- add assets - notice how the name is identical to pilot.Id
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_RNG.png", path .."img/portraits/Nico_Pilot_RNG.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_RNG_2.png", path .."img/portraits/Nico_Pilot_RNG_2.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_RNG_blink.png", path .."img/portraits/Nico_Pilot_RNG_blink.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_RNG_glare.png", path .."img/portraits/Nico_Pilot_RNG_glare.png")
	modApi:appendAsset("img/combat/icons/tosx_icon_kill_glow_KO.png", path.."img/combat/icons/icon_kill_glow_KO.png")
	Location["combat/icons/tosx_icon_kill_glow_KO.png"] = Point(-16,9)

function this:init(mod)
	local options = mod_loader.currentModContent[mod.id].options
	math.randomseed(os.time())
	math.random() -- first value is useless
	
	local oldGetSkillInfo = GetSkillInfo
	function GetSkillInfo(skill)
		if skill == "NicoRNGskill"    then
			return PilotSkill("Randomness Matrix", "Each turn, rolls a number, damage changes with number. Check outcome on the pilot's trait.")
		end
		return oldGetSkillInfo(skill)
	end
	local function isRealMission()
		local mission = GetCurrentMission()
		
		return true
			and mission ~= nil
			and mission ~= Mission_Test
			and Board
			and Board:IsMissionBoard()
		end

	if GAME then
		GAME.NicoRNGBoost = math.random(1,20)
	end

	--[[
	NAT 1:      -1
	DE 2 A 7:   +0
	DE 8 A 13:  +1
	DE 14 A 19: +2
	NAT 20:     DAMAGE_DEATH]]

	local function GetUser()
		for i = 0,2 do
			local mech = Board:GetPawn(i)
			if mech then
				--LOG("ability: " .. mech:GetAbility()) 
				if mech:IsAbility("NicoRNGskill") then
					--LOG("mech has the right skill!")
					return Board:GetPawn(i)
				end
			end
		end
		return nil
	end
	
	local function IsUserPresent()
		--LOG("[APOLLO] IsApolloPresent()")
		for i = 0, 2 do
			local mech = Board:GetPawn(i)
			--LOG("i: " .. tostring(i))
			if mech then
				--LOG("ability: " .. mech:GetAbility()) 
				if mech:IsAbility("NicoRNGskill") then
					--LOG("mech has right skill!")
					return true
				else
					--LOG("not the right skill :(")
				end
			else
				--LOG("Mech doesn't exist!!")
			end
		end
		return false
	end
	local ApplyEffect = function(mission)--rolls NicoRNGBoost
	
		if IsUserPresent() and Game:GetTeamTurn() == TEAM_PLAYER then
			GAME.NicoRNGBoost = math.random(1,20)
			LOG(GAME.NicoRNGBoost)
			if Game:GetTurnCount() < 4 then
				local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
				for i,id in pairs(mechs) do
					trait:update(Board:GetPawnSpace(id))
				end
			end
		end
	end
	local ContinueEffect = function(mission)--effect contunues after exiting the game and reentering
		modApi:conditionalHook(
			function()
				return Board ~= nil
			end,
			function()
				local mission = GetCurrentMission()
				if IsUserPresent() then
					ApplyEffect()
				end
			end
		)
	end
	local function Nico_RNG_RollA(mission, pawn, weaponId, p1, p2, skillEffect)
		if pawn and pawn:IsAbility("NicoRNGskill") and isRealMission() then
			for i = 1, skillEffect.effect:size() do
				local spaceDamage = skillEffect.effect:index(i)
				if spaceDamage.iDamage ~= DAMAGE_ZERO and spaceDamage.iDamage ~= DAMAGE_DEATH then
					if spaceDamage.iDamage > 0 then--does it deal damage?
						if GAME.NicoRNGBoost == 1 then--reduces 1 damage
							spaceDamage.iDamage = spaceDamage.iDamage-1
							if spaceDamage.iDamage == 0 then--changes it from 0 to DAMAGE_ZERO
								spaceDamage.iDamage = DAMAGE_ZERO
							end
						elseif GAME.NicoRNGBoost > 7 and GAME.NicoRNGBoost < 14 then--adds 1 damage
							spaceDamage.iDamage = spaceDamage.iDamage + 1
						elseif GAME.NicoRNGBoost > 13 and GAME.NicoRNGBoost < 20 then--adds 2 damage
							spaceDamage.iDamage = spaceDamage.iDamage + 2
						elseif GAME.NicoRNGBoost == 20 then--deals DAMAGE_DEATH
							spaceDamage.iDamage = DAMAGE_DEATH
						end
					elseif spaceDamage.iDamage < 0 then--does it heal?
						if GAME.NicoRNGBoost == 1 then--does 1 damage, doesn't heal
							spaceDamage.iDamage = 1
						--adds 0 heal, irrelevant to write
						elseif GAME.NicoRNGBoost > 7 and GAME.NicoRNGBoost < 14 then--heals 1 more
							spaceDamage.iDamage = spaceDamage.iDamage - 1
						elseif GAME.NicoRNGBoost > 13 and GAME.NicoRNGBoost < 20 then--heals 2 more
							spaceDamage.iDamage = spaceDamage.iDamage - 2
						elseif GAME.NicoRNGBoost == 20 then--heals 10 hp
							spaceDamage.iDamage = -10
						else
						end
					end
				end
			end
		end
	end
	
	local function Nico_RNG_RollB(mission, pawn, weaponId, p1, p2, p3, skillEffect)
		if pawn and pawn:IsAbility("NicoRNGskill") and isRealMission() then
			for i = 1, skillEffect.effect:size() do
				local spaceDamage = skillEffect.effect:index(i)
				if spaceDamage.iDamage ~= DAMAGE_ZERO and spaceDamage.iDamage ~= DAMAGE_DEATH then
					if spaceDamage.iDamage > 0 then--does it deal damage?
						if GAME.NicoRNGBoost == 1 then--reduces 1 damage
							spaceDamage.iDamage = spaceDamage.iDamage-1
							if spaceDamage.iDamage == 0 then--changes it from 0 to DAMAGE_ZERO
								spaceDamage.iDamage = DAMAGE_ZERO
							end
						--Adds 0 damage, irrelevant
						elseif GAME.NicoRNGBoost > 7 and GAME.NicoRNGBoost < 14 then--adds 1 damage
							spaceDamage.iDamage = spaceDamage.iDamage + 1
						elseif GAME.NicoRNGBoost > 13 and GAME.NicoRNGBoost < 20 then--adds 2 damage
							spaceDamage.iDamage = spaceDamage.iDamage + 2
						elseif GAME.NicoRNGBoost == 20 then--deals DAMAGE_DEATH
							spaceDamage.iDamage = DAMAGE_DEATH
						else
						end
					elseif spaceDamage.iDamage < 0 then--does it heal?
						if GAME.NicoRNGBoost == 1 then--does 1 damage, doesn't heal
							spaceDamage.iDamage = 1
						--adds 0 heal, irrelevant to write
						elseif GAME.NicoRNGBoost > 7 and GAME.NicoRNGBoost < 14 then--heals 1 more
							spaceDamage.iDamage = spaceDamage.iDamage - 1
						elseif GAME.NicoRNGBoost > 13 and GAME.NicoRNGBoost < 20 then--heals 2 more
							spaceDamage.iDamage = spaceDamage.iDamage - 2
						elseif GAME.NicoRNGBoost == 20 then--heals 10 hp
							spaceDamage.iDamage = -10
						else
						end
					end
				end
			end
		end
	end
	local function onBoardClassInitialized(BoardClass, board)	
		local IsDeadlyVanilla = board.IsDeadly
		BoardClass.IsDeadly = function(self, spaceDamage, pawn)
			Assert.Equals("userdata", type(self), "Argument #0")
			Assert.Equals("userdata", type(spaceDamage), "Argument #1")
			Assert.Equals("userdata", type(pawn), "Argument #2")
			if IsUserPresent() and isRealMission() then 
				if spaceDamage and spaceDamage.loc and Board:IsValid(spaceDamage.loc) and
				spaceDamage.iDamage and spaceDamage.iDamage > 0 then
					local spaceDamageCopy = SpaceDamage(spaceDamage.loc, spaceDamage.iDamage, spaceDamage.iPush)
					if GAME.NicoRNGBoost == 1 and spaceDamageCopy.iDamage-1==0 then
						spaceDamageCopy.iDamage = 0
					elseif GAME.NicoRNGBoost == 1 and spaceDamageCopy.iDamage-1~=0 then
						spaceDamageCopy.iDamage = spaceDamageCopy.iDamage - 1
					elseif GAME.NicoRNGBoost > 7 and GAME.NicoRNGBoost < 14 then
						spaceDamageCopy.iDamage = spaceDamageCopy.iDamage + 1
					elseif GAME.NicoRNGBoost > 13 and GAME.NicoRNGBoost < 20 then
						spaceDamageCopy.iDamage = spaceDamageCopy.iDamage + 2
					elseif GAME.NicoRNGBoost == 20 then
						spaceDamageCopy.iDamage = 100
						spaceDamage.sImageMark = "combat/icons/tosx_icon_kill_glow_KO.png"
					end
					if Board:IsPawnSpace(spaceDamage.loc) then
						return IsDeadlyVanilla(self, spaceDamageCopy, pawn)
					end
				end
			end
			return IsDeadlyVanilla(self, spaceDamage, pawn)
		end
	end

	--loads the hooks
	local function EVENT_onModsLoaded()
		modApi:addNextTurnHook(ApplyEffect)
		modApi:addPostLoadGameHook(function(mission)
			ContinueEffect(mission)
		end)
		modapiext:addSkillBuildHook(Nico_RNG_RollA)
		modapiext:addFinalEffectBuildHook(Nico_RNG_RollB)
	end
	
	modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
	modApi.events.onBoardClassInitialized:subscribe(onBoardClassInitialized)

	local traitfunc_Nico_RNG1 = function(trait, pawn)
		local mission = GetCurrentMission()
		if not mission then return false end
		return pawn:IsAbility("NicoRNGskill") and GAME.NicoRNGBoost == 1
	end
	local traitfunc_Nico_RNG2 = function(trait, pawn)
		local mission = GetCurrentMission()
		if not mission then return false end
		return pawn:IsAbility("NicoRNGskill") and (GAME.NicoRNGBoost > 1 and GAME.NicoRNGBoost < 8)
	end
	local DiceNumber = math.random(0,1)
	local traitfunc_Nico_RNG3 = function(trait, pawn)
		local mission = GetCurrentMission()
		if not mission then return false end
		return pawn:IsAbility("NicoRNGskill") and (GAME.NicoRNGBoost > 7 and GAME.NicoRNGBoost < 14) and DiceNumber==0
	end
	local traitfunc_Nico_RNG4 = function(trait, pawn)
		local mission = GetCurrentMission()
		if not mission then return false end
		return pawn:IsAbility("NicoRNGskill") and (GAME.NicoRNGBoost > 7 and GAME.NicoRNGBoost < 14) and DiceNumber==1
	end
	local traitfunc_Nico_RNG5 = function(trait, pawn)
		local mission = GetCurrentMission()
		if not mission then return false end
		return pawn:IsAbility("NicoRNGskill") and (GAME.NicoRNGBoost > 13 and GAME.NicoRNGBoost < 20)
	end
	local traitfunc_Nico_RNG6 = function(trait, pawn)
		local mission = GetCurrentMission()
		if not mission then return false end
		return pawn:IsAbility("NicoRNGskill") and GAME.NicoRNGBoost == 20
	end
		trait:add{
			func = traitfunc_Nico_RNG1,
			pilotSkill = "NicoRNGskill",
			icon = path.."img/combat/icons/icon_dice1.png",
			icon_offset = Point(0,0),
			desc_title = "Randomness Matrix",
			desc_text = "Each turn, rolls a number, damage changes with number. This turn's outcome is: 1, Damage is reduced by 1, Healing instead deals 1 damage.",
		}
		trait:add{
			func = traitfunc_Nico_RNG2,
			pilotSkill = "NicoRNGskill",
			icon = path.."img/combat/icons/icon_dice2.png",
			icon_offset = Point(0,0),
			desc_title = "Randomness Matrix",
			desc_text = "Each turn, rolls a number, damage changes with number. This turn's outcome is: 2, Damage and healing are not affected.",
		}
		trait:add{
			func = traitfunc_Nico_RNG3,
			pilotSkill = "NicoRNGskill",
			icon = path.."img/combat/icons/icon_dice3.png",
			icon_offset = Point(0,0),
			desc_title = "Randomness Matrix",
			desc_text = "Each turn, rolls a number, damage changes with number. This turn's outcome is: 3, Damage and healing are increased by 1.",
		}
		trait:add{
			func = traitfunc_Nico_RNG4,
			pilotSkill = "NicoRNGskill",
			icon = path.."img/combat/icons/icon_dice4.png",
			icon_offset = Point(0,0),
			desc_title = "Randomness Matrix",
			desc_text = "Each turn, rolls a number, damage changes with number. This turn's outcome is: 4, Damage and healing are increased by 1.",
		}
		trait:add{
			func = traitfunc_Nico_RNG5,
			pilotSkill = "NicoRNGskill",
			icon = path.."img/combat/icons/icon_dice5.png",
			icon_offset = Point(0,0),
			desc_title = "Randomness Matrix",
			desc_text = "Each turn, rolls a number, damage changes with number. This turn's outcome is: 5, Damage and healing are increased by 2.",
		}
		trait:add{
			func = traitfunc_Nico_RNG6,
			pilotSkill = "NicoRNGskill",
			icon = path.."img/combat/icons/icon_dice6.png",
			icon_offset = Point(0,0),
			desc_title = "Randomness Matrix",
			desc_text = "Each turn, rolls a number, damage changes with number. This turn's outcome is: 6, Damage is DEATH, Healing heals 10 hp.",
		}
end
return this