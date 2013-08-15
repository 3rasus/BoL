--[[
	SAC Zac plugin 

	Version 1.0
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"

local SkillQ = Caster(_Q, 550, SPELL_CONE)
local SkillW = Caster(_W, 250, SPELL_SELF)
local SkillE = Caster(_E, 1150, SPELL_CIRCLE, 1288, 0.140, 50, true) 
local SkillR = Caster(_R, 0, SPELL_SELF)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("rCombo", "Use R in Combo / When killable", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 
		if SkillR:Ready() and PluginMenu.rCombo and DamageCalculation.CalculateRealDamage(true, Target) > Target.health then SkillR:Cast(Target) end 
	end  

end
