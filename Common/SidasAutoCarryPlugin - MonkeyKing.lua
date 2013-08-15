--[[

	SAC MonkeyKing (aka. Wukong) plugin

	Version 1.0
	- Initial release

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 200, SPELL_SELF)
local SkillW = Caster(_W, math.huge, SPELL_SELF)
local SkillE = Caster(_E, 625, SPELL_TARGETED)
local SkillR = Caster(_R, 162, SPELL_SELF)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
	AutoShield.Instance(SkillW.range, SkillW)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() and ValidTarget(SkillQ.range, Target) then SkillQ:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health) then SkillR:Cast(Target) end 	
	end
end
