--[[
	
	SAC Kha'Zix Plugin

	Version 1.0 
	- Initial release

	Version 1.2
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"

local SkillQ = Caster(_Q, 325, SPELL_TARGETED)
local SkillW = Caster(_W, 1030, SPELL_LINEAR_COL, 1835, 0.225, 110, true)
local SkillE = Caster(_E, 600, SPELL_CIRCLE, math.huge, 0, 100, true)
local SkillR = Caster(_R, math.huge, SPELL_SELF)

function PluginOnLoad() 
	AutoCarry.SkillsCrosshair.range = 1000
	PluginMenu = AutoCarry.PluginMenu
	MainMenu = AutoCarry.MainMenu

	PluginMenu:addParam("UseR", "Auto-Enable R when low health", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("RPercentage", "Percentage of health to use R",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	PluginMenu:addParam("EJump", "Distance to jump in with E (when not killable)",SCRIPT_PARAM_SLICE, 400, 0, 600, 0)
end

function PluginOnTick() 

	Target = AutoCarry.GetAttackTarget()

	CheckEvolution()

	--> AutoCarry
	if Target and MainMenu.AutoCarry then

		--> O'Shit R 
		if SkillR:Ready() and PluginMenu.UseR and myHero.health <= myHero.maxHealth * (PluginMenu.RPercentage / 100) then
			SkillR:Cast(Target)
		end

		--> Dive in
		if SkillE:Ready() and ((DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("E", Target, myHero) >= Target.health)
		or (GetDistance(Target) <= PluginMenu.EJump and myHero.health > myHero.maxHealth * (PluginMenu.RPercentage / 100))) then
			SkillE:Cast(Target) 
		end 

		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 
			
	end


end 

function CheckEvolution()
	if myHero:GetSpellData(_E).name == "khazixelong" then
  		SkillE.range = 900
 	end 
 	if myHero:GetSpellData(_Q).name == "khazixqlong" then
  		SkillQ.range = 375
 	end 
end 