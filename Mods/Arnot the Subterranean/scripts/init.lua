
-- init.lua is the entry point of every mod

local mod = {
	id = "Nico_Mole_Pilot",
	name = "Arnot the Subterranean",
	version = "0.1",
	requirements = {},
	modApiVersion = "2.3.0",
	icon = "img/mod_icon.png"
}

function mod:init()
	local pilot = require(self.scriptPath .."pilot")--
	pilot:init(mod)
	modApi:copyAsset("img/combat/icons/icon_emerge_cb_glow.png", "img/combat/icons/Nico_icon_emerge_cb_glow.png")
	Location["combat/icons/Nico_icon_emerge_cb_glow.png"] = Point(-14,14)
	modApi:appendAsset("img/combat/icons/Nico_icon_burrow_cb_glow.png", self.resourcePath.. "img/combat/icons/Nico_icon_burrow_cb_glow.png")
	Location["combat/icons/Nico_icon_burrow_cb_glow.png"] = Point(-14,14)
end

function mod:load(options, version)
end

return mod
