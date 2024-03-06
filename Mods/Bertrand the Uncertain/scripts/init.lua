
-- init.lua is the entry point of every mod

local mod = {
	id = "Nico_RNG_Pilot",
	name = "Bertrand the Uncertain",
	version = "0.1",
	requirements = {},
	modApiVersion = "2.3.0",
	description = "For him, humanity IS worth a dice throw.\nSprites made by Deluge!",
	icon = "img/mod_icon.png"
}

function mod:init()
	local pilot = require(self.scriptPath .."pilot")
	require(self.scriptPath.."personality")
	pilot:init(mod)
end

function mod:metadata()--Don't make any changes to resources in metadata. metadata runs regardless of if your mod is enabled or not.
	modApi:addGenerationOption(
		"Nico_DIE_Sprite", "Bertrand's Colored Dice",
		"Changes the color Bertrand's Dice icons.\n(the 4 pips side is still red regardless).\nREQUIRES RESTART TO TAKE EFFECT!",
		{
			strings = { "All Red", "Colored"},
			values = {1, 2},
			value = 1
		}
	)
end

function mod:load(options, version) end

return mod
