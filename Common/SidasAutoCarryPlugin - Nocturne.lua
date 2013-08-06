--[[
	1.0 DONE 
	SAC Nocturne Plugin

--]]

require "iFoundation"
local SkillQ = Caster(_Q, 1200, SPELL_LINEAR, 1398, 249, 50, true) 
local SkillW = Caster(_W, math.huge, SPELL_SELF)
local SkillE = Caster(_E, 425, SPELL_TARGETED)
-- ignore R... 

local dmgCalc = DamageCalculation(true, {"Q", "W", "E", "R"}) 
local draw = Draw(dmgCalc) 

local monitor = nil

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 1200

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
    PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("wDistance", "W distance", SCRIPT_PARAM_SLICE, 0, 0, 500, 0)
	monitor = Monitor(PluginMenu)
end

function PluginOnTick()
	monitor:MonitorTeam(700)
	monitor:MonitorLowTeamate()
	monitor:AutoPotion()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() and GetDistance(Target) < PluginMenu.wDistance then SkillW:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 
	end

	if MainMenu.LastHit then
		dmgCalc:LastHitMinion(SkillQ, "Q")
	end

end

function PluginOnDraw()
	if Target == nil then return false end 
	draw:DrawTarget(Target)
end