-- Adds a personality without the use of a csv file.

-- Unique identifier for personality.
local personality = "NicoRNG"
--squad's name: #squad
--pilot's name: #self_reverse
--#main_reverse
--name of other pilot: main_first
-- Table of responses to various triggers.
local tbl = {
		--Game States
		Gamestart = {""},
		FTL_Found = {""},
		FTL_Start = {""},
		Gamestart_PostVictory = {""},
		Death_Revived = {""},
		Death_Main = {""},
		Death_Response = {""},
		Death_Response_AI = {""},
		TimeTravel_Win = {""},
		Gameover_Start = {""},
		Gameover_Response = {""},

	-- UI Barks
		Upgrade_PowerWeapon = {""},
		Upgrade_NoWeapon = {""},
		Upgrade_PowerGeneric = {""},

	-- Mid-Battle
		MissionStart = {""},
		Mission_ResetTurn = {""},
		MissionEnd_Dead = {""},
		MissionEnd_Retreat = {""},

		MissionFinal_Start = {"EARTH/// LAST ACT CLIMAX\nTO HELL AND BACK","EARTH/// LAST ACT CLIMAX\nLOVERS ON THE SUN"},
		MissionFinal_StartResponse = {"LIGHT UP THE NIGHT"},
		MissionFinal_FallStart = {""},
		MissionFinal_FallResponse = {"GOING UNDERGROUND","DOWN UNDER"},
		MissionFinal_Pylons = {""},
		MissionFinal_Bomb = {"<WE WILL NEED A BIGGER BOOM>"},
		MissionFinal_BombResponse = {""},
		MissionFinal_CaveStart = {"PUMP UP THE JAM","THE FINAL COUNTDOWN.","BOOMBASTIC.","THE BOMB."},
		MissionFinal_BombDestroyed = {""},
		MissionFinal_BombArmed = {"BYE BYE.","+ M.A.D."},

		PodIncoming = {"MESSAGES FROM THE STARS."},
		PodResponse = {"THE PASSENGER."},
		PodCollected_Self = {"TAKEN FOR A RIDE."},
		PodDestroyed_Obs = {""},
		Secret_DeviceSeen_Mountain = {""},
		Secret_DeviceSeen_Ice = {""},
		Secret_DeviceUsed = {"+ SECRET"},
		Secret_Arriving = {""},
		Emerge_Detected = {""},
		Emerge_Success = {""},
		Emerge_FailedMech = {"+ BLOCKED","+ INTERRUPTED"},
		Emerge_FailedVek = {"+ BLOCKED","+ INTERRUPTED","+ FRIENDLY FIRE"},

	-- Mech State
		Mech_LowHealth = {""},
		Mech_Webbed = {""},
		Mech_Shielded = {"+ PROTECTED"},
		Mech_Repaired = {"<REPAIRS COMPLETED>"},
		Pilot_Level_Self = {"Destructive.","Chaotic.","Brutal.","Anarchic.","Supreme.","SSadistic.","SSShitstorm.","ULTRAKILL."},
		Pilot_Level_Obs = {"+ TEAMWORK."},
		Mech_ShieldDown = {""},

	-- Damage Done
		Vek_Drown = {"+ CANNONBALLED"},
		Vek_Fall = {"+ FALL","+ LONG WAY DOWN","+ SPLATTERED"},
		Vek_Smoke = {"+ SMOKED","+ INTERRUPTION"},
		Vek_Frozen = {"+ FROZEN"},
		VekKilled_Self = {"+ KILL","+ BIG KILL","+ HEADSHOT","+ BIG HEADSHOT","+ LIMB HIT"},
		VekKilled_Obs = {""},
		VekKilled_Vek = {"+ FRIENDLY FIRE"},

		DoubleVekKill_Self = {"+ DOUBLE KILL"},
		DoubleVekKill_Obs = {""},
		DoubleVekKill_Vek = {"+ FRIENDLY FIRE"},

		MntDestroyed_Self = {"+ CRUSHED"},
		MntDestroyed_Obs = {""},
		MntDestroyed_Vek = {""},

		PowerCritical = {""},
		Bldg_Destroyed_Self = {""},
		Bldg_Destroyed_Obs = {""},
		Bldg_Destroyed_Vek = {""},
		Bldg_Resisted = {"+ RESISTED"},


	-- Shared Missions
		Mission_Train_TrainStopped = {""},
		Mission_Train_TrainDestroyed = {""},
		Mission_Block_Reminder = {""},

	-- Archive
		Mission_Airstrike_Incoming = {""},
		Mission_Tanks_Activated = {"+ THE CAVALRY HAS ARRIVED","+ TIME TO ROCK"},
		Mission_Tanks_PartialActivated = {"+ WAKEY WAKEY","+ PANZER FAUST"},
		Mission_Dam_Reminder = {""},
		Mission_Dam_Destroyed = {"+ OPEN THE FLOODGATES"},
		Mission_Satellite_Destroyed = {""},
		Mission_Satellite_Imminent = {""},
		Mission_Satellite_Launch = {"+ FIREWORKS"},
		Mission_Mines_Vek = {"+ EXPLODED","+ SERVED","+ LANDYOURS"},

	-- RST
		Mission_Terraform_Destroyed = {""},
		Mission_Terraform_Attacks = {"+ OVERKILL"},
		Mission_Cataclysm_Falling = {""},
		Mission_Lightning_Strike_Vek = {"+ CONDUCTOR"},
		Mission_Solar_Destroyed = {""},
		Mission_Force_Reminder = {""},

	-- Pinnacle
		Mission_Freeze_Mines_Vek = {"+ FROZEN"},
		Mission_Factory_Destroyed = {""},
		Mission_Factory_Spawning = {""},
		Mission_Reactivation_Thawed = {"+ ICE BREAKER"},
		Mission_SnowStorm_FrozenVek = {"+ FROZEN"},
		Mission_SnowStorm_FrozenMech = {"+ ICE BREAKER"},
		BotKilled_Self = {"MR. ROBOTO"},
		BotKilled_Obs = {"MR. ROBOTO"},

	-- Detritus
		Mission_Disposal_Destroyed = {""},
		Mission_Disposal_Activated = {"+ OVERKILL"},
		Mission_Barrels_Destroyed = {""},
		Mission_Power_Destroyed = {""},
		Mission_Teleporter_Mech = {"+ THINKING WITH PORTALS"},
		Mission_Belt_Mech = {"+ RELOCATED"},

 	-- Meridia
		Mission_lmn_Convoy_Destroyed = {"+ ROAD KILL"},
		Mission_lmn_FlashFlood_Flood = {"+ OPEN THE FLOODGATES"},
		Mission_lmn_Geyser_Launch_Mech = {"+ CATAPULTED"},
		Mission_lmn_Geyser_Launch_Vek = {"+ CATAPULTED"},
		Mission_lmn_Volcanic_Vent_Erupt_Vek = {"+ FRIED"},
		Mission_lmn_Wind_Push = {""},
		Mission_lmn_Runway_Imminent = {""},
		Mission_lmn_Runway_Crashed = {"+ ROAD KILL"},
		Mission_lmn_Runway_Takeoff = {""},
		Mission_lmn_Greenhouse_Destroyed = {""},
		Mission_lmn_Geothermal_Plant_Destroyed = {""},
		Mission_lmn_Hotel_Destroyed = {""},
		Mission_lmn_Agroforest_Destroyed = {""},
	
	-- Island missions
		Mission_tosx_Juggernaut_Destroyed = {""},
		Mission_tosx_Juggernaut_Ram = {"FREE BIRD","+ ROAD KILL"},
		Mission_tosx_Zapper_On = {"+ CONDUCTOR"},
		Mission_tosx_Zapper_Destroyed = {""},
		Mission_tosx_Warper_Destroyed = {""},
		Mission_tosx_Battleship_Destroyed = {""},
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