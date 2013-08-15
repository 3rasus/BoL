--[[

	SAC Irelia plugin

	Version 1.0
	- Initial release
	
--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 650, SPELL_TARGETED)
local SkillW = Caster(_W, 700, SPELL_SELF)
local SkillE = Caster(_E, 650, SPELL_TARGETED)
local SkillR = Caster(_R, 1000, SPELL_LINEAR)

local rTick = 0

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 1000

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
	AutoBuff.Instance(SkillW)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if rTick ~= 0 and GetTickCount() - rTick > 15000 then
		rTick = 0 
	end 

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 	
		if SkillR:Ready() and ((rTick ~= 0 and GetTickCount() - rTick < 15000) or (DamageCalculation.CalculateRealDamage(Target) > Target.health or (getDmg("R", Target, myHero) * 3) > Target.health)) then
			if rTick == 0 then
				rTick = GetTickCount()
			end 
			SkillR:Cast(Target) 
		end 	
	end
end
