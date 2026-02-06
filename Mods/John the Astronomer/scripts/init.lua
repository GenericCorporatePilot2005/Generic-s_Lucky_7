
-- init.lua is the entry point of every mod

local mod = {
	id = "Nico_Orbital_Pilot",
	name = "John the Astronomer",
	version = "0.0",
	requirements = {},
	modApiVersion = "2.3.0",
	icon = "img/mod_icon.png",
	description = "Adds a pilot that uses the criminally underrated Orbital Library, which adds a new subclass to units known as Orbital Units.\nLibrary made by Tatu, for further demonstrations of what it can do, check Tatu's Orbital Force Squad.",
}

function mod:init()
	require(self.scriptPath .."libs/orbitalPawn")
	require(self.scriptPath .."libs/orbitalIcon")
	require(self.scriptPath .."libs/ReloaderIcon")
	local pilot = require(self.scriptPath .."pilot")
	pilot:init(mod)
	-- add tutorial tip option
	modApi:addGenerationOption(
		"Nico_OrbresetTooltip",
		"Enable orbital units tip",
		"Check to enable the tutorial tip for orbital units.",
		{ enabled = false }
	)
end

function mod:load(options, version)
	--Reset tutorial tip
	if options.Nico_OrbresetTooltip and options.Nico_OrbresetTooltip.enabled then
		require(self.scriptPath .."libs/tutorialTips"):Reset("OrbitalPawn")
		options.Nico_OrbresetTooltip.enabled = false
	end
end

return mod
