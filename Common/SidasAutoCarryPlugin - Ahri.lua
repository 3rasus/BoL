--[[
	
	SAC Ahri Plugin

	Version 1.0
	- Initial release 

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 880, SPELL_LINEAR, 1700, 0.25, 50)
local SkillW = Caster(_W, 800, SPELL_SELF)
local SkillE = Caster(_E, 975, SPELL_LINEAR_COL, 1600, 0.1, 50)
local SkillR = Caster(_R, 1000, SPELL_LINEAR, math.huge, 0, 100)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 1000

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("castMouse", "Cast R to mouse position", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or (getDmg("R", Target, myHero) * 3) > Target.health) then
			if PluginMenu.castMouse then
				SkillR:CastMouse(mousePos)
			else
				SkillR:Cast(Target) 
			end 
		end 
		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillQ:Ready() then SkillQ:Cast(Target) end
		if SkillW:Ready() and ValidTarget(Target, SkillW.range) then SkillW:Cast(Target) end 
	end

	if MainMenu.LastHit then
		Combat.LastHit(SkillQ, SkillQ.range)
	end 
end
