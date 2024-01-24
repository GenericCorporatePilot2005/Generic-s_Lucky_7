
-- init.lua is the entry point of every mod

local mod = {
	id = "Nico_FIRE_Pilot",
	name = "Prometheus the Streetcleaner",
	version = "0.1",
	requirements = {},
	modApiVersion = "2.3.0",
	icon = "img/mod_icon.png"
}

function mod:init()
	local pilot = require(self.scriptPath .."pilot")
	pilot:init(mod)
	local replaceRepair = require(self.scriptPath.."replaceRepair/replaceRepair")
	modApi:copyAsset("img/combat/icons/icon_fire_immune_glow.png", "img/combat/icons/icon_fire_immune_glow.png")
	Location["combat/icons/icon_fire_immune_glow.png"] = Point(-10,8)
end

function mod:load(options, version)
end

return mod
