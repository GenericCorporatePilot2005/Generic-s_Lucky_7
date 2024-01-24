
-- init.lua is the entry point of every mod

local mod = {
	id = "Nico_Magnet_Pilot",
	name = "Shin the Magnetic",
	version = "-1",
	requirements = {},
	modApiVersion = "2.3.0",
	icon = "img/mod_icon.png"
}

function mod:init()
	-- look in template/pilot to see how to code pilots.
	local pilot = require(self.scriptPath .."pilot")
	pilot:init(mod)
	local replaceRepair = require(self.scriptPath.."replaceRepair/replaceRepair")
end

function mod:load(options, version)
end

return mod
