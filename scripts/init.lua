local mod = {
	id = "Nico_pilots",
	name = "Generic's Lucky Seven",
	description = "Adds 7 new pilots to give more variety to your runs.",
	icon = "icon.png",
	submodFolders = {"Mods/"},
}

function mod:init()
	self.replaceRepair = require(self.scriptPath.."replaceRepair/replaceRepair")
	self.trait = require(self.scriptPath.."trait")
end

function mod:load(options, version)
end

return mod