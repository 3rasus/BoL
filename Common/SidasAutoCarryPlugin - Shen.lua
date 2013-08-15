--[[
	SAC Shen Plugin

	Features
		- Smart combo
			- Q > W > E
		- Smart R monitoring for maximum ally coverage
	
	Version 1.0
	- Initial release 

	Version 1.2
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"

local SkillQ = Caster(_Q, 475, SPELL_TARGETED)
local SkillE = Caster(_E, 1000, SPELL_LINEAR_COL, 1603, 0.187, 110, true)
local SkillW = Caster(_W, 200, SPELL_TARGETED_FRIENDLY)
local SkillR = Caster(_R, 18500, SPELL_TARGETED_FRIENDLY)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 630

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu

	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("AutoR", "Press R to teleport to player", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("R"))
end 

function PluginOnTick() 
	Target = AutoCarry.GetAttackTarget()

	if Monitor.GetLowAlly() ~= nil and SkillR:Ready() then 
		Messages.AddMessage("WARNING: Ally is below threshold!! Press R!!", ColorARGB.Red)
		if PluginMenu.AutoR then 
			SkillR:Cast(Monitor.GetLowAlly)
		end 
	end 

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 			
		if SkillE:Ready() then SKillE:Cast(Target) end 		
	end

	if MainMenu.LastHit then
		Combat.LastHit(SkillQ)
	end

end
