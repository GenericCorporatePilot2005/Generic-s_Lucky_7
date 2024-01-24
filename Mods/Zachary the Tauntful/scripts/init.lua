
local function init(self)
	--init variables
	local path = mod_loader.mods[modApi.currentMod].scriptPath
	--libs
	local mod = mod_loader.mods[modApi.currentMod]
	local resourcePath = mod.resourcePath
	local scriptPath = mod.scriptPath
	local options = mod_loader.currentModContent[mod.id].options

	self.libs = {}
	self.libs.modApiExt = modapiext

	--Scripts
	local pilot = require(self.scriptPath .."pilot")
	local replaceRepair = require(self.scriptPath.."replaceRepair/replaceRepair")
	require(self.scriptPath.."personality")
    pilot:init(self)
	--require(self.scriptPath.."hooks")
end

local function load(self,options,version)
end
--[[
local function metadata()

end
]]--

return {
	id = "Nico_Taunt_Pilot",
    name = "Zachary The Tauntful",
	icon = "mod_icon.png",
	description = "Thanks to NamesAreHard for the Taunt Library!\nArt by Neozoid.",
	modApiVersion = "2.9.1",
	gameVersion = "1.2.83",
	version = "1.1.0",
	requirements = { "kf_ModUtils" },
	dependencies = {
		modApiExt = "1.21",
		memedit = "1.1.4",
		easyEdit = "2.0.6",
	},
	--metadata = metadata,
	load = load,
	init = init
}
