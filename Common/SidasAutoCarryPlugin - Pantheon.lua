--[[
		
	SAC - Pantheon Edition

	Features
		- Smart combo
			- W > Q > E

	Version: 0.1 
	- Pre-release

	Version 1.0 
	- Initial release

	Version 1.2
	- Converted to iFoundation_v2
	
--]]


local SkillQ = Caster(_Q, 600, SPELL_TARGETED)
local SkillW = Caster(_W, 600, SPELL_CIRCLE, math.huge, 0, 100, true)
local SkillE = Caster(_E, 225, SPELL_LINEAR, math.huge, 0, 100, true)


local qRange = 600
local eRange = 225
local wRange = 600

local qMana = 45
local wMana = 55 
local eMana = {45, 50, 55, 60, 65}

-- Plugin Overrides

function PluginOnLoad() 
	AutoCarry.SkillsCrosshair.range = 600 
	PluginMenu = AutoCarry.PluginMenu 
	MainMenu = AutoCarry.MainMenu 

	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("Killsteal", "Killsteal with Q", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("QFarm", "Last Hit with Q", SCRIPT_PARAM_ONOFF, true)
end 


function PluginOnTick() 

	Target = AutoCarry.GetAttackTarget()

	-- Q KS
	if PluginMenu.Killsteal then 
		Combat.KillSteal(SkillQ)
	end
	-- AutoCarry
	if Target and MainMenu.AutoCarry then

		if SkillW:Ready() and DamageCalculation.CalculateRealDamage(Target) > Target.health then
			SkillW:Cast(Target)
		end

		if SkillQ:Ready() then
			SkillQ:Cast(Target)
		end

		if SkillE:Ready() then
			SkillE:Cast(Target) 
		end 
	end

	-- Farminnn''' 
	if MainMenu.LastHit and PluginMenu.QFarm then
		Combat.LastHit(SkillQ)
	end

end 

function PluginOnCreateObj(obj)
	if obj and GetDistance(obj) <= 100 and obj.name == "pantheon_heartseeker_cas2" then
  		AutoCarry.CanMove = false
 	end
end

function PluginOnDeleteObj(obj)
	if obj and GetDistance(obj) <= 100 and obj.name == "pantheon_heartseeker_cas2" then
  		AutoCarry.CanMove = true
 	end
end