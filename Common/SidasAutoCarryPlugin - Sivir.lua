--[[

	SAC Nasus plugin

	Features
		- Basic combo
			- Q > E > W > R

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 1200, SPELL_LINEAR, 300, 0.200, 100, true)
local SkillW = Caster(_W, math.huge, SPELL_SELF)
local SkillE = Caster(_E, math.huge, SPELL_SELF)
local SkillR = Caster(_R, 300, SPELL_SELF)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 1200

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
	AutoShield.Instance(SkillE.range, SkillE)
	AutoBuff.Instance(SkillW)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		--if SkillE:Ready() then SkillE:Cast(Target) end 
		--if SkillW:Ready() then SkillW:Cast(Target) end 	
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health) then SkillR:Cast(Target) end 	
	end
end
