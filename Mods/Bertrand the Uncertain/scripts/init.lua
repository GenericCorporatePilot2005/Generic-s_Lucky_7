
-- init.lua is the entry point of every mod

local mod = {
	id = "Nico_RNG_Pilot",
	name = "Bertrand the Uncertain",
	version = "0.1",
	requirements = {},
	modApiVersion = "2.3.0",
	description = "Critical Failures = -1 damage, deals 1 damage intead of healing.\nCritical Success = KILL damage, healing restores 10 hp.\nLow Average= +0.\nAverage= +1.\nHigher Average= +2.",
	icon = "img/mod_icon.png"
}

function mod:init()
	local pilot = require(self.scriptPath .."pilot")
	require(self.scriptPath.."personality")
	require(self.scriptPath.."suppressDialog")
	pilot:init(mod)
end

function mod:load(options, version) end

return mod
