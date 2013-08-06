--[[
1.0 DONE
--]]
require "iFoundation"

local SkillQ = Caster(_Q, 950, SPELL_LINEAR, 1350, 203, 50, true) 
local SkillW = Caster(_W, 650, SPELL_TARGETED) 
local SkillE = Caster(_E, 650, SPELL_TARGETED)
local SkillR = Caster(_R, 900, SPELL_TARGETED)

local dmgCalc = DamageCalculation(true, {"Q", "W", "E"}) 
local draw = Draw(dmgCalc) 

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 600
	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("rPercentage", "R Percentage",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	monitor = Monitor(PluginMenu)
	prioirty = Priority(true)
end 

function PluginOnTick() 
	monitor:MonitorTeam(700)
	monitor:MonitorLowTeamate()
	monitor:AutoPotion()

    Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then

		if SkillQ:Ready() then SkillQ:Cast(Target) end 

		if SkillE:Ready() then 
			if monitor:GetLowTeamate() ~= nil then 
				SkillE:Cast(monitor:GetLowTeamate()) 
			elseif monitor:TakingRapidDamage() then
				SkillE:Cast(myHero)
			else
				SkillE:Cast(Target) 
			end 
		end 

		if SkillR:Ready() then
			if monitor:GetLowTeamate() ~= nil then
				SkillR:Cast(monitor:GetLowTeamate())
			elseif myHero.health < myHero.maxHealth * (PluginMenu.rPercentage / 100) then
				SkillR:Cast(myHero) 
			end 
		end 

		if SkillW:Ready() then
			SkillW:Cast(Target)
		end 	
	end 

	if MainMenu.LastHit then
		dmgCalc:LastHitMinion(SkillQ, "Q")
	end
end 

function PluginOnDraw()
	if Target == nil then return false end 
	draw:DrawTarget(Target)
end 

