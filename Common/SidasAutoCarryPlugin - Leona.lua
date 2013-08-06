require "iFoundation"
local SkillQ = Caster(_Q, 100, SPELL_SELF) 
local SkillW = Caster(_W, 100, SPELL_SELF)
local SkillE = Caster(_E, 700, SPELL_LINEAR_COL, 1950, 0, 100, true) 
local SkillR = Caster(_R, 1200, SPELL_CIRCLE) 

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
		if SkillW:Ready() then SkillW:Cast(Target) end
		if SkillE:Ready() then SkillE:Cast(Target) end
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
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