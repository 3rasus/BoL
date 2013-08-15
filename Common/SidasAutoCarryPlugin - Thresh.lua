--[[

	SAC Thresh plugin

	Features
		- Smart combo 
			- W > Q > E > R

	Version 1.0 
	- Initial release 

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"

local SkillQ = Caster(_Q, 1075, SPELL_LINEAR_COL, 2000, 0.491, 50, true)
local SkillW = Caster(_W, 950, SPELL_CIRCLE, math.huge, 0, 100, true)
local SkillE = Caster(_E, 400, SPELL_LINEAR, math.huge, 0, 100, true)
local SkillR = Caster(_R, 450, SPELL_CIRCLE, math.huge, 0, 100, true)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu

	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("WRapid", "Use W when lost rapid amount of health", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("WPercentage", "Percent of health to use W",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	PluginMenu:addParam("ComboW", "Use W in combo", SCRIPT_PARAM_ONOFF, true)
	AutoShield.Instance(SkillW.range, SkillW)
end

function PluginOnTick()

	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then

		if SkillW:Ready() and PluginMenu.ComboW then
			SkillW:Cast(myHero)
		end

		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 

		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health or Monitor.CountEnemies(Target) >= 2) then
			SkillR:Cast(Target)
		end 
			
	end

end

