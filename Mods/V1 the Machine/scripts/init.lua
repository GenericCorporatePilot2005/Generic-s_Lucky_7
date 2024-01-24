
-- init.lua is the entry point of every mod

local mod = {
	id = "Nico_V1_Pilot",
	name = "V1 The Machine",
	version = "2 is here too!",
	requirements = {},
	modApiVersion = "2.3.0",
	icon = "img/mod_icon.png",
	description = "Portraits made by Hedera.",
}

function mod:init()
	local pilotV1 = require(self.scriptPath .."pilot1")
	local pilotV2 = require(self.scriptPath .."pilot2")
	require(self.scriptPath.."personality")
	require(self.scriptPath.."suppressDialog")
	pilotV1:init(mod)
	pilotV2:init(mod)
	local replaceRepair = require(self.scriptPath.."replaceRepair/replaceRepair")
end

function mod:load(options, version)
end

return mod
