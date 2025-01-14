-- Adds a personality without the use of a csv file.

-- Unique identifier for personality.
local personality = "NicoMachine"
--squad's name: #squad
--pilot's name: #self_reverse
--#main_reverse
--name of other pilot: main_first
-- Table of responses to various triggers.
local tbl = {
		--Game States
		Gamestart = {"EARTH /// FIRST\nSKY HIGH","EARTH /// FIRST\nWALKING ON THE MOON","EARTH /// FIRST\nUNDER THE STARS","EARTH /// FIRST\nVARIATIONS ON A CLOUD","EARTH /// FIRST\nWHAT A WONDERFUL WORLD"},
		FTL_Found = {"THE PASSENGER(OF ANOTHER WORLD).","MESSAGER FROM THE STARS"},
		FTL_Start = {""},
		Gamestart_PostVictory = {"EARTH /// FIRST\n(NOT SO)ORDINARY WORLD","EARTH /// FIRST\nSAME OLD STORY","EARTH /// FIRST\nNO SURPRISES","EARTH /// FIRST\nMISTER BLUE SKY"},
		Death_Revived = {"+ BACK IN BLACK","+CLOSE BUT NO CIGAR","I WILL SURVIVE"},
		Death_Main = {"<HA HA HA HA>"},
		Death_Response = {""},
		Death_Response_AI = {""},
		TimeTravel_Win = {"E-"..math.random(3,5)..":VEK'S INFERNO-- STANDARD --\nTIME: S | KILLS: S | STYLE: S"},
		Gameover_Start = {"<HA HA HA HA>"},
		Gameover_Response = {"<HA HA HA HA>"},

	-- UI Barks
		Upgrade_PowerWeapon = {"<WEAPONRY UPGRADED>"},
		Upgrade_NoWeapon = {"<CAN'T ATTACK IF I HAVE NO WEAPONS EQUIPPED, DUMBASS>"},
		Upgrade_PowerGeneric = {"<UPGRADE EQUIPPED>"},

	-- Mid-Battle
		MissionStart = {"INTO THE FIRE","DOUBLE DOWN","THE VEKGRINDER","THREE MACHINE ARMY","<EXTERMINATION PROTOCOLS READY>"},
		Mission_ResetTurn = {"+ FLASHBACK","MECHANICAL HANDS ARE THE RULER OF EVERYTHING."},
		MissionEnd_Dead = {"EL MATADOR","+ BIG KILL"},
		MissionEnd_Retreat = {"MISTER FEAR.","RUN AWAY", },


		MissionFinal_Start = {"EARTH/// LAST ACT CLIMAX\nTO HELL AND BACK","EARTH/// LAST ACT CLIMAX\nLOVERS ON THE SUN", "EARTH/// LAST ACT CLIMAN\nREINFEILD'S INFERNO"},
		MissionFinal_StartResponse = {"LIGHT UP THE NIGHT"},
		--MissionFinal_FallStart = {""},
		MissionFinal_FallResponse = {"GOING UNDERGROUND","DOWN UNDER", "DIVER DOWN"},
		--MissionFinal_Pylons = {""},
		MissionFinal_Bomb = {"<WE WILL NEED A BIGGER BOOM>"},
		--MissionFinal_BombResponse = {""},
		MissionFinal_CaveStart = {"PUMP UP THE JAM","THE FINAL COUNTDOWN.","BOOMBASTIC.","THE BOMB."},
		--MissionFinal_BombDestroyed = {""},
		MissionFinal_BombArmed = {"BYE BYE.","+ M.A.D."},

		PodIncoming = {"MESSAGES FROM THE STARS."},
		PodResponse = {"THE PASSENGER."},
		PodCollected_Self = {"TAKEN FOR A RIDE."},
		PodDestroyed_Obs = {"<HA HA HA HA>"},
		Secret_DeviceSeen_Mountain = {"+ SECRET"},
		Secret_DeviceSeen_Ice = {"+ SECRET"},
		Secret_DeviceUsed = {"+ SECRET"},
		Secret_Arriving = {"MESSAGES FROM THE STARS"},
		Emerge_Detected = {"<NEXT WAVE LOADING>"},
		Emerge_Success = {"WELCOME TO THE JUNGLE"},
		Emerge_FailedMech = {"+ BLOCKED","+ INTERRUPTED"},
		Emerge_FailedVek = {"+ BLOCKED","+ INTERRUPTED","+ FRIENDLY FIRE"},

	-- Mech State
		Mech_LowHealth = {"<high pitch noises>"},
		Mech_Webbed = {"+ HOOKED","LEAVE ME ALONE"},
		Mech_Shielded = {"+ PROTECTED"},
		Mech_Repaired = {"<REPAIRS COMPLETED>"},
		Pilot_Level_Self = {"Destructive.","Chaotic.","Brutal.","Anarchic.","Supreme.","SSadistic.","SSShitstorm.","ULTRAKILL."},
		Pilot_Level_Obs = {"+ TEAMWORK."},
		Mech_ShieldDown = {"<high pitch noises>"},
		Mission_Nico_V1Parry = {"+ PARRY"},
		Mission_Nico_V2GBreak = {"+ GUARDBREAK"},

	-- Damage Done
		Vek_Drown = {"+ CANNONBALLED","+ ENVIROKILL"},
		Vek_Fall = {"+ FALL","+ LONG WAY DOWN","+ SPLATTERED"},
		Vek_Smoke = {"+ SMOKED","+ INTERRUPTION"},
		Vek_Frozen = {"+ FROZEN", "BELOW ZERO"},
		VekKilled_Self = {"+ KILL","+ BIG KILL","+ HEADSHOT","+ BIG HEADSHOT","+ LIMB HIT"},
		VekKilled_Obs = {"+ TEAMWORK"},
		VekKilled_Vek = {"+ FRIENDLY FIRE"},

		DoubleVekKill_Self = {"+ DOUBLE KILL"},
		DoubleVekKill_Obs = {"+ TEAMWORK"},
		DoubleVekKill_Vek = {"+ FRIENDLY FIRE"},

		MntDestroyed_Self = {"+ CRUSHED"},
		MntDestroyed_Obs = {"+ CRUSHED"},
		MntDestroyed_Vek = {"+ CRUSHED"},

		PowerCritical = {"IT'S GOING DOWN NOW"},
		Bldg_Destroyed_Self = {"+ FRIENDLY FIRE"},
		Bldg_Destroyed_Obs = {"+ FRIENDLY FIRE"},
		Bldg_Destroyed_Vek = {"+ FRIENDLY FIRE"},
		Bldg_Resisted = {"+ RESISTED"},


	-- Shared Missions
		Mission_Train_TrainStopped = {"DON'T STOP THE PARTY","PLEASE DON'T STOP THE MUSIC","DON'T STOP ROLLING","+ FULL IMPACT"},
		Mission_Train_TrainDestroyed = {"+ EXPLODED"},
		Mission_Block_Reminder = {"<CHALLENGE: BLOCK 3 VEK SPAWNS> STATUS: INCOMPLETE"},

	-- Archive
		Mission_Airstrike_Incoming = {"+ SKYFALL","+ IT'S RAINING MEN"},
		Mission_Tanks_Activated = {"+ THE CAVALRY HAS ARRIVED","+ TIME TO ROCK"},
		Mission_Tanks_PartialActivated = {"+ WAKEY WAKEY","+ PANZER FAUST","TANK!"},
		Mission_Dam_Reminder = {"<CHALLENGE: DESTROY THE DAM> STATUS: INCOMPLETE"},
		Mission_Dam_Destroyed = {"+ OPEN THE FLOODGATES"},
		Mission_Satellite_Destroyed = {"+ EXPLODED"},
		Mission_Satellite_Imminent = {"FLIGHT OF THE KNIFE"},
		Mission_Satellite_Launch = {"+ FIREWORKS","I'M ON TOP OF THE WORLD","+ A SMALL STEP FOR MAN"},
		Mission_Mines_Vek = {"+ EXPLODED","+ SERVED","+ LANDYOURS"},

	-- RST
		Mission_Terraform_Destroyed = {"+ EXPLODED"},
		Mission_Terraform_Attacks = {"+ OVERKILL"},
		Mission_Cataclysm_Falling = {"IT'S GOING DOWN"},
		Mission_Lightning_Strike_Vek = {"+ CONDUCTOR","+ ZAPPED"},
		Mission_Solar_Destroyed = {"+ EXPLODED"},
		Mission_Force_Reminder = {"<CHALLENGE: DESTROY 2 MOUNTAINS> STATUS: INCOMPLETE"},

	-- Pinnacle
		Mission_Freeze_Mines_Vek = {"+ FROZEN"},
		Mission_Factory_Destroyed = {"+ EXPLODED"},
		Mission_Factory_Spawning = {"NEW INVENTION"},
		Mission_Reactivation_Thawed = {"+ ICE BREAKER"},
		Mission_SnowStorm_FrozenVek = {"+ FROZEN"},
		Mission_SnowStorm_FrozenMech = {"+ ICE BREAKER"},
		BotKilled_Self = {"MR. ROBOTO"},
		BotKilled_Obs = {"MR. ROBOTO"},

	-- Detritus
		Mission_Disposal_Destroyed = {"+ EXPLODED"},
		Mission_Disposal_Activated = {"+ OVERKILL"},
		Mission_Barrels_Destroyed = {"+ EXPLODED"},
		Mission_Power_Destroyed = {"+ EXPLODED"},
		Mission_Teleporter_Mech = {"+ THINKING WITH PORTALS"},
		Mission_Belt_Mech = {"+ RELOCATED"},
		
	-- AE
		Mission_ACID_Storm_Start = {"NOVEMBER RAIN.","+PAIN LIKE THE RAIN THAT'S FALLING",},
		Mission_ACID_Storm_Clear = {"MISTER BLUE SKY."},
		Mission_Wind_Mech = {"COLD WINDS.",},
		Mission_Repair_Start = {"<LOW ENERGY>",},
		Mission_Hacking_NewFriend = {"+ FRIENDSHIP WINS"},	
		Mission_Shields_Down = {"+ EXPLODED"},

 	-- Meridia
		Mission_lmn_Convoy_Destroyed = {"+ ROAD KILL","+ FULL IMPACT"},
		Mission_lmn_FlashFlood_Flood = {"+ OPEN THE FLOODGATES"},
		Mission_lmn_Geyser_Launch_Mech = {"+ CATAPULTED"},
		Mission_lmn_Geyser_Launch_Vek = {"+ CATAPULTED"},
		Mission_lmn_Volcanic_Vent_Erupt_Vek = {"+ FRIED"},
		Mission_lmn_Wind_Push = {"COLD WINDS"},
		Mission_lmn_Runway_Imminent = {"FLIGHT OF THE KNIFE"},
		Mission_lmn_Runway_Crashed = {"+ ROAD KILL","+ EXPLODED","+ FULL IMPACT"},
		Mission_lmn_Runway_Takeoff = {"FLIGHT OF THE KNIFE"},
		Mission_lmn_Greenhouse_Destroyed = {"+ EXPLODED"},
		Mission_lmn_Geothermal_Plant_Destroyed = {"+ EXPLODED"},
		Mission_lmn_Hotel_Destroyed = {"+ EXPLODED"},
		Mission_lmn_Agroforest_Destroyed = {"+ EXPLODED"},
	
	--Far Line
		Mission_tosx_Delivery_Destroyed = {"+ EXPLODED"},
		Mission_tosx_Sub_Destroyed = {"+ EXPLODED"},
		Mission_tosx_Buoy_Destroyed = {"+ EXPLODED"},
		Mission_tosx_Rigship_Destroyed = {"+ EXPLODED","CUT THE BRIDGE"},
		Mission_tosx_SpillwayOpen = {"+ OPEN THE FLOODGATES"},
		Mission_tosx_OceanStart = {"DEEP BLUE.","OCEAN MAN."},
		Mission_tosx_RTrain_Destroyed = {"+ DEAD IN ITS TRACKS"},
	
	--Nautilus
		Mission_Nautilus_CrumblingReaction = {"IT'S GOING DOWN.","DOWN UNDER",""},
		Mission_Nautilus_ExcavatorDestroyed = {"+ EXPLODED",},
		Mission_Nautilus_DrillerDestroyed = {"+ EXPLODED",},
		Mission_Nautilus_BlastChargeDestroyed = {"+ EXPLODED",},
		Mission_Nautilus_BlastChargeExploded = {"+ EXPLODED","+ FIREWORKS"},
		Mission_Nautilus_RailLayerDamaged = {"",},
		Mission_Nautilus_RailLayerDestroyed = {""},

	-- Island missions
		Mission_tosx_Juggernaut_Destroyed = {"MR ROBOTO"},
		Mission_tosx_Juggernaut_Ram = {"FREE BIRD.","+ ROAD KILL","THE HEAVY."},
		Mission_tosx_Zapper_On = {"+ CONDUCTOR","+ ZAPPED"},
		Mission_tosx_Zapper_Destroyed = {"+ EXPLODED","<THE ONLY WAY IT COULD'VE ENDED>"},
		Mission_tosx_Warper_Destroyed = {"+ EXPLODED"},
		Mission_tosx_Battleship_Destroyed = {"INTO THE ABYSS","+ SANK"},
		Mission_tosx_Siege_Now = {"<STATUS: NEW WAVE ARRIVING>"},
		Mission_tosx_Plague_Spread = {""},

	-- Candy Land Mission Events
		Mission_Candy_SeederDestroyed = {"+ EXPLODED"},
		Mission_Candy_TruckDestroyed = {"+ EXPLODED","ISCREAM"},
		Mission_Candy_UnicornHurt = {"+ HUNTED"},
		Mission_Candy_UnicornDestroyed = {"+ KILL"},
		Mission_Candy_PinataDestroyed = {"+ SWEET TOOTH"},
		Mission_Candy_BombDestroyed = {"+ SET IT OFF"},
		Mission_Candy_PicnicStain = {""},
		Mission_Candy_PicnicTear = {"+ RIP IT OFF"},
		Mission_Candy_RainbowRide = {"CATCH THE RAINBOW"},
		Mission_Candy_SuperMilkStorm = {"+ DAIRY WEATHER"},

	--Machin's Missions
		Mission_Machin_Botbuddy_Destroyed = {"MR ROBOTO"},
		Mission_Machin_Botbuddy_Trained = {"+ TRAINED"},
		Mission_Machin_Fuel_Delivered = {"+ TIME TO ROCK"},
		Mission_Machin_Radio_Destroyed = {"<THE ONLY WAY IT COULD'VE ENDED>"},
		Mission_Machin_Laser_Array_Destroyed = {"+ PARADOX"},
		Mission_Machin_Warhead_Destroyed = {"+ EXPLODED"},
	
	--Karto's Missions
		kf_Env_Wildfire_BldgDanger = {"+ FRIED"},
		kf_Env_Wildfire_Spreading = {"+ AMAZON"},
}

-- inner workings. no need to modify.
local PilotPersonality = {""}

function PilotPersonality:GetPilotDialog(event)
	if self[event] ~= nil then 
		if type(self[event]) == "table" then
			return random_element(self[event])
		end
		
		return self[event]
	end
	
	--LOG("No pilot dialog found for an event!")
	LOG("No pilot dialog found for "..event.." event in "..self.Label)
	return ""
end

Personality[personality] = PilotPersonality
for trigger, texts in pairs(tbl) do
	if
		type(texts) == 'string' and
		type(texts) ~= 'table'
	then
		texts = {texts}
	end
	
	assert(type(texts) == 'table')
	Personality[personality][trigger] = texts
end