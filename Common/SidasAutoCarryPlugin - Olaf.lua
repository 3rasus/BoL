--[[

	SAC Olaf plugin

	Features
		- Smart combo
			- Q > W > E > R (if conditions are on myself)

	Version 1.0 
	- Initial release

--]]

require "iFoundation_v2"

local SkillQ = Caster(_Q, 1000, SPELL_LINEAR, 1650, 0.234, 100, true)
local SkillW = Caster(_W, 225, SPELL_SELF)
local SkillE = Caster(_E, 250, SPELL_TARGETED)
local SkillR = Caster(_R, 300, SPELL_SELF)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() and ValidTarget(Target, SkillW.range) then SkillW:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillR:Ready() and (myHero.isTaunted or myHero.isCharmed or myHero.isFeared or myHero.isFleeing) then
			SkillR:Cast(Target)
		end 
	end
end
