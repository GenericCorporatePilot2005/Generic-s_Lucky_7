-- Adds a personality without the use of a csv file.

-- Unique identifier for personality.
local personality = "NicoTaunt"
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
		Gamestart = {"#self_full reporting for duty Commander, it's an honor to be here.","T-417 systems online, I am ready when you are Commander.","From this high it looks so peaceful, if only it was true."},
		FTL_Found = {"Commander, unknown life form detected aboard, proceed with caution.","Commander, we've found something on that pod, it looks friendlier enough to cooperate."},
		Gamestart_PostVictory = {"#self_second reporting for duty once again, let's keep the flow going.","1 timeline saved, infinite more left, let's keep going.","Last attempt was good, let's make this one even better.","Let's hope Kern finds our mechs on the Hive's ruins, I left a backup of T-417's blueprints there for them to use."},
		Death_Revived = {"That was closer, we gotta be more careful.","Systems back on, thank God.","Played with more fire that I would've like there."},
		Death_Main = {"#self_second speaking, my #main_mech is fa- lling apar-","Shit shit shi-", "No! Not now! Not ye-","Say #ceo_second I tried my bes-","Commander, focus on the Vek, I'll be fi-"},
		Death_Response = {"Fuck, #main_first's down, it's only us now.","The victims of war change, but not war, never war.","Let's give our all, for #main_full's sake!"},
		Death_Response_AI = {"AI unit down, let's compensate its absense.","#main_mech down, that's not good."},
		TimeTravel_Win = {"Kern, if you're hearing this, I'll leave the T-417's blueprints on a sealed capsule, use them well.","Job done #squad, time to go home and celebrate.", "#squad, it's been an honor, until next time.","The best victories end with a boom, this one? Starts with one."},
		Gameover_Start = {"Grid's down, it's over.","So close, let so far.","Sorry Commander, I failed you."},
		Gameover_Response = {"Retreat's the only way out now.","God Dammit we were so close","There's nothing we can do now..."},
	
	-- UI Barks
		Upgrade_PowerWeapon = {"Upgrade successfully installed.","This boost will come in handy later.","Commander's orders: upgrade achieved.",},
		Upgrade_NoWeapon = {"Commander, my T-417 is useful, but not invencible, please reconsider.","I don't recommend this tactic.","I don't think this is the way to go Commander"},
		Upgrade_PowerGeneric = {"I could use one of these to power up the T-417","These Core Reactors are the pinnacle in energy generation.","Good idea Commander."},
	
	-- Mid-Battle
		MissionStart = {"Systems online, booting up T-417, give me a second","T-417-Knon's calibration done, waiting for energy supply.", "Another day, another region to save, bring it on!", "remember #squad, just like we practised.", "#self_full reporting for Vek termination #ceo_full.","Time for out Parabellum"},
		Mission_ResetTurn = {"If only I could've rewound time that day...", "If Time flows like water we just climbed a waterfall.", "Let's try that again.", "Commander, take your time to find a solution, we don't have that many tries left."},
		MissionEnd_Dead = {"Battlefield empty, of Vek, at least.","Only debris is left now.","The only good battlefield is one clean of Vek.","The only good Vek is a dead one."},
		MissionEnd_Retreat = {"Adversaries in retreat.","Living to fight another day, just like us.","They come back stronger, I'm sure of it.","Vek on the run, at least the region's safe."},

		MissionFinal_Start = {"So this is Hell's Valley, fill to the brim with Vek.","#squad, Victory awaits us on the bottom of this hellscape","Thank God my suit is isolated from the heat.","My mech is not responding, this isn't good."},
		MissionFinal_StartResponse = {"Mech's back online, preparing for battle.", "May this scorched wasteland be the Vek's tomb.","Finally, some building free buildings"},
		--MissionFinal_FallStart = {},
		MissionFinal_FallResponse = {"Seismic activity incoming, hold on tight!","Gravity's not on our side now.","Long fall awaits us, put your seatbelts on."},
		--MissionFinal_Pylons = {},
		MissionFinal_Bomb = {"This is not good, we're underarmed for this.","This is the biggest cave I've ever seen.", "This cave always surprises me in terms of size.", "Thank God we're not supposed to destroy this Hive ourselves."},
		--MissionFinal_BombResponse = {},
		MissionFinal_CaveStart = {"Attention, #squad. Guard the bomb, there's no room for error if it's destroyed.","You know the drill #self_full, you've come so far.","Protect the bomb, save humanity, simple enough."},
		--MissionFinal_BombDestroyed = {},
		MissionFinal_BombArmed = {"Bomb's ready, let's get out of here!","The bomb is primed, about time.","#squad, time to retreat!"},

		PodIncoming = {"My radar detects a Pod, I already triangulated the landing location.","A pod is on the way."},
		PodResponse = {"Defend the pod, someone could be there.","Defend the pod, its technology could help later.","Civilians first, pod second, don't forget that."},
		PodCollected_Self = {"I got the pod, we'll see its content later","Pod's obtained, we'll see if there's someone on it later"},
		PodDestroyed_Obs = {"Pod's gone, that's a shame.","Pod's gone, let's hope there wasn't anyone there."},
		Secret_DeviceSeen_Mountain = {"Commander, I think there's something in that mountain over there, I've sent you the cordinates.","Mountains don't glow yellow in this timeline, do they?","I detect something strange in one of this region's mountains, we should check that."},
		Secret_DeviceSeen_Ice = {"Something's under the ice, we should check it sooner or later.","The permafrost hides something, we should check it."},
		Secret_DeviceUsed = {"I seem to have triggered whatever this device is, keep an eye out for anything weird.","Commander, the strange device has been activated, awaiting orders."},
		Secret_Arriving = {"Now that's a hella strange Pod.","Commander, that pod doesn't look like anything I've seen before, do we protect it as usual?."},
		Emerge_Detected = {"Surfacing spots detected, waiting for orders.","The Vek intend to emerge.","Emerging Imminent.","Enemy backup incomming."},
		Emerge_Success = {"We've got company.","This ain't good.","From the depths they rise.","Enemy backup arrived Commander."},
		Emerge_FailedMech = {"Commander, I don't think this is the most optimal way for me to engage in the fight.","Let's hope no one attacks me while I'm with my defense down."},
		Emerge_FailedVek = {"Thanks for that.","Vek threat stopped another, perfect.", "That's how I like it.", "Commander, they're stopping each other, I recommend exploiting that."},

	-- Mech State
		Mech_LowHealth = {"And when I JUST repaired my mech.","It would be better if only I left my mech in this state thank you so much.", "Commander, I am once again at Death's door, don't let the Vek knock."},
		Mech_Webbed = {"I would've preferred if you hadn't target me, not yet at least.","I'm immobilized, it's not a safe choice to use my T-417 for now.", "This will be a hassle to clean with the repair crew.", "Commander, the Vek stopped my #self_mech dead on its tracks, what should we do now?", "Just like we needed, now I can't move."},
		Mech_Shielded = {"That's more like it.","Shield technology is a life saver.","Shield deployed.","One hit free of charge, let's make it count Commander."},
		Mech_Repaired = {"There we go.","The less close to death I am the better.","The only bad part of the T-417 is how fragile I end up being, this will help for a while.",},
		Pilot_Level_Self = {"I kindly accept it.","The honor is mine, I assure you.", "I'm just doing all I can do, no need for a promotion."},
		Pilot_Level_Obs = {"That's how it's done #main_first, congratulations!.","Well done!","#main_full here really is making #squad proud."},
		Mech_ShieldDown = {"I made the most of what I could with that shield, so don't worry.","There are more we that one came from, don't worry.","Better me than the buildings, that's what I say."},

	-- Damage Done
		Vek_Drown = {"I wonder why they invaded Earth after the global flood, it feels counter productive.\nNot that I'm complaining-","Thank God that one couldn't swim.","Vek drowned with water, I'm drowned with joy."},
		Vek_Fall = {"Mind were you walk if you don't want to end like that Vek.","I doubt even my shields can protect from such fall.","I wonder how deep that fall will be."},
		Vek_Smoke = {"Now you see, now you don't.","Smoked Vek, my favorite.","Thank God they can't see through that."},
		Vek_Frozen = {"Woundn't the cold kill them eventually? we should let it be then.","It's like a winter wonderland! Not so 'wonderland' for the Vek though.","the coolest way to say immobilize a threat."},
		VekKilled_Self = {"Kill confirmed.","There's more where that came from.","Just another day, another killed.","♪ Another bug bites the dust ♪"},
		VekKilled_Obs = {"Color me surprised.","Well done!","well done #main_second."},
		VekKilled_Vek = {"Commander, death by friendly fire confirmed.","Huh, guess they're aren't as smart as I thought","That was good, let's make it happen again.","Vek taking each other out? Nice."},

		DoubleVekKill_Self = {"Two Vek, one stone.","Two less to worry about.","I'm a fan of efficiency.","Two down, countless more to go.","It's almost too easy."},
		DoubleVekKill_Obs = {"Two bugs down, you're knocking it out of the park #main_first!","Two Vek down, fantastic.","Nicely done!"},
		DoubleVekKill_Vek = {"What?","Times like these make me doubt how dangerous they are.", "Two Vek, one stone, but the stone is a third Vek."},

		MntDestroyed_Self = {"Commander, the path has been cleared","Changing the landscape, one blast at a time.","Breaking barriers, even the rocky ones."},
		MntDestroyed_Obs = {"Let's use that opening in our advantage, shall we?","I didn't know #main_first was demolition expert.", "Who needs TNT when you have we have #main_full?"},
		MntDestroyed_Vek = {"Man, these Vek really are something.","The Vek brought down a mountain, keep an eye out for any path they can use to move around.","I've heard of dynamic landscapes, but this is taking it to a whole new level."},

		PowerCritical = {"Grid hangs on a string, DO NOT LET IT FALL.","The Grid on the edge? that's not good.", "Grid levels are plummeting, this isn't a drill.","The Grid's flirting with disaster. We need to turn this around, and fast."},
		Bldg_Destroyed_Self = {"I'm so sorry."},
		Bldg_Destroyed_Obs = {"Which the fuck was that #main_first?!","Huh? Oh, great.","Well, now that's just fantastic."},
		Bldg_Destroyed_Vek = {"That Vek is mine.","Do NOT let that Vek get out of here free of charge.","Great, just what we needed.","I swear, these Vek are like wrecking balls that walk.","Oh, for the love of-"},
		Bldg_Resisted = {"Let's go!","Building resisted, but we can't relax just yet.","resisted to be defended another day"},


	-- Shared Missions
		Mission_Train_TrainStopped = {"Train stopped, now's a sitting duck.", "Take cover, passengers! We've got this!", "Train at a standstill, don't let it be destroyed."},
		Mission_Train_TrainDestroyed = {"And there goes the Train... #ceo_first won't like this.","as if stopping it wasn't enough.","Horace's down..."},
		Mission_Block_Reminder = {"Don't let the Vek surface, order from #corp.","Don't get too comfortable, #squad. Vek love popping up unexpectedly."},

	-- Archive
		Mission_Airstrike_Incoming = {"Heads up, team! Incoming air strike.","Commander, air strike inbound.","Brace yourselves for the fireworks!","Glad they got the old planes working again."},
		Mission_Tanks_Activated = {"Man, these tanks never disappoint","#ceo_first got them ol' tanks running, nice!"},
		Mission_Tanks_PartialActivated = {"1 is better than none.","Man I used to pilot one of these, so long ago."},
		Mission_Dam_Reminder = {"The dam must go down, if anyone finds an opening, destroy it","I hope there are no cities downstream. For, er, multiple reasons."},
		Mission_Dam_Destroyed = {"Commander, the dam has fallen.","Quite deep for a river."},
		Mission_Satellite_Destroyed = {"Sory #ceo_first.","Dammit!"},
		Mission_Satellite_Imminent = {"Stand back!","3, 2, 1..."},
		Mission_Satellite_Launch = {"I remember seeing them launch when I was younger, simpler times, better times...","#ceo_second will like this"},
		Mission_Mines_Vek = {"Mine fields... no, not again, not this time.","Try to bait the Vek into them if you see the chance."},

	-- RST
		Mission_Terraform_Destroyed = {"Dammit.","Super weapons aren't worth much when they're nothing but debris.","Terraformer down, I repeat, terraformer down!"},
		Mission_Terraform_Attacks = {"RST's technology doesn't hold back.","That sure is powerful"},
		Mission_Cataclysm_Falling = {"Watch your step, the ground is about to go down.","Prepare for some ground turbulence.","Things are about to get shaky.","Incoming ground anomalies, #squad."},
		Mission_Lightning_Strike_Vek = {"Well, thanks for that I guess.","A random lightning will not outclass us.","Commander, Lightnings seem to completely nullify Vek, take that into account."},
		Mission_Solar_Destroyed = {"That's unfortunate.","Solar pannel destroyed, let's be more careful next time"},
		Mission_Force_Reminder = {"Let's, uh, break some mountains.","#corp said we should flatten the terrain, don't forget that."},

	-- Pinnacle
		Mission_Freeze_Mines_Vek = {"Walked right into it","You were asking for it.","I'm glad that we have so many of those."},
		Mission_Factory_Destroyed = {"I know it has a hassle, but we needed to defend that.","Factory's down, #ceo_full will not like this."},
		Mission_Factory_Spawning = {"Until #ceo_first fixes its bots, we'll have to tolerate them","Rogue factory deployed more threats, proceed with caution."},
		Mission_Reactivation_Thawed = {"I'm free don't worry.","That's better."},
		Mission_SnowStorm_FrozenVek = {"Someone wasn't ready for winter.","Are Vek cold-blooded?","Vek Frozen, I recommend leaving them there."},
		Mission_SnowStorm_FrozenMech = {"My shield doesn't turn on if I'm frozen, I'll try to exploit that.","My suit protects me from the cold, but not my mech.","I try to convince a Vek to free me, wish me luck."},
		BotKilled_Self = {"Sorry for that #corp.","You left no other choice."},
		BotKilled_Obs = {"Talk about a 'Glass Cannon'.","For the punch they pack, their defenses suck...\nI kind of relate."},

	-- Detritus
		Mission_Disposal_Destroyed = {"One of the most powerful weapons I've ever seen, done just like that.", "Disposal down, its absense will be felt."},
		Mission_Disposal_Activated = {"Disposal activated, be cautious.","'Pain like that rain that's falling'."},
		Mission_Barrels_Destroyed = {"Not a big fan of Chemical warfare, I must admit.","Barrel down, let's use the acid to our advantage"},
		Mission_Power_Destroyed = {"That's not good","That's a shame."},
		Mission_Teleporter_Mech = {"Huh? where am I?!", "My suit's radar has gone crazy where am I?"},
		Mission_Belt_Mech = {"I wonder how practical these conveyors really are.","I'm on my way."},

	-- AE
		Mission_ACID_Storm_Start = {"Commander, I detect high amounts of corrosive rain, be careful.","God dammit as if Detritus wasn't dangerous enough",},
		Mission_ACID_Storm_Clear = {"Glad it stopped.","I missed the clear sky."},
		Mission_Wind_Mech = {"Wow, I am not used to this.","How hard would it be to stabilize my mech?"},
		Mission_Repair_Start = {"Why are my partners' mechs weakened like this, what happened?!","I helped with my #self_mech's repairs, I should've helped with the other mech's...","Commander, something happened, the other mechs are barely standing!","Once my T-417 is charged up, we'll all be at a big disadvantage."},
		Mission_Hacking_NewFriend = {"A friendly Bot, finally","Hacking tower is now offline and we made a new ally, perfect"},	
		Mission_Shields_Down = {"Ok I wasn't expecting that","Our's and the Vek's shields are down.","Time to get serious."},
	
	-- Meridia
		Mission_lmn_Convoy_Destroyed = {"The convoy was destroyed","Convoy down, let's cut our losses."},
		Mission_lmn_FlashFlood_Flood = {"Commander, the water will be our ally here, we gotta use it.","A weirdly efficient way to drown Vek."},
		Mission_lmn_Geyser_Launch_Mech = {"WHAT'S GOING O-","WHAT THE -","How strong are these geyser-"},
		Mission_lmn_Geyser_Launch_Vek = {"Haha, Commander are you seeing this?","Glad it wasn't me."},
		Mission_lmn_Volcanic_Vent_Erupt_Vek = {"Not even my suit could help me against that."},
		Mission_lmn_Wind_Push = {"And I thought that RST was a windy nightmare.","Be aware of your surroundings #squad, or else we'll knock into a building or each other."},
		Mission_lmn_Runway_Imminent = {"The place's about to take off, leave an opening!","That plane needs to take off!"},
		Mission_lmn_Runway_Crashed = {"I don't have luck with planes I'm telling you.","The plane crashed, before it even took flight, what a shame."},
		Mission_lmn_Runway_Takeoff = {"Let's go!","Plane took flight, it's now safe."},
		Mission_lmn_Greenhouse_Destroyed = {"Oh no...","that's not good."},
		Mission_lmn_Geothermal_Plant_Destroyed = {"Let's hope this doesn't affect the enviroment TOO much.","Really unfortunate."},
		Mission_lmn_Hotel_Destroyed = {"Isn't Meridia an institute? why would they have an hotel?.","For who is this hotel made? Not the locals I'll assume."},
		Mission_lmn_Agroforest_Destroyed = {"We could've defended that.","No survivors, not even the trees.", "Agroforest's reduce to ashes, #ceo_first won't like this."},

	-- Watchtower missions
		Mission_tosx_Sonic_Destroyed = {"Damn that thing was really loud, not that I'm glad about its destruction either.","Damn that thing was really useful, shame it wasn't exactly silent","An interesting execution of the same idea as my T-417, shame it didn't last long."},
		Mission_tosx_Tanker_Destroyed = {"All of this region will die of thrist, we failed them...","No! It can't be!"},
		Mission_tosx_Rig_Destroyed = {"#ceo_first is going to be so angry","Oh no."},
		Mission_tosx_GuidedKill = {"Glad these missiles pack the punch they that they pack.","Death falls from the sky, not on the #squad though!"},
		Mission_tosx_NuclearSpread = {"I detect an increase in nuclear radiation, keep an eye on your geiger counters","Radiation spreads, be careful y'all."},
		Mission_tosx_RaceReminder = {"I'm sad to say this, but one of these racers will not come back home","#ceo_second said that only one will win, I don't like what that implies."},
		Mission_tosx_MercsPaid = {"Only having loyalty to money is not wise, but it is efficient.","if this is what they need to abide the Commander, so be it."},
		Mission_tosx_RigUpgraded = {"If only our technology was as easy to upgrade...","Notify #ceo_full that we successfully upgraded their War Rig."},

	--FarLine barks
		Mission_tosx_Delivery_Destroyed = {"Delivery failed","Dammit."},
		Mission_tosx_Sub_Destroyed = {"... That could've been me."},
		Mission_tosx_Buoy_Destroyed = {"Uuhg, that's bad.","we should've kept an eye on that one."},
		Mission_tosx_Rigship_Destroyed = {"There goes our floor.","Now we gotta take the most advantage of the least floor possible."},
		Mission_tosx_SpillwayOpen = {"Spillway open, I'll hold on tight here.","As easy as that? Nice.","Commander, spillway activated, waiting for further command."},
		Mission_tosx_OceanStart = {"This isn't good.","Any idea on how we'll cover terrain if we're like this?"},
		Mission_tosx_RTrain_Destroyed = {"First time I've been glad of seeing a train be destroyed.","Train derailed successfully, massive casualities avoided."},
		
	-- Island missions
		Mission_tosx_Juggernaut_Destroyed = {"Why are most Bots here either fragile as cardboard or almost immortal?!","Juggernaut's down.",},
		Mission_tosx_Juggernaut_Ram = {"Try to avoid being on its path, I would recommend","We could use one of them, shame this is the last one.",},
		Mission_tosx_Zapper_On = {"Zapper is connected.","I've been promoted from soldier to cable, what an honor...",},
		Mission_tosx_Zapper_Destroyed = {"#ceo_second is going to kill us for that-","The zapper has fallen, we'll have to compensate the loss.",},
		Mission_tosx_Warper_Destroyed = {"Such amazing technology, destroyed like it was nothing.","And just when I started to get use to the portals...",},
		Mission_tosx_Battleship_Destroyed = {"Into the depths it goes.","At least it wasn't an iceberg this time.",},
		Mission_tosx_Siege_Now = {"COMMANDER, WE'RE GETTING AMBUSHED, PREPARE FOR THE WORST.","Oh no."},
		Mission_tosx_Plague_Spread = {"My suit can resist cancer, but I'm pretty sure it won't resist THAT","Commander, that Vek carries deadly pathogens, proceed with caution."},--I left it here
	
	-- Candy Land Mission Events
		Mission_Candy_SeederDestroyed = {"For something that generates mountain-likes, is not nearly as durable as one.","Seeder's down, Miss #ceo_first won't like this."},
		Mission_Candy_TruckDestroyed = {"The truck has been destroyed.","No more ice cream for us I guess."},
		Mission_Candy_UnicornHurt = {"Unicorn's down, we gotta protect it now.","Commander, the unicorn is where we want it, awaiting further instructions."},
		Mission_Candy_UnicornDestroyed = {"We overkilled it, dammit.","We had to protect it, you know?"},
		Mission_Candy_PinataDestroyed = {"Piñata down, let's collect the reward.","Reap what you Sow- er- Kill.","Collect the candy, we could need that boost."},
		Mission_Candy_BombDestroyed = {"The bomb has been destroyed.","We really don't have luck with bombs, do we?"},
		Mission_Candy_PicnicStain = {"Why does #ceo_second has a blanket this big?!","#ceo_first was asking for trouble having a blanket that big.","If fixing my #self_mech taught me anything, Vek blood is a hassle to clean."},
		Mission_Candy_PicnicTear = {"Let's hope she doesn't notice...","Commander, tearing the blanket removes the stained parts, should we proceed?","I guess that's one way to remove the stains."},
		Mission_Candy_RainbowRide = {"Talk about 'Catching the rainbow'","Commander, my mech is now potentiated, time to rock.","WOW! That didn't felt good, not on my stomatch..."},
		Mission_Candy_SuperMilkStorm = {"Thank God the ground is not made out of cookies or cereal, we would be swimming in milk otherwise.","How fucked up is the weather here?","People here use umbrellas or cereal bowls?","Commander, milk rains are getting worse, we have to be careful."},

		--Machin's Missions
		Mission_Machin_Botbuddy_Destroyed = {"And just when I was starting to like it...","Bot lost, they did their part as best as they could."},
		Mission_Machin_Botbuddy_Trained = {"If only our training was as simple.","Why is #ceo_full building death machines again?"},
		Mission_Machin_Fuel_Delivered = {"Laser Array has been activated, let's use it.","Commander, Laser Array has been fueled successfully."},
		Mission_Machin_Radio_Destroyed = {"Radio communication cut.","#ceo_first will kill us for this..."},
		Mission_Machin_Laser_Array_Destroyed = {"Let's hope that doesn't trigger any ripples in time...","Array's down, what a pity."},
		Mission_Machin_Warhead_Destroyed = {"Warhead detonated successfully.","One of these almost crush me at my youth."},
		
		--Karto's Missions
		kf_Env_Wildfire_BldgDanger = {"Fire nearby buildings, act with caution.","Keep the firefighters notified of that building."},
		kf_Env_Wildfire_Spreading = {"Fire is spreading, and FAST!","Hell is running loose here, we must do something about it."},
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