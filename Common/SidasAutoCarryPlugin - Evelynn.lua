--[[
	SAC Evelynn Plugin 
	Credits to Burn for his origional combo

	Version: 1.0
	- Initial release
	
	Version 1.2 
	- Converted to iFoundation_v2 
	- Bug fixes

		
]] 

require "AoE_Skillshot_Position"
require "iFoundation_v2"

local SkillQ = Caster(_Q, 500, SPELL_SELF)
local SkillW = Caster(_W, 0, SPELL_SELF)
local SkillE = Caster(_E, 225, SPELL_TARGETED)
local SkillR = Caster(_R, 650, SPELL_CIRCLE, math.huge, 0, 0, true)


function PluginOnLoad() 

	-- AutoCarry Settings
	AutoCarry.SkillsCrosshair.range = 650

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("RMec", "Use MEC for R", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("UseW", "Auto-Enable W when low health", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("WPercentage", "Percentage of health to use W",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
end


function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	
	if Target and MainMenu.AutoCarry then

		if SkillW:Ready() and PluginMenu.UseW and myHero.health <= myHero.maxHealth * (PluginMenu.WPercentage / 100) then
			SkillW:Cast(Target)
		end

		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 	

		if SkillR:Ready() and GetDistance(Target) <= SkillR.range then
			if PluginMenu.RMec then
				local p = GetAoESpellPosition(350, Target)
				if p and GetDistance(p) <= SkillR.range then
					CastSpell(_R, p.x, p.z)
				end
			else
				SkillR:Cast(Target)
			end
		end

	end

	-- Last Hitting
	if MainMenu.LastHit then
		Combat.LastHit(SkillQ)
	end


end

