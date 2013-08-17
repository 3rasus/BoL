--[[

	SAC Vladimir plugin

	Features
		- Basic combo
			- Q > E > W > R

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 600, SPELL_TARGETED)
--local SkillW = Caster(_W, 700, SPELL_TARGETED)
local SkillE = Caster(_E, 600, SPELL_SELF)
local SkillR = Caster(_R, 700, SPELL_CIRCLE)

local eTick = 0

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 700

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if SkillE:Ready() and GetTickCount() - eTick >= 9500 then
		eTick = 0
		SkillE:Cast(Target)
	end 

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() then 
			if eTick == 0 then
				eTick = GetTickCount()
			end 
			SkillE:Cast(Target) 
		end 
		if SkillR:Ready() and ((DamageCalculation.CalculateRealDamage(Target) > Target.health) or (getDmg("R", Target, myHero) > Target.health))  then SkillR:Cast(Target) end 	
	end
end
