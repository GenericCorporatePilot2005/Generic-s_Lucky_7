
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
	require(self.scriptPath .."personality")
	local replaceRepair = mod_loader.mods.Nico_pilots.replaceRepair
	modApi:copyAsset("img/combat/icons/icon_fire_immune_glow.png", "img/combat/icons/Nico_icon_fire_immune_glow.png")
	Location["combat/icons/Nico_icon_fire_immune_glow.png"] = Point(-10,8)
end

function mod:load(options, version)
end

return mod
