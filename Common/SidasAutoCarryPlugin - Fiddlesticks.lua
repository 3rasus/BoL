--[[
	SAC Fiddlesticks plugin

	Version 1.0
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2 

--]]

require "AoE_Skillshot_Position"
require "iFoundation_v2"

local SkillQ = Caster(_Q, 575, SPELL_TARGETED)
local SkillW = Caster(_W, 475, SPELL_TARGETED)
local SkillE = Caster(_E, 750, SPELL_TARGETED)
local SkillR = Caster(_R, 800, SPELL_SELF)

local wTick = 0
local wCast = false
local wDuration = 5000

function PluginOnLoad() 

	AutoCarry.SkillsCrosshair.range = 800

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu

	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")

	wTick = GetTickCount()
end


function PluginOnTick()	

	Target = AutoCarry.GetAttackTarget() 

	wActive = (GetTickCount() - wTick < 5000 and not WREADY)
	if wActive then 
		AutoCarry.CanAttack = false
		AutoCarry.CanMove = false
	end 

	if Target and MainMenu.AutoCarry then
		if not wActive then
			AutoCarry.CanMove = true
			AutoCarry.CanAttack = true
			if SkillE:Ready() then SkillE:Cast(Target) end 
			if SkillW:Ready() then SkillW:Cast(Target) wTick = GetTickCount() end 
			if SkillQ:Ready() then SkillQ:Cast(Target) end 
			if SkillR:Ready() and (getDmg("R", Target, myHero) >= Target.health or Monitor.CountEnemies(myHero, SkillR.range) >= 2) then
				SkillR:Cast(Target)
			end 
		end
	end
end
