--[[

	SAC Nasus plugin

--]]

require "iFoundation"
local SkillQ = Caster(_Q, math.huge, SPELL_SELF)
local SkillW = Caster(_W, 700, SPELL_TARGETED)
local SkillE = Caster(_E, 650, SPELL_CIRCLE)
local SkillR = Caster(_R, 300, SPELL_SELF)

local dmgCalc = DamageCalculation(true, {"Q", "W", "E", "R"}) 
local draw = Draw(dmgCalc) 

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	--PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	--PluginMenu:addParam("", "", SCRIPT_PARAM_ONOFF, true)
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		if SkillQ:Ready() then SkillQ:Cast(Target) end 
		if SkillE:Ready() then SkillE:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 	
		if SkillR:Ready() then SkillR:Cast(Target) end 	
	end

	if MainMenu.LastHit then
		dmgCalc:LastHitMinion(SkillQ, "Q")
	end

end

function PluginOnDraw()
	if Target == nil then return false end 
	draw:DrawTarget(Target)
end