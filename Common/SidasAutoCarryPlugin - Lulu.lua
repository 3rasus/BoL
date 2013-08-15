--[[

	SAC Lulu plugin

	Version 1.0
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]
require "iFoundation_v2"

local SkillQ = Caster(_Q, 950, SPELL_LINEAR, 1350, 0.203, 50, true) 
local SkillW = Caster(_W, 650, SPELL_TARGETED) 
local SkillE = Caster(_E, 650, SPELL_TARGETED)
local SkillR = Caster(_R, 900, SPELL_TARGETED)

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 600
	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("rPercentage", "R Percentage",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	Priority.Instance(true)
	AutoShield.Instance(SkillE.range, SkillE)
end 

function PluginOnTick() 

    Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then

		if SkillQ:Ready() then SkillQ:Cast(Target) end 

		if SkillE:Ready() then 
			if Monitor.GetLowAlly() ~= nil then 
				SkillE:Cast(Monitor.GetLowAlly()) 
			else
				SkillE:Cast(Target) 
			end 
		end 

		if SkillR:Ready() then
			if Monitor.GetLowAlly() ~= nil then
				SkillR:Cast(Monitor.GetLowAlly())
			elseif myHero.health / myHero.maxHealth <= (PluginMenu.rPercentage / 100) then
				SkillR:Cast(myHero) 
			end 
		end 

		if SkillW:Ready() then
			SkillW:Cast(Target)
		end 	
	end 

	if MainMenu.LastHit then
		Combat.LastHit(SkillQ)
	end
end 
