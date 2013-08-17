--[[

	SAC Caitlyn plugin

	Features
		- Basic combo
			- Q > E > W > R

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 1300, SPELL_LINEAR, 2200, 0.625, 90, true)
local SkillW = Caster(_W, 800, SPELL_CIRCLE)
local SkillE = Caster(_E, 800, SPELL_LINEAR_COL, 2000, 0, 80, true)
local SkillR = Caster(_R, 2000, SPELL_TARGETED)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 3000

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	SkillR.range = GetRRange()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 	
		if SkillR:Ready() and PluginMenu.useR and (getDmg("R", Target, myHero) > Target.health) then SkillR:Cast(Target) end 
	end
end

function GetRRange()
        if myHero:GetSpellData(_R).level == 1 then
                return 2000
        elseif myHero:GetSpellData(_R).level == 2 then
                return 2500
        elseif myHero:GetSpellData(_R).level == 3 then
                return 3000
        end
end