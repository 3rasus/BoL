--[[
	1.0 DONE
	SAC Zac plugin 

--]]

require "iFoundation"

local SkillQ = Caster(_Q, 550, SPELL_LINEAR_COL, math.huge, 0, 150, true)
local SkillW = Caster(_W, 250, SPELL_SELF)
local SkillE = Caster(_E, 1150, SPELL_CIRCLE, 1288, 140, 50, true) 
local SkillR = Caster(_R, 0, SPELL_SELF)

local dmgCalc = DamageCalculation(true, {"Q", "W", "E", "R"}) 
local draw = Draw(dmgCalc) 

local monitor = nil

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("rCombo", "Use R in Combo / When killable", SCRIPT_PARAM_ONOFF, true)
	monitor = Monitor(PluginMenu)
end

function PluginOnTick()
	monitor:MonitorTeam(700)
	monitor:MonitorLowTeamate()
	monitor:AutoPotion()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 
		if SkillR:Ready() and PluginMenu.rCombo and dmgCalc:CalculateRealDamage(true, Target) > Target.health then SkillR:Cast(Target) end 
	end  

end

function PluginOnDraw()
	if Target == nil then return false end 
	draw:DrawTarget(Target)
end