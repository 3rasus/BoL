--[[ 
	
	SAC - Brand Edition Ablaze

	Version 1.2 
	- Updated to iFoundation_v2 

	LAST TESTED 8.12 WORKING PERFECT
--]]

require "iFoundation_v2"

local SkillQ = Caster(_Q, 1000, SPELL_LINEAR, 1603, 0.187, 110, true)
local SkillW = Caster(_W, 900, SPELL_CIRCLE, math.huge, 0, 100, true)
local SkillE = Caster(_E, 625, SPELL_TARGETED)
local SkillR = Caster(_R, 750, SPELL_TARGETED)

function PluginOnLoad() 

	AutoCarry.SkillsCrosshair.range = 1100

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu

	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("QStun", "Save Q for stun", SCRIPT_PARAM_ONOFF, true)

	Buffs.Instance()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	--> AutoCarry
	if Target and MainMenu.AutoCarry then

		--> Ablaze check
		if IsAblaze(Target) then

			if PluginMenu.QStun and SkillQ:Ready() then
				SkillQ:Cast(Target)
			end 

			--> Spread Ablaze
			if SkillE:Ready() and Monitor.CountEnemies(Target, 300) >= 2 then
				SkillE:Cast(Target)
			end

		end

		--> Regular casting
		if SkillQ:Ready() and not PluginMenu.QStun then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health) then
			SkillR:Cast(Target) 
		end 
	end
end

function IsAblaze(target)
	return Buffs.TargetHaveBuff("brandablaze", target)
end