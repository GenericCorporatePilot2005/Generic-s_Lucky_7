
-- init.lua is the entry point of every mod

local mod = {
	id = "Nico_V1_Pilot",
	name = "V1 The Machine",
	version = "3 isn't canon.",
	requirements = {},
	modApiVersion = "2.3.0",
	icon = "img/mod_icon.png",
	description = "The Ultimate war machine playing in the side of humanity as a whole for the first time in its existence, PRAY that endless Vek blood will suffice it.\nPortraits made by Hedera.",
}

function mod:init()
	local pilotV1 = require(self.scriptPath .."pilot1")
	local pilotV2 = require(self.scriptPath .."pilot2")
	require(self.scriptPath.."personality")
	require(self.scriptPath.."suppressDialog")
	pilotV1:init(mod)
	pilotV2:init(mod)
	local replaceRepair_B = mod_loader.mods.Nico_pilots.replaceRepair_B
end

function mod:load(options, version)
end

return mod
