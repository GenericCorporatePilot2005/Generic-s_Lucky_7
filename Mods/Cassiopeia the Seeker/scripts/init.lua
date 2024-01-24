
-- init.lua is the entry point of every mod

local mod = {
	id = "Nico_Geode_Pilot",
	name = "Cassiopeia the Seeker",
	version = "0.1",
	requirements = {},
	modApiVersion = "2.3.0",
	description = "",
	icon = "img/icons/mod_icon1.png"
}

function mod:metadata()--Don't make any changes to resources in metadata. metadata runs regardless of if your mod is enabled or not.
	modApi:addGenerationOption(
		"Nico_Geode_Sprite", "Cassiopeia's Geodes",
		"Changes the color Cassiopeia's geodes and Geode Hounds.\nREQUIRES RESTART TO TAKE EFFECT!",
		{
			strings = { "Purple", "Green","Blue"},
			values = {1, 2, 3},
			value = 1
		}
	)
end
function mod:init()
	local pilot = require(self.scriptPath .."pilot")
	pilot:init(mod)
	local options = mod_loader.currentModContent[mod.id].options
	local color = options["Nico_Geode_Sprite"].value
	icon = self.resourcePath .."img/icons/mod_icon"..color..".png"
end

function mod:load(options, version) end

return mod
