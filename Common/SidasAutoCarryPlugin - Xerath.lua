--[[

	SAC Xerath plugin

	Features:
		- Full smart combo
			- Uses E > Q > R x 3 
			- Smart W control (uses W if the enemy is within a certain range)
			- Deactivates W when we need to move, and/or our combo is over (the enemy isn't killable)


	Version 1.0
	- Initial release

--]]

require "iFoundation_v2"

local SkillQ = Caster(_Q, 1050, SPELL_LINEAR, math.huge, 0.600) 
local SkillW = Caster(_W, 1750, SPELL_SELF)
local SkillE = Caster(_E, 650, SPELL_TARGETED)
local SkillR = Caster(_R, 900, SPELL_CIRCLE, math.huge, 0.250)

local wActive = false
local rTick = 0

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 2000

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if wActive then
		SkillQ.range = 1750
		SkillE.range = 950
		SkillR.range = 1600
	else
		SkillQ.range = 1050 
		SkillE.range = 650
		SkillR.range = 900 
	end 

	if rTick ~= 0 and GetTickCount() - rTick > 12000 then
		rTick = 0 
	end 

	if Target and MainMenu.AutoCarry then
		
		if (GetDistance(Target) > 1050 and GetDistance(Target) < 1750) and SkillW:Ready() and (SkillE:Ready() or SkillQ:Ready() or SkillR:Ready()) then
			if not wActive then
				SkillW:Cast(Target) 
				SkillQ.range = 1750
				SkillE.range = 950
				SkillR.range = 1600
			end 
		end 

		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillR:Ready() and ((rTick ~= 0 and GetTickCount() - rTick < 12000) or (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health)) then
			if rTick == 0 then
				rTick = GetTickCount()
			end 
			SkillR:Cast(Target) 
		end 

		if wActive and (GetDistance(Target) > 1750 or
					((not SkillQ:Ready() or GetDistance(Target) > SkillQ.range) and (not SkillE:Ready() or GetDistance(Target) > SkillE.range) and (not SkillR:Ready() or GetDistance(Target) > SkillR.range))) then
			SkillW:Cast(Target) 
		end 
	end
end

function PluginOnCreateObj(obj) 
	if obj and obj.name:find("Xerath_LocusOfPower") then
		wActive = true 
		AutoCarry.CanMove = false
	end 
end 

function PluginOnDeleteObj(obj) 
	if obj and obj.name:find("Xerath_LocusOfPower") then
		wActive = false
		AutoCarry.CanMove = false
	end 
end 
