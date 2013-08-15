--[[

	SAC Nautilus plugin

	Features 
		- Smart combo
			- Q > E > W > R (if killable)

	Version 1.0 
	- Initial release

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 1030, SPELL_LINEAR_COL, 1841, 0.250, 100, true)
local SkillW = Caster(_W, 700, SPELL_SELF)
local SkillE = Caster(_E, 600, SPELL_SELF)
local SkillR = Caster(_R, 850, SPELL_TARGET)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 1200

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() and ValidTarget(Target, SkillE.range) then SkillE:Cast(Target) end 
		if SkillW:Ready() and ValidTarget(Target, SkillW.range) then SkillW:Cast(Target) end 	
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health) then SkillR:Cast(Target) end 	
	end
end
