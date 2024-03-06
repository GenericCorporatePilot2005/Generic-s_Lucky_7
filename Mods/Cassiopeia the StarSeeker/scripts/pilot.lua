local this={}

-- read out other files and add what they return to variables.
local mod = modApi:getCurrentMod()
local scriptPath = mod.scriptPath
local path = mod_loader.mods[modApi.currentMod].resourcePath
local worldConstants = require(scriptPath .."worldConstants")
math.randomseed(os.time())
math.random() -- first value is useless

function this:init(mod)
	local pilot = {
		Id = "Pilot_Nico_Geode",	-- id must be unique. Used to link to art assets.
		Personality = "Vek",        -- must match the id for a personality you have added to the game.
		Name = "Cassiopeia",
		Rarity = 1,
		PowerCost = 0,
		Voice = "/voice/ai",		-- audio. look in pilots.lua for more alternatives.
		Skill = "NicoGeodeskill",	-- pilot's ability - Must add a tooltip for new skills.
	}
	
	CreatePilot(pilot)
	modApi:addPilotDrop{id = pilot.Id, pod = false, ftl = true }
	local options = mod_loader.currentModContent[mod.id].options
	local color = options["Nico_Geode_Sprite"].value
	
	-- add assets - notice how the name is identical to pilot.Id
		modApi:appendAsset("img/portraits/pilots/Pilot_Nico_Geode.png", path.."img/portraits/pilots/Pilot_Nico_Geode"..color..".png")
		modApi:appendAsset("img/portraits/pilots/Pilot_Nico_Geode_2.png", path.."img/portraits/pilots/Pilot_Nico_Geode"..color.."_2.png")
		modApi:appendAsset("img/portraits/pilots/Pilot_Nico_Geode_blink.png", path.."img/portraits/pilots/Pilot_Nico_Geode"..color.."_blink.png")
	local oldGetSkillInfo = GetSkillInfo
	function GetSkillInfo(skill)
		if skill == "NicoGeodeskill" then
			return PilotSkill("Recon Scouts", "At mission start deploys 1 Geode Hound, at level 1 deploys 2, at level 2, they get stronger.")
		end
		return oldGetSkillInfo(skill)
	end

	local function GetNotUser()
		for i = 0,2 do
			local mech = Board:GetPawn(i)
			if mech then
				if not mech:IsAbility("NicoGeodeskill") then
					return Board:GetPawn(i)
				end
			end
		end
		return nil
	end
	--Geode Hounds
        -- iterate our files and add the assets so the game can find them.
        modApi:appendAsset("img/effects/shotup_Nico_Gemling.png", path .."img/effects/shotup_Nico_Gemling"..color..".png")
        modApi:appendAsset("img/effects/explo_Gem.png", path .."img/effects/explo_Gem"..color..".png")
		modApi:appendAsset("img/portraits/npcs/Pilot_Gemling.png", path.."img/portraits/npcs/Pilot_Gemling"..math.random(1,2)..color..".png")
        modApi:appendAsset("img/units/player/Nico_Gemling.png", path .."img/units/player/Nico_gemling"..color..".png")
        modApi:appendAsset("img/units/player/Nico_Gemling_a.png", path .."img/units/player/Nico_gemling"..color.."_a.png")
        modApi:appendAsset("img/units/player/Nico_Gemling_death.png", path .."img/units/player/Nico_gemling"..color.."_death.png")
        modApi:appendAsset("img/weapons/Nico_Gemling_Clatter.png", path .."img/weapons/Nico_Gemling_Clatter"..color..".png")
        modApi:appendAsset("img/weapons/Nico_Gemling_Push.png", path .."img/weapons/Nico_Gemling_Push"..color..".png")
		local a=ANIMS
		a.Nico_Gemling =  a.MechUnit:new{ Image = "units/player/Nico_Gemling.png", PosX = -12, PosY = 8 }
		a.Nico_Gemlinga = a.MechUnit:new{ Image = "units/player/Nico_Gemling_a.png", PosX = -12, PosY = 6, NumFrames = 4 }
		a.Nico_Gemlingd = a.MechUnit:new{ Image = "units/player/Nico_Gemling_death.png",PosX = -33,PosY = -16,NumFrames = 10,Time = 0.14,Loop = false}
		a.Nico_explo_Gem = a.ExploAir1:new{
			Image = "effects/explo_Gem.png",
			NumFrames = 8,
			Time = 0.1,
			
			PosX = -10,
			PosY = 5
		}
		Nico_Gemling = DeployUnit_Bomby:new{
			Name = "Geode Hound",
			Health = 1,
			MoveSpeed = 3,
			Image = "Nico_Gemling",
			TempUnit = false,
			SkillList = { "Nico_Gemling_Clatter" },
			SoundLocation = "/mech/distance/bombling/",
			DefaultTeam = TEAM_PLAYER,
			ImpactMaterial = IMPACT_METAL,
			Corpse = false,
			Portrait = "npcs/Pilot_Gemling",
		}
		Nico_Gemling_Clatter = Skill:new{
			Name = "Cluster Clatter",
			Description = "Headbutts an adjacent tile, pushing any unit on it.",
			Class = "Unique",
			Icon = "weapons/Nico_Gemling_Clatter.png",
			PathSize = 1,
			Damage = 0,
			Upgrades = 0,
			TipImage = {
				Unit = Point(2,2),
				Enemy = Point(2,1),
				Target = Point(2,1),
				CustomPawn = "Nico_Gemling",
			},
		}
		function Nico_Gemling_Clatter:GetSkillEffect(p1, p2)
			local ret = SkillEffect()
			local direction = GetDirection(p2 - p1)
			local punch = SpaceDamage(p2,self.Damage,direction)
			punch.sAnimation = "airpush_"..direction
			ret:AddMelee(p1,punch)
			return ret
		end	
		Nico_Gemling_Push = Skill:new{
			Name = "Crystal Smash",
			Description = "Damages self, and pushes all units on tiles adjacent to it.",
			Class = "Unique",
			Icon = "weapons/Nico_Gemling_Push.png",
			Damage = 0,
			SelfDamage = 1,
			Upgrades = 0,
			LaunchSound = "/weapons/mercury_fist",
			TipImage = {
				Unit = Point(2,2),
				Enemy1 = Point(2,1),
				Target = Point(2,1),
				Enemy2 = Point(1,2),
				Friendly = Point(2,3),
				CustomPawn = "Nico_Gemling",
			},
		}
		function Nico_Gemling_Push:GetSkillEffect(p1, p2)
			local ret = SkillEffect()
			for i = DIR_START,DIR_END do
				local spaceDamage = SpaceDamage(p1 + DIR_VECTORS[i], self.Damage, i)
				spaceDamage.sSound = "/impact/generic/explosion"
				spaceDamage.sAnimation = "airpush_"..i
				ret:AddDamage(spaceDamage)
			end
			local selfDamage = SpaceDamage(p1,self.SelfDamage)
			if Board:GetPawn(selfDamage.loc):GetHealth() ~= 1 then
				selfDamage.sAnimation = "Nico_explo_Gem"
			end
			ret:AddDamage(SoundEffect(p1,self.LaunchSound))
			ret:AddBounce(selfDamage.loc,selfDamage.iDamage)
			ret:AddDamage(selfDamage)
			return ret
		end	
	--Lemon's Real Mission Checker
		local function isRealMission()
			local mission = GetCurrentMission()
			return true and mission ~= nil and mission ~= Mission_Test and Board and Board:IsMissionBoard()
		end
	--this section detects the event that triggers when End Turn is pressed
	EXCL = {"GetAmbience", "GetBonusStatus", "BaseUpdate", "UpdateMission", "GetCustomTile", "GetDamage", "GetTurnLimit", "BaseObjectives", "UpdateObjectives",} 

	for i,v in pairs(Mission) do 
		if type(v) == 'function' then 
			local oldfn = v 
			Mission[i] = function(...) 
				if not list_contains(_G["EXCL"], i) then 
					if i == "IsEnvironmentEffect" then
						if Game:GetTurnCount() == 0 then
							GetCurrentMission().Nico_GeodeDeployed = false
						end
					end
				end
				return oldfn(...) 
			end
		end
	end
	local function Nico_DeployGeodes(mission)
		if not isRealMission() then return end
		if Game:GetTurnCount() == 1 and Game:GetTeamTurn() == TEAM_PLAYER and not mission.Nico_GeodeDeployed and GameData then
			local pilot0 = GameData.current.pilot0
			local pilot1 = GameData.current.pilot1
			local pilot2 = GameData.current.pilot2
			mission.Nico_GeodeDeploySpaces = {}
			local ret = SkillEffect()
			local owner = SkillEffect()
			ret:AddSound("/weapons/artillery_volley")
			local notuser = GetNotUser():GetSpace()
			for k = 0,2 do
				local pawn = Board:GetPawn(k)
				local level1 = (k==0 and pilot0.level > 0) or (k==1 and pilot1.level > 0) or (k==2 and pilot2.level > 0)
				local level2 = (k==0 and pilot0.level > 1) or (k==1 and pilot1.level > 1) or (k==2 and pilot2.level > 1)
				if pawn:IsAbility("NicoGeodeskill") then
					local p1 = pawn:GetSpace()
					if p1 == Point( -1, -1 ) then p1 = notuser end
					local death = {}
					if mission.LiveEnvironment and mission.LiveEnvironment.Locations then
						for k,v in pairs(mission.LiveEnvironment.Locations) do death[#death + 1] = v end
					end
					local targets = extract_table(Board:GetReachable(p1, 3, PATH_FLYER))
					local seen = {}
					local avoid_water = true
					math.randomseed(os.time())
					local i = math.random(#targets)
					i = math.random(#targets)
					while (Board:IsBlocked(targets[i], PATH_PROJECTILE) or Board:IsTerrain(targets[i],TERRAIN_LAVA) or (Board:IsTerrain(targets[i],TERRAIN_WATER) and avoid_water) or Board:IsTerrain(targets[i],TERRAIN_HOLE) or Board:IsPawnSpace(targets[i]) or list_contains(mission.Nico_GeodeDeploySpaces,targets[i]) or list_contains(death,targets[i]) or Board:IsEdge(targets[i]) or Board:IsDangerousItem(targets[i]) or Board:GetCustomTile(targets[i]) == "ground_rail.png" or Board:GetCustomTile(targets[i]) == "ground_rail2.png" or Board:GetCustomTile(targets[i]) == "ground_rail3.png") do
						if not list_contains(seen,targets[i]) then seen[#seen + 1] = targets[i] end
						if #seen == #targets then avoid_water = false end
						i = math.random(#targets)
					end
					local deploy = SpaceDamage(targets[i],0)
					mission.Nico_GeodeDeploySpaces[#mission.Nico_GeodeDeploySpaces + 1] = targets[i]
					deploy.sPawn = "Nico_Gemling"
					worldConstants:setHeight(ret, 50)
					if p1 ~= notuser then
						ret:AddBounce(p1,1)
						ret:AddArtillery(p1,deploy,"effects/shotup_Nico_Gemling.png",NO_DELAY)
					else
						ret:AddDropper(deploy,"effects/shotup_Nico_Gemling.png")
					end
					owner:AddScript("Board:GetPawn("..targets[i]:GetString().."):SetOwner("..k..")")
					ret:AddBounce(deploy.loc,3)
					if level1 then
						if level2 then
							Nico_Gemling.Health = 2
							Nico_Gemling.SkillList = { "Nico_Gemling_Clatter", "Nico_Gemling_Push" }
						end
						seen = {}
						avoid_water = true
						while (Board:IsBlocked(targets[i], PATH_PROJECTILE) or Board:IsTerrain(targets[i],TERRAIN_LAVA) or (Board:IsTerrain(targets[i],TERRAIN_WATER) and avoid_water) or Board:IsTerrain(targets[i],TERRAIN_HOLE) or Board:IsPawnSpace(targets[i]) or list_contains(mission.Nico_GeodeDeploySpaces,targets[i]) or list_contains(death,targets[i]) or Board:IsEdge(targets[i]) or Board:IsDangerousItem(targets[i])) do
							if not list_contains(seen,targets[i]) then seen[#seen + 1] = targets[i] end
							if #seen == #targets then avoid_water = false end
							i = math.random(#targets)
						end
						local deploy2 = SpaceDamage(targets[i],0)
						mission.Nico_GeodeDeploySpaces[#mission.Nico_GeodeDeploySpaces + 1] = targets[i]
						deploy2.sPawn = "Nico_Gemling"
						if p1 ~= notuser then
							ret:AddArtillery(p1,deploy2,"effects/shotup_Nico_Gemling.png",NO_DELAY)
						else
							ret:AddDropper(deploy2,"effects/shotup_Nico_Gemling.png")
						end
						owner:AddScript("Board:GetPawn("..targets[i]:GetString().."):SetOwner("..k..")")
						ret:AddDelay(FULL_DELAY)
						ret:AddBounce(deploy2.loc,3)
					end
					worldConstants:resetHeight(ret)
				end
			end
			if ret.effect:size() > 1 then
				ret:AddSound("/impact/generic/mech")
				Board:AddEffect(ret)
				Board:AddEffect(owner)
			end
			mission.Nico_GeodeDeployed = true
		end
	end
	
	local function EVENT_onModsLoaded()
		modApi:addMissionUpdateHook(Nico_DeployGeodes)
	end
	
	modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
end

return this