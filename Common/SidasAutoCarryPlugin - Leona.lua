--[[
	
	SAC Leona plugin

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2 
	- Bug fixes

--]]

require "iFoundation"
local SkillQ = Caster(_Q, 100, SPELL_SELF) 
local SkillW = Caster(_W, 100, SPELL_SELF)
local SkillE = Caster(_E, 700, SPELL_LINEAR_COL, 1950, 0, 100, true) 
local SkillR = Caster(_R, 1200, SPELL_CIRCLE) 

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	AutoShield.Instance(SkillW.range, SkillW)
end 

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	-- AutoCarry
	if Target and MainMenu.AutoCarry then
		if SkillW:Ready() then SkillW:Cast(Target) end
		if SkillE:Ready() then SkillE:Cast(Target) end
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health) then SkillR:Cast(Target) end 
	end  

	-- LastHit
	if MainMenu.LastHit then
		Combat.LastHit(SkillE)
	end
end 

