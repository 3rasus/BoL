--[[
	
	SAC Lissandra plugin

	Version 1.0
	- Initial release

	Version 1.1 
	- Herp-Derp skillshot fixes

	Version 1.2
	- Converted to iFoundation_v2

--]]
require "iFoundation_v2"

local SkillQ = Caster(_Q, 700, SPELL_LINEAR, 2250, 0.250, 100, true) 
local SkillW = Caster(_W, 450, SPELL_SELF)
local SkillE = Caster(_E, 1025, SPELL_LINEAR, 853, 0.250, 100, true) 
local SkillR = Caster(_R, 700, SPELL_TARGETED) 

local eClaw = nil 
local eClawRemoved = nil 

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
end 

function PluginOnTick()

	Target = AutoCarry.GetAttackTarget()

	if eClaw ~= nil and not eClaw.valid then
		eClaw = nil 
	end 

	-- AutoCarry
	if Target and MainMenu.AutoCarry then

		if DamageCalculation.CalculateRealDamage(Target) >= Target.health then
			if SkillE:Ready() then SkillE:Cast(Target) end -- First cast
			if SkillQ:Ready() then SkillQ:Cast(Target) end 
			if eClaw ~= nil and eClaw.valid then
				if GetDistance(eClaw, Target) < 50 then 
					if SkillE:Ready() and not UnderTurret(Target) then 
						CastSpell(_E) 
					end -- second cast
				end 
			end 
			if SkillW:Ready() then SkillW:Cast(Target) end 
		end 
		if ((eClaw == nil) or eClaw ~= nil and not eClaw.valid) and SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillR:Ready() and (DamageCalculation.CalculateRealDamage(true, Target) >= Target.health or getDmg("R", Target, myHero) > Target.health) then SkillR:Cast(Target) end 
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 
	end  

	-- LastHit
	if MainMenu.LastHit then
		Combat.LastHit(SkillE)
	end
end 

function PluginOnCreateObj(object)
	if object.name:find("Lissandra_E_Missile.troy") then
		eClaw = object
	end
end

function PluginOnDeleteObj(object)
	if object.name:find("Lissandra_E_Missile.troy") then
		eClaw = nil
		eClawRemoved = GetTickCount()
	end
end