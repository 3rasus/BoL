--[[

	SAC Mordekaiser
	
	Credits to eXtragoZ for pet management 

	Version 1.2 
	- Converted to iFoundation_v2 

	LAST TESTED 1.2 ON 8.11 WORKING PERFECT
--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 200, SPELL_SELF)
local SkillW = Caster(_W, 750, SPELL_TARGETED_FRIENDLY)
local SkillE = Caster(_E, 700, SPELL_CONE)
local SkillR = Caster(_R, 850, SPELL_TARGETED)

local rGhost = false
local rDelay = 0

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("rKS", "KillSteal with R", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("eKS", "KillSteal with E", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("wPercentage", "Monitor w percentage",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	rGhost = myHero:GetSpellData(_R).name == "mordekaisercotgguide"

	if Target and MainMenu.AutoCarry then	
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 

		if SkillW:Ready() and Monitor.GetLowAlly() ~= nil then 
			SkillW:Cast(Monitor.GetLowAlly())
		elseif (myHero.health < myHero.maxHealth * (PluginMenu.wPercentage / 100)) then
			SkillW:Cast(myHero)
		elseif Monitor.GetAllyWithMostEnemies(750) ~= nil then
			SkillW:Cast(Monitor.GetAllyWithMostEnemies(750))
		end 

		if SkillR:Ready() and rGhost and GetTickCount() >= rDelay then
			SkillR:Cast(Target) 
			rDelay = GetTickCount() + 1000
		elseif not rGhost and SkillR:Ready() and DamageCalculation.CalculateRealDamage(Target) > Target.health then 
			SkillR:Cast(Target) 
		elseif not rGhost and getDmg("R", Target, myHero) >= Target.health then 
			SkillR:Cast(Target) 
		end 

	end
end

