--[[

	SAC Shyvana

	Features
		- Basic combo
			- E > W > Q > R (transform)

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"

local SkillQ = Caster(_Q, 200, SPELL_SELF)
local SkillW = Caster(_W, 300, SPELL_SELF)
local SkillE = Caster(_E, 950, SPELL_LINEAR, 1750, 0, 50, true) 
local SkillR = Caster(_R, math.huge, SPELL_LINEAR)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 950

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then

		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillW:Ready() and ValidTarget(Target, SkillW.range) then SkillW:Cast(Target) end 
		if SkillQ:Ready() and ValidTarget(Target, SkillQ.range) then SkillQ:Cast(Target) end 
		if SkillR:Ready() then SkillR:Cast(Target) end 

	end
end

