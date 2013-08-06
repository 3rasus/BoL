--[[
1.0 DONE
--]]
require "iFoundation"
local SkillQ = Caster(_Q, 600, SPELL_TARGETED) 
local SkillW = Caster(_W, 625, SPELL_CIRCLE)
local SkillE = Caster(_E, 540, SPELL_TARGETED) 
local SkillR = Caster(_R, 700, SPELL_CIRCLE) 

local dmgCalc = DamageCalculation(true, {"Q", "W", "E", "R"}) 
local draw = Draw(dmgCalc) 

local monitor = nil

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	
	monitor = Monitor(PluginMenu)
end 

function PluginOnTick()
	monitor:MonitorTeam(700)
	monitor:MonitorLowTeamate()
	monitor:AutoPotion()

	Target = AutoCarry.GetAttackTarget()

	-- AutoCarry
	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end
		if SkillE:Ready() then SkillE:Cast(Target) end
		if SkillW:Ready() then SkillW:Cast(Target) end 	
		if SkillR:Ready() and dmgCalc:CalculateRealDamage(true, Target) >= Target.health then SkillR:Cast(Target) end 
	end  

	-- LastHit
	if MainMenu.LastHit then
		dmgCalc:LastHitMinion(SkillE, "E")
	end
end 

function PluginOnDraw()
	if Target == nil then return false end 
	draw:DrawTarget(Target)
end 