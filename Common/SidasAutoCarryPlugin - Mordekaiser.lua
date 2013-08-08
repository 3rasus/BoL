--[[

	SAC Mordekaiser
	
	Credits to eXtragoZ for pet management 
--]]

require "iFoundation"
local SkillQ = Caster(_Q, 200, SPELL_SELF)
local SkillW = Caster(_W, 750, SPELL_TARGETED_FRIENDLY)
local SkillE = Caster(_E, 700, SPELL_CONE)
local SkillR = Caster(_R, 850, SPELL_TARGETED)

local dmgCalc = DamageCalculation(true, {"Q", "W", "E", "R"}) 
local draw = Draw(dmgCalc) 

local monitor = nil

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
	monitor = Monitor(PluginMenu)
end

function PluginOnTick()
	monitor:MonitorTeam(700)
	monitor:MonitorLowTeamate()
	monitor:AutoPotion()
	Target = AutoCarry.GetAttackTarget()

	if PluginMenu.eKS and SkillE:Ready() then
		dmgCalc:KillSteal(SkillE, "E")
	elseif PluginMenu.rKS and SkillR:Ready() then
		dmgCalc:KillSteal(SkillR, "R")
	end  

	rGhost = myHero:GetSpellData(_R).name == "mordekaisercotgguide"

	if Target and MainMenu.AutoCarry then	
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 

		if SkillW:Ready() and monitor:GetLowTeamate() ~= nil then 
			SkillW:Cast(monitor:GetLowTeamate())
		elseif (myHero.health / myHero.maxHealth <= (PluginMenu.wPercentage / 100)) or monitor:TakingRapidDamage() then
			SkillW:Cast(myHero)
		elseif Monitor:GetTeamateWithMostEnemies(750) ~= nil then
			SkillW:Cast(Monitor:GetTeamateWithMostEnemies(750))
		end 

		if SkillR:Ready() and rGhost and GetTickCount() >= rDelay then
			SkillR:Cast(Target) 
			rDelay = GetTickCount() + 1000
		elseif not rGhost and SkillR:Ready() and dmgCalc:CalculateRealDamage(true, Target) > Target.health then 
			SkillR:Cast(Target) 
		elseif not rGhost and getDmg("R", Target, myHero) >= Target.health then 
			SkillR:Cast(Target) 
		end 

	end

	if MainMenu.LastHit then
		dmgCalc:LastHitMinion(SkillE, "E")
	end

end

function PluginOnDraw()
	if Target == nil then return false end 
	draw:DrawTarget(Target)
end