local this={}

-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- read out other files and add what they return to variables.
local mod = modApi:getCurrentMod()
local scriptPath = modApi:getCurrentMod().scriptPath
local replaceRepair = mod_loader.mods.Nico_pilots.replaceRepair
local suppressDialog = require(mod_loader.mods.Nico_pilots.scriptPath .."suppressDialog")
local trait = require(mod_loader.mods.Nico_pilots.scriptPath .."trait")

local pilotV1 = {
	Id = "Nico_Pilot_V1",					-- id must be unique. Used to link to art assets.
	Personality = "NicoMachine",        -- must match the id for a personality you have added to the game.
	Name = "V1",
	Rarity = 2,
	PowerCost = 1,
	Voice = "/voice/ai",				-- audio. look in pilots.lua for more alternatives.
	Skill = "Nico_V1skill",				-- pilot's ability - Must add a tooltip for new skills.
}

CreatePilot(pilotV1)

-- add assets - notice how the name is identical to pilot.Id
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_V1.png", path .."img/portraits/Nico_Pilot_V1.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_V1_2.png", path .."img/portraits/Nico_Pilot_V1_2.png")
	modApi:appendAsset("img/portraits/pilots/Nico_Pilot_V1_blink.png", path .."img/portraits/Nico_Pilot_V1_blink.png")

function this:init(mod)

	replaceRepair:addSkill{
		Name = "Blood Lust",
		Description = "Instead of repairing, does a melee attack that flips the target's attacks and damages, if the target has a queued attack, fully heals self.",
		weapon = "Nico_V1skill",
		pilotSkill = "Nico_V1skill",
		Icon = "img/weapons/V1Punchrepair.png",
		IsActive = function(pawn)
			return pawn:IsAbility(pilotV1.Skill)
		end
	}

	---- Parry ----
	Nico_V1skill = Skill:new{
		Name = "Parry",
		Description = "Instead of repairing, does a melee attack that flips the target's attacks and damages, if the target has a queued attack, fully heals self.",
		Icon = "img/weapons/V1Punchrepair.png",
		Flip = true,
		PathSize = 1, --This does the TargetArea on its own, no need for our own
		Damage=1,
		TipImage = { --You'll have to create a custom tip image if you want the enemy to fire
			Unit = Point(1,2),
			Enemy = Point(1,1),
			Target = Point(1,1),
			Queued = Point(3,1),
			Friendly = Point(3,1),
			CustomEnemy = "Firefly2",
			Length = 4,
		} --Check Science_Confuse in weapons_science.lua if you want an example
	}
	-- art, icons, animations
		modApi:appendAsset("img/effects/V1punch_D.png",mod.resourcePath.."img/effects/V1punch_D.png")
		modApi:appendAsset("img/effects/V1punch_L.png",mod.resourcePath.."img/effects/V1punch_L.png")
		modApi:appendAsset("img/effects/V1punch_R.png",mod.resourcePath.."img/effects/V1punch_R.png")
		modApi:appendAsset("img/effects/V1punch_U.png",mod.resourcePath.."img/effects/V1punch_U.png")
		modApi:appendAsset("img/effects/V1Blood.png",mod.resourcePath.."img/effects/V1Blood.png")
		
		ANIMS.V1punch_0 = Animation:new{
			Image = "effects/V1punch_U.png",
			NumFrames = 6,
			Time = 0.06,
			PosX = -22,
			PosY = -8,
		}
		
		ANIMS.V1punch_1 = ANIMS.V1punch_0:new{
			Image = "effects/V1punch_R.png",
			PosX = -21,
			PosY = -6,
		}
		
		ANIMS.V1punch_2 = ANIMS.V1punch_0:new{
			Image = "effects/V1punch_D.png",
			PosX = -24,
			PosY = -6,
		}
		
		ANIMS.V1punch_3 = ANIMS.V1punch_0:new{
			Image = "effects/V1punch_L.png",
			PosX = -22,
			PosY = -8,
		}
		ANIMS.V1Blood = Animation:new{
			Image = "effects/V1Blood.png",
			NumFrames = 8,
			Time = 0.08,
			
			PosX = -22,
			PosY = 1
		}

	function Nico_V1skill:GetSkillEffect(p1, p2)
		local ret = SkillEffect()
		local direction = GetDirection(p2-p1)
		local damage = SpaceDamage(p2, self.Damage, DIR_FLIP)
		damage.sAnimation = "V1punch_"..((direction+1)%4)
		local heal = SpaceDamage(p1,-10)
		heal.sAnimation="V1Blood"
		if Board:IsPawnSpace(p2) and Board:GetPawn(p2):IsQueued() then -- and Board:GetPawn(p2):GetDefaultFaction() ~= FACTION_BOTS and Board:GetPawnTeam(p2) == TEAM_ENEMY then
			ret:AddScript([[
			SuppressDialog(1200,"Mech_Repaired")
			SuppressDialog(1200,"VekKilled_Self")
			SuppressDialog(1200,"DoubleVekKill_Self")
			SuppressDialog(1200,"Vek_Drown")
			SuppressDialog(1200,"Vek_Fall")
			SuppressDialog(1200,"Vek_Smoke")
			]])
			ret:AddDamage(heal)
			ret:AddAnimation(damage.loc,"SwipeClaw2", ANIM_NO_DELAY)
			ret:AddScript([[local cast = { main = ]]..Board:GetPawn(p1):GetId()..[[ }
				modapiext.dialog:triggerRuledDialog("Mission_Nico_V1Parry", cast)
			]])
		end
		ret:AddBounce(p1,1)
		ret:AddBounce(p2,3)

		ret:AddMelee(p2 - DIR_VECTORS[direction], damage)
		return ret
	end
	
	V1Heal = {}
	function V1Heal:Heal(id,pawn)
		local ret = SkillEffect()
		local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
		for i,id in pairs(mechs) do
			if Board:GetPawn(id):IsAbility("Nico_V1skill") then
				local V1point = Board:GetPawn(id):GetSpace()
				local heal = SpaceDamage(V1point,-1)
				heal.sAnimation="V1Blood"
				ret:AddDamage(heal)
				Board:AddEffect(ret)
			end
		end
		return
	end
	local function EVENT_onModsLoaded()
		modapiext.dialog:addRuledDialog("Mission_Nico_V1Parry", {
			Odds = 100,
			{ main = "Mission_Nico_V1Parry" },
		})
		modapiext.dialog:addRuledDialog("Mission_Nico_V2GBreak", {
			Odds = 100,
			{ main = "Mission_Nico_V2GBreak" },
		})
		modapiext:addPawnDamagedHook(function(mission, pawn)		
			local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i,id in pairs(mechs) do
				if Board:GetPawn(id):IsAbility("Nico_V1skill") then
					if (pawn:GetTeam() == TEAM_ENEMY) and (pawn:GetTeam() ~= TEAM_BOTS) and not (_G[pawn:GetType()].Minor) then
						local point = pawn:GetSpace()
						if point:Manhattan(Board:GetPawnSpace(id)) == 1 then
							V1Heal:Heal(id,pawn)
						end
					end
				end
			end
		end)
	end
	
	modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

	--Pilot Trait
	trait:add{
		pilotSkill = "Nico_V1skill",
		icon = path.."img/combat/icons/Nico_V1_icon.png",
		icon_offset = Point(0,0),
		desc_title = "BLOOD IS FUEL",
		desc_text = "Whenever a Vek is damaged or dies adjacent to V1, V1 heals 1 HP.",
	}

end

return this