--[[

	SAC Nasus plugin

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 325, SPELL_SELF)
local SkillW = Caster(_W, 525, SPELL_SELF)
local SkillE = Caster(_E, 500, SPELL_SELF)
local SkillR = Caster(_R, 1000, SPELL_CIRCLE, math.huge, 0, 150, true)

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
		if SkillQ:Ready() and ValidTarget(Target, SkillQ.range) then
			SkillQ:Cast(Target) 
		end
		if SkillW:Ready() and ValidTarget(Target, SkillW.range) then
			SkillW:Cast(Target)
		end 
		if SkillE:Ready() and ValidTarget(Target, SkillE.range) then
			SkillE:Cast(Target)
		end 
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health) then
			SkillR:Cast(Target)
		end 
	end
end
