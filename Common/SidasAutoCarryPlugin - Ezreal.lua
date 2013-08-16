--[[

	SAC Ezreal

	Features
		- Basic combo
			- Q > E > W > R

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 1100, SPELL_LINEAR_COL, 2000, 0.251, 80, true)
local SkillW = Caster(_W, 1050, SPELL_LINEAR, 1600, 0.250, 100, true)
local SkillE = Caster(_E, 475, SPELL_TARGET)
local SkillR = Caster(_R, 2000, SPELL_LINEAR, 1700, 1.0, 100, true)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 2000

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("eCast", "Cast E to mouse position", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillE:Ready() and PluginMenu.eCast then SkillE:Cast(mousePos) end 
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 	
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health) then SkillR:Cast(Target) end 	
	end
end
