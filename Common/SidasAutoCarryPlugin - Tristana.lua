--[[

	SAC Tristana plugin

	Features
		- Smart combo 
			- W > E > R
		- InSec combo (push-back combo)
			- Uses W (behind target) > E (damage) > R (pushback into our turret) 

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, math.huge, SPELL_SELF)
local SkillW = Caster(_W, 900, SPELL_CIRCLE, math.huge, 0, 100, true)
local SkillE = Caster(_E, 650, SPELL_TARGETED)
local SkillR = Caster(_R, 645, SPELL_TARGETED)

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("pushBackCombo", "Push back combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("R"))
	AutoBuff.Instance(SkillQ)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if PluginMenu.pushBackCombo then
			if SkillW:Ready() then PlaceWall(Target) end 
			if SkillE:Ready() then SkillE:Cast(Target) end 
			if SkillR:Ready() then SkillR:Cast(Target) end 
		else
			if SkillW:Ready() then SkillW:Cast(Target) end  
			if SkillE:Ready() then SkillE:Cast(Target) end 
			if SkillR:Ready() and getDmg("R", Target, myHero) > Target.health then SkillR:Cast(Target) end 
		end  	
	end
end


function PlaceWall(enemy) 
	if SkillW:Ready() and GetDistance(enemy) <= SkillW.range then
		local TargetPosition = Vector(enemy.x, enemy.y, enemy.z)
		local MyPosition = Vector(myHero.x, myHero.y, myHero.z)		
		local WallPosition = TargetPosition + (TargetPosition - MyPosition)*((150/GetDistance(enemy)))
		CastSpell(_W, WallPosition.x, WallPosition.z)
	end
end