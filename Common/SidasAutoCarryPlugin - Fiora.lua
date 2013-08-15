--[[

	SAC Fiora plugin

	Version 1.0
	- Initial release

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 600, SPELL_TARGETED)
local SkillW = Caster(_W, math.huge, SPELL_SELF)
local SkillE = Caster(_E, math.huge, SPELL_SELF)
local SkillR = Caster(_R, 400, SPELL_TARGETED)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
	AutoShield.Instance(SkillW.range, SkillW)
	AutoBuff.Instance(SkillE)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health) then SkillR:Cast(Target) end 	
	end
end
