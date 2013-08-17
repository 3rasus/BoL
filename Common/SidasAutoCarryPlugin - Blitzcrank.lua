--[[

	SAC Blitzcrank plugin

	Features
		- Basic combo
			- Q > E > W > R

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 950, SPELL_LINEAR_COL, 1800, 0.25, 120)
local SkillW = Caster(_W, 200, SPELL_SELF)
local SkillE = Caster(_E, 200, SPELL_SELF)
local SkillR = Caster(_R, 600, SPELL_SELF)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 1500

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("qPull", "Quick Q pull", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Q"))
	AutoBuff.Instance(SkillE)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and PluginMenu.qPull then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
	end 

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() and ValidTarget(Target, SkillE.range) then SkillE:Cast(Target) end 
		if SkillW:Ready() and ValidTarget(Target, SkillW.range) then SkillW:Cast(Target) end 	
		if SkillR:Ready() and ValidTarget(Target, SkillR.range) and ((DamageCalculation.CalculateRealDamage(Target) > Target.health) or (getDmg("R", Target, myHero) > Target.health)) then SkillR:Cast(Target) end 	
	end
end
