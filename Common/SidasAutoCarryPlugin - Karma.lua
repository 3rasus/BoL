--[[
	
	SAC Karma plugin

	Version 1.0
	- Initial release

	Version 1.2
	- Converted to iFoundation_v2

--]]
require "iFoundation_v2"


local SkillQ = Caster(_Q, 1050, SPELL_LINEAR_COL, 1800, 0.250, 100, true) 
local SkillW = Caster(_W, 650, SPELL_TARGETED)
local SkillE = Caster(_E, 800, SPELL_TARGETED) 
local SkillR = Caster(_R, math.huge, SPELL_SELF) 

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("qFarm", "LastHit with Q", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("ePercentage", "E Percentage",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	PluginMenu:addParam("wPercentage", "W Percentage w/ R",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)

	AutoShield.Instance(SkillE.range, SkillE)
end 

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillR:Ready() then
			SkillR:Cast(Target) 
			if myHero.health <= myHero.maxHealth * (PluginMenu.wPercentage / 100) then
				SkillW:Cast(Target) 
			elseif Monitor.GetLowAlly() ~= nil then
				SkillE:Cast(Monitor.GetLowAlly()) 
			else
				SkillQ:Cast(Target)
			end 
		end 
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 	
	end  

	if MainMenu.LastHit then
		Combat.LastHit(SkillQ) 
	end 
end 
