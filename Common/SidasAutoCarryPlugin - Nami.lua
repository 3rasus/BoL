--[[

	SAC Nami plugin

	Features
		- Auto-Aim R (still press hotkey)
		- Smart Bubblez 
		- Smart shielding
		- Use with PowerBuff 

	Version 1.0
	- Initial release

	Version 1.2
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 850, SPELL_CIRCLE, math.huge, 0.400, true)
local SkillW = Caster(_W, 725, SPELL_TARGETED)
local SkillR = Caster(_R, 1000, SPELL_LINEAR, 1200, 0.500, true) 

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("useR", "Use Ultimate", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("R"))
	Priority.Instance(true)
	AutoShield.Instance(SkillW.range, SkillW)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 
		if PluginMenu.useR and SkillR:Ready() then SkillR:Cast(Target) end 
	end
end
