--[[

	SAC Graves plugin

	Features
		- Basic combo
			- Q > E > W > R

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 950, SPELL_LINEAR, 2150, 0.218, 200, true)
local SkillW = Caster(_W, 950, SPELL_CIRCLE)
local SkillE = Caster(_E, 425, SPELL_TARGETED)
local SkillR = Caster(_R, 1000, SPELL_LINEAR, 2250, 0.234, 150, true)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("eMouse", "Dash to mouse with E", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 
		if SkillE:Ready() then if PluginMenu.eMouse then SkillE:Cast(mousePos) else SkillE:Cast(Target) end end 
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health) then SkillR:Cast(Target) end 
	end
end
