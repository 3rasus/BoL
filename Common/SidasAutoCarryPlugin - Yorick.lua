--[[

	SAC Yorick plugin

	Version 1.0
	- Inital release 
--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 200, SPELL_SELF)
local SkillW = Caster(_W, 600, SPELL_CIRCLE, math.huge, 0.250, 200)
local SkillE = Caster(_E, 550, SPELL_TARGETED)
local SkillR = Caster(_R, 850, SPELL_TARGETED_FRIENDLY)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 850

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("qFarm", "LastHit with Q", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("rPercentage", "R Percentage",SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
	AutoBuff.Instance(SkillQ)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() and ValidTarget(Target, SkillQ.range) then SkillQ:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end
		if SkillR:Ready() then Combat.CastLowest(SkillR, PluginMenu.rPercentage) end  
	end

	if MainMenu.LastHit and PluginMenu.qFarm then
		Combat.LastHit(SkillQ, SkillQ.range)
	end 
end
