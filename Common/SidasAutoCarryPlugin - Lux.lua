--[[

	SAC Lux plugin

	Version 1.0 
	- Initial release

	Version 1.2
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, 1150, SPELL_LINEAR_COL, 1175, 0.250, 80, true)
local SkillW = Caster(_W, 1075, SPELL_LINEAR, 1400, 0.150, 50, true)
local SkillE = Caster(_E, 1100, SPELL_CIRCLE, 1300, 0.150, 275, true)
local SkillR = Caster(_R, 3000, SPELL_LINEAR, math.huge, 0.700, 200, true)

local EParticle = nil

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("rCombo", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("rKS", "KS with R", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("wMonitor", "Monitor W", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("wPercentage", "Monitor w percentage",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
end

function PluginOnTick()

	Target = AutoCarry.GetAttackTarget()

	if EParticle ~= nil and not EParticle.valid then 
		EParticle = nil 
	elseif EParticle ~= nil and EParticle.valid and GetDistance(EParticle, Target) <= 275 then
		SkillE:Cast(Target)
	end 

	if PluginMenu.rKS and SkillR:Ready() then
		Combat.KillSteal(SkillR)
	end 

	if Target and MainMenu.AutoCarry then

		if PluginMenu.wMonitor then
			if Monitor.GetLowAlly() ~= nil and SkillW:Ready() then
				SkillW:Cast(Monitor.GetLowAlly())
			elseif SkillW:Ready() and (myHero.health / myHero.maxHealth <= (PluginMenu.wPercentage / 100)) then
				SkillW:Cast(Target) 
			end
		end

		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() and EParticle == nil then SkillE:Cast(Target) end 
		if SkillR:Ready() and PluginMenu.rCombo and getDmg("R", Target, myHero) > Target.health then 
			SkillR:Cast(Target)
		end 

	end

end

function PluginOnCreateObj(object)

	if object.name:find("LuxLightstrike_tar") then

		EParticle = object

	end

end



function OnDeleteObj(object)

	if object.name:find("LuxLightstrike_tar") or (EParticle and EParticle.rawHash == object.rawHash) then

		EParticle = nil

	end 

end