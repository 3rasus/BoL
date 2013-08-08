--[[
1.0 DONE
--]]
require "iFoundation"


local SkillQ = Caster(_Q, 1050, SPELL_LINEAR_COL, 1800, 0.250, 100, true) 
local SkillW = Caster(_W, 650, SPELL_TARGETED)
local SkillE = Caster(_E, 800, SPELL_TARGETED) 
local SkillR = Caster(_R, math.huge, SPELL_SELF) 

local dmgCalc = DamageCalculation(true, {"Q", "W", "E", "R"}) 
local draw = Draw(dmgCalc) 

local monitor = nil

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("ePercentage", "E Percentage",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	PluginMenu:addParam("wPercentage", "W Percentage w/ R",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	monitor = Monitor(PluginMenu)
end 

function PluginOnTick()
	monitor:MonitorTeam(700)
	monitor:MonitorLowTeamate()
	monitor:AutoPotion()

	Target = AutoCarry.GetAttackTarget()

	-- AutoCarry
	if Target and MainMenu.AutoCarry then
		if SkillR:Ready() then
			SkillR:Cast(Target) 
			if myHero.health < myHero.maxHealth * (PluginMenu.wPercentage / 100) then
				SkillW:Cast(Target) 
			elseif monitor:GetLowTeamate() ~= nil then
				SkillE:Cast(monitor:GetLowTeamate()) 
			elseif monitor:TakingRapidDamage() then
				SkillE:Cast(myHero) 
			else 
				SkillQ:Cast(Target)
			end 
		end 

		if myHero.health < myHero.maxHealth * (PluginMenu.ePercentage / 100) or monitor:TakingRapidDamage()  then
			if SkillE:Ready() then SkillE:Cast(myHero) end
		elseif monitor:GetLowTeamate() ~= nil then
			if SkillE:Ready() then SkillE:Cast(monitor:GetLowTeamate()) end 
		end  

		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 	
	end  

	-- LastHit
	if MainMenu.LastHit then
		dmgCalc:LastHitMinion(SkillQ, "Q")
	end
end 

function PluginOnDraw()
	if Target == nil then return false end 
	draw:DrawTarget(Target)
end 