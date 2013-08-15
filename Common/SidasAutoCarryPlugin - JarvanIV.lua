--[[

	SAC Jarvan IV plugin (PRIVATE)
	
	Version 1.0
	- Initial release

	Version 1.1 
	- Banner combo fixed

	Version 1.2 
	- Converted to iFoundation_v2
--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 770, SPELL_LINEAR, math.huge, 0.200, 100, true)
local SkillW = Caster(_W, math.huge, SPELL_SELF)
local SkillE = Caster(_E, 830, SPELL_CIRCLE, math.huge, 0.200, 100, true)
local SkillR = Caster(_R, 650, SPELL_TARGETED)

local dStandard = nil
local qDelay = 0

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("eChase", "Chase with E", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("wDistance", "W Distance",SCRIPT_PARAM_SLICE, 0, 0, 600, 0)
	PluginMenu:addParam("eBuff", "Use E for buff (may miss chase)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
	AutoShield.Instance(SkillW.range, SkillW)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if dStandard ~= nil and not dStandard.valid then
		dStandard = nil
	end 

	if Target and MainMenu.AutoCarry then
		--[[if (PluginMenu.eChase or dmgCalc:CalculateRealDamage(true, Target) > Target.health) and GetDistance(Target) >= SkillQ.range then 
			if dStandard ~= nil and dStandard.valid then 
				if GetDistance(dStandard, Target) <= 300 and SkillQ:Ready() then
					SkillQ:Cast(dStandard) 
				end 
			elseif SkillE:Ready() then 
				SkillE:Cast(Target)
			end  
		end]]--
		if SkillE:Ready() then SkillE:Cast(Target) end  
		--if SkillW:Ready() and GetDistance(Target) <= PluginMenu.wDistance then SkillW:Cast(Target) end 
        if SkillQ:Ready() then 
			--[[if dStandard ~= nil then
				SkillQ:Cast(dStandard)
				dStandard = nil
			else--]] 
				SkillQ:Cast(Target)
			--end 
		end
		if PluginMenu.eBuff and SkillE:Ready() then SkillE:Cast(myHero) end 
	end

end

function PluginOnCreateObj(obj)
 
        if obj ~= nil and string.find(obj.name, "JarvanDemacianStandard_buf") then
 
                dStandard = obj
 
        end
 
end
 
 
 
function PluginOnDeleteObj(obj)
 
        if obj ~= nil and string.find(obj.name, "JarvanDemacianStandard_buf") then
 
                dStandard = nil
 
        end
 
end