--[[

	SAC Nasus plugin

	Features
		- Basic combo
			- Q > E > W > R

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, math.huge, SPELL_SELF)
local SkillW = Caster(_W, 700, SPELL_TARGETED)
local SkillE = Caster(_E, 650, SPELL_CIRCLE)
local SkillR = Caster(_R, 300, SPELL_SELF)

local combo = ComboLibrary()

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 700
	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	if Target and MainMenu.AutoCarry then
		combo:CastCombo(Target) 
	end

	if MainMenu.LastHit then
		Combat.LastHit(SkillQ, SkillQ.range)
	end 
end
