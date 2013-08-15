require "iFoundation_v2"
--[[
	SAC Anivia plugin

	Version: 1.1 
	- Initial release

	Version: 1.2 
	- Updated to iFoundation

	LAST TESTED 1.2 ON 8.11 WORKING PERFECT
--]]

local SkillQ = Caster(_Q, 1100, SPELL_LINEAR, 860.05, 0.250, 110, true)
local SkillW = Caster(_W, 1000, SPELL_CIRCLE, math.huge, 0, 200, true) 
local SkillE = Caster(_E, 700, SPELL_TARGETED)
local SkillR = Caster(_R, 615, SPELL_CIRCLE, math.huge, 0, 200, true)

local GlacialStorm = false

local qObject = nil

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 1100
	PluginMenu = AutoCarry.PluginMenu
	MainMenu = AutoCarry.MainMenu
	lastMana = myHero.mana

	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("MaxPercentage", "Max percentage of mana for Ult",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	PluginMenu:addParam("wallCombo", "", SCRIPT_PARAM_ONOFF, true)
	Buffs.Instance()
end 

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()	

	if GlacialStorm then
		MonitorUltimate() 
	end 

	if Target and qObject ~= nil then
		if GetDistance(qObject, Target) <= 50 then
			CastSpell(_Q)
		end
	end

	-- AutoCarry
	if Target and MainMenu.AutoCarry then 
		
		if SkillW:Ready() and (DamageCalculation.CalculateRealDamage(Target) >= Target.health or PluginMenu.wallCombo) then
			PlaceWall(Target)
		end

		if SkillQ:Ready() and qObject == nil then
			SkillQ:Cast(Target)
		end

		if SkillE:Ready() and IsChilled(Target) then
			SkillE:Cast(Target)
		end

		if SkillR:Ready() and not GlacialStorm and myHero.mana > 200 then
			SkillR:Cast(Target)
		end
	end


end

function PluginOnCreateObj(obj)
	if obj.name:find("cryo_storm") then
  		GlacialStorm = true
  		lastMana = myHero.mana
 	elseif obj.name:find("FlashFrost_mis") then
 		qObject = obj
 	end
end

function PluginOnDeleteObj(obj)
    if obj.name:find("cryo_storm") then
  		GlacialStorm = false
 	elseif obj.name:find("FlashFrost_mis") then
 		qObject = nil
 	end
end

function IsChilled(enemy)
	return Buffs.TargetHaveBuff("chilled", enemy)
end


function PlaceWall(enemy) 
	if SkillW:Ready() and GetDistance(enemy) <= SkillW.range then
		local TargetPosition = Vector(enemy.x, enemy.y, enemy.z)
		local MyPosition = Vector(myHero.x, myHero.y, myHero.z)		
		local WallPosition = TargetPosition + (TargetPosition - MyPosition)*((150/GetDistance(enemy)))
		CastSpell(_W, WallPosition.x, WallPosition.z)
	end
end

function MonitorUltimate() 
	local maxMana = myHero.maxMana * (PluginMenu.MaxPercentage / 100)
	if (lastMana - myHero.mana) > maxMana then 
		DisableUltimate()
	end
end

function DisableUltimate()
	if SkillR:Ready() and GlacialStorm then
		CastSpell(_R)
	end
end