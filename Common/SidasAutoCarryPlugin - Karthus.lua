--[[

	SAC Karthus
	
	Version 1.0 
	- Initial release

	Version 1.2
	- Converted to iFoundation_v2


--]]

require "iFoundation_v2"

local SkillQ = Caster(_Q, 875, SPELL_CONE)
local SkillW = Caster(_W, 1000, SPELL_CONE)
local SkillE = Caster(_E, 425, SPELL_SELF)
local SkillR = Caster(_R, math.huge, SPELL_SELF)

local eEnabled = false 

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("rKS", "KS with R (MEGAKILL)", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()

	Target = AutoCarry.GetAttackTarget()

	if eEnabled and (Target == nil or GetDistance(Target) > SkillE.range) then
		SkillE:Cast(Target)
	end 

	if SkillR:Ready() and PluginMenu.rKS then
		Combat.KillSteal(SkillR)
	end 

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 
		if SkillE:Ready() and not eEnabled then SkillE:Cast(Target) end 
	end

	if MainMenu.LastHit then
		Combat.LastHit(SkillQ)
	end

end

function PluginOnCreateObj(obj)
	if obj ~= nil and obj.name == "Defile_glow.troy" then
        eEnabled = true
    end
end 

function PluginOnDeleteObj(obj)
	if obj ~= nil and obj.name == "Defile_glow.troy" then
        eEnabled = false
    end 
end 