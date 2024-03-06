-- Adds a personality without the use of a csv file.

-- Unique identifier for personality.
local personality = "NicoPrometheus"
--[[
	#squad
	#corp

	#ceo_full
	#ceo_first
	#ceo_second

	#self_mech
	#self_full
	#self_first
	#self_second

	#main_mech
	#main_full
	#main_first
	#main_second
]]
-- Table of responses to various triggers.
local tbl = {
	--Game States
		Gamestart = {""}
		FTL_Found = {""}
		Gamestart_PostVictory = {""}
		Death_Revived = {""}
		Death_Main = {""}
		Death_Response = {""}
		Death_Response_AI = {""}
		TimeTravel_Win = {""}
		Gameover_Start = {""}
		Gameover_Response = {""}
	
	-- UI Barks
		Upgrade_PowerWeapon = {""}
		Upgrade_NoWeapon = {""}
		Upgrade_PowerGeneric = {""}
	
	-- Mid-Battle
		MissionStart = {""}
		Mission_ResetTurn = {""}
		MissionEnd_Dead = {""}
		MissionEnd_Retreat = {""}

		MissionFinal_Start = {""}
		MissionFinal_StartResponse = {""}
		--MissionFinal_FallStart = {},
		MissionFinal_FallResponse = {""}
		--MissionFinal_Pylons = {},
		MissionFinal_Bomb = {""}
		--MissionFinal_BombResponse = {},
		MissionFinal_CaveStart = {""}
		--MissionFinal_BombDestroyed = {},
		MissionFinal_BombArmed = {""}

		PodIncoming = {""}
		PodResponse = {""}
		PodCollected_Self = {""}
		PodDestroyed_Obs = {""}
		Secret_DeviceSeen_Mountain = {""}
		Secret_DeviceSeen_Ice = {""}
		Secret_DeviceUsed = {""}
		Secret_Arriving = {""}
		Emerge_Detected = {""}
		Emerge_Success = {""}
		Emerge_FailedMech = {""}
		Emerge_FailedVek = {""}

	-- Mech State
		Mech_LowHealth = {""}
		Mech_Webbed = {""}
		Mech_Shielded = {""}
		Mech_Repaired = {""}
		Pilot_Level_Self = {""}
		Pilot_Level_Obs = {""}
		Mech_ShieldDown = {""}

	-- Damage Done
		Vek_Drown = {""}
		Vek_Fall = {""}
		Vek_Smoke = {""}
		Vek_Frozen = {""}
		VekKilled_Self = {""}
		VekKilled_Obs = {""}
		VekKilled_Vek = {""}

		DoubleVekKill_Self = {""}
		DoubleVekKill_Obs = {""}
		DoubleVekKill_Vek = {""}

		MntDestroyed_Self = {""}
		MntDestroyed_Obs = {""}
		MntDestroyed_Vek = {""}

		PowerCritical = {""}
		Bldg_Destroyed_Self = {""}
		Bldg_Destroyed_Obs = {""}
		Bldg_Destroyed_Vek = {""}
		Bldg_Resisted = {""}


	-- Shared Missions
		Mission_Train_TrainStopped = {""}
		Mission_Train_TrainDestroyed = {""}
		Mission_Block_Reminder = {""}

	-- Archive
		Mission_Airstrike_Incoming = {""}
		Mission_Tanks_Activated = {""}
		Mission_Tanks_PartialActivated = {""}
		Mission_Dam_Reminder = {""}
		Mission_Dam_Destroyed = {""}
		Mission_Satellite_Destroyed = {""}
		Mission_Satellite_Imminent = {""}
		Mission_Satellite_Launch = {""}
		Mission_Mines_Vek = {""}

	-- RST
		Mission_Terraform_Destroyed = {""}
		Mission_Terraform_Attacks = {""}
		Mission_Cataclysm_Falling = {""}
		Mission_Lightning_Strike_Vek = {""}
		Mission_Solar_Destroyed = {""}
		Mission_Force_Reminder = {""}

	-- Pinnacle
		Mission_Freeze_Mines_Vek = {""}
		Mission_Factory_Destroyed = {""}
		Mission_Factory_Spawning = {""}
		Mission_Reactivation_Thawed = {""}
		Mission_SnowStorm_FrozenVek = {""}
		Mission_SnowStorm_FrozenMech = {""}
		BotKilled_Self = {""}
		BotKilled_Obs = {""}

	-- Detritus
		Mission_Disposal_Destroyed = {""}
		Mission_Disposal_Activated = {""}
		Mission_Barrels_Destroyed = {""}
		Mission_Power_Destroyed = {""}
		Mission_Teleporter_Mech = {""}
		Mission_Belt_Mech = {""}

	-- AE
		Mission_ACID_Storm_Start = {""}
		Mission_ACID_Storm_Clear = {""}
		Mission_Wind_Mech = {""}
		Mission_Repair_Start = {""}
		Mission_Hacking_NewFriend = {""}
		Mission_Shields_Down = {""}
	
	-- Meridia
		Mission_lmn_Convoy_Destroyed = {""}
		Mission_lmn_FlashFlood_Flood = {""}
		Mission_lmn_Geyser_Launch_Mech = {""}
		Mission_lmn_Geyser_Launch_Vek = {""}
		Mission_lmn_Volcanic_Vent_Erupt_Vek = {""}
		Mission_lmn_Wind_Push = {""}
		Mission_lmn_Runway_Imminent = {""}
		Mission_lmn_Runway_Crashed = {""}
		Mission_lmn_Runway_Takeoff = {""}
		Mission_lmn_Greenhouse_Destroyed = {""}
		Mission_lmn_Geothermal_Plant_Destroyed = {""}
		Mission_lmn_Hotel_Destroyed = {""}
		Mission_lmn_Agroforest_Destroyed = {""}

	-- Watchtower missions
		Mission_tosx_Sonic_Destroyed = {""}
		Mission_tosx_Tanker_Destroyed = {""}
		Mission_tosx_Rig_Destroyed = {""}
		Mission_tosx_GuidedKill = {""}
		Mission_tosx_NuclearSpread = {""}
		Mission_tosx_RaceReminder = {""}
		Mission_tosx_MercsPaid = {""}
		Mission_tosx_RigUpgraded = {""}

	--FarLine barks
		Mission_tosx_Delivery_Destroyed = {""}
		Mission_tosx_Sub_Destroyed = {""}
		Mission_tosx_Buoy_Destroyed = {""}
		Mission_tosx_Rigship_Destroyed = {""}
		Mission_tosx_SpillwayOpen = {""}
		Mission_tosx_OceanStart = {""}
		Mission_tosx_RTrain_Destroyed = {""}
		
	--Nautilus
		Mission_Nautilus_CrumblingReaction = {""}
		Mission_Nautilus_ExcavatorDestroyed = {""}
		Mission_Nautilus_DrillerDestroyed = {""}
		Mission_Nautilus_BlastChargeDestroyed = {""}
		Mission_Nautilus_BlastChargeExploded = {""}
		Mission_Nautilus_RailLayerDamaged = {""}
		Mission_Nautilus_RailLayerDestroyed = {""}

	-- Island missions
		Mission_tosx_Juggernaut_Destroyed = {""}
		Mission_tosx_Juggernaut_Ram = {""}
		Mission_tosx_Zapper_On = {""}
		Mission_tosx_Zapper_Destroyed = {""}
		Mission_tosx_Warper_Destroyed = {""}
		Mission_tosx_Battleship_Destroyed = {""}
		Mission_tosx_Siege_Now = {""}
		Mission_tosx_Plague_Spread = {""}
	
	-- Candy Land Mission Events
		Mission_Candy_SeederDestroyed = {""}
		Mission_Candy_TruckDestroyed = {""}
		Mission_Candy_UnicornHurt = {""}
		Mission_Candy_UnicornDestroyed = {""}
		Mission_Candy_PinataDestroyed = {""}
		Mission_Candy_BombDestroyed = {""}
		Mission_Candy_PicnicStain = {""}
		Mission_Candy_PicnicTear = {""}
		Mission_Candy_RainbowRide = {""}
		Mission_Candy_SuperMilkStorm = {""}

		--Machin's Missions
		Mission_Machin_Botbuddy_Destroyed = {""}
		Mission_Machin_Botbuddy_Trained = {""}
		Mission_Machin_Fuel_Delivered = {""}
		Mission_Machin_Radio_Destroyed = {""}
		Mission_Machin_Laser_Array_Destroyed = {""}
		Mission_Machin_Warhead_Destroyed = {""}
		
		--Karto's Missions
		kf_Env_Wildfire_BldgDanger = {""}
		kf_Env_Wildfire_Spreading = {""}
}

-- inner workings. no need to modify.
local PilotPersonality = {}

function PilotPersonality:GetPilotDialog(event)
	if self[event] ~= nil then 
		if type(self[event]) == "table" then
			return random_element(self[event])
		end
		
		return self[event]
	end
	
	--If I did everything right, this shouldn't trigger at all
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