--[[

	SAC Twitch

	Features
		- Basic combo
			- E (if posion stacks) > Q > W > R (if killable)

	Version 1.0 
	- Initial release

	Version 1.2 
	- Converted to iFoundation_v2

--]]

require "iFoundation_v2"
local SkillQ = Caster(_Q, math.huge, SPELL_SELF)
local SkillW = Caster(_W, 950, SPELL_CIRCLE, 1600, 0.250, 100, true)
local SkillE = Caster(_E, 1200, SPELL_SELF)
local SkillR = Caster(_R, 850, SPELL_SELF)

local enemyTable = {}

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 600

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
    PluginMenu:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)

	for i=0, heroManager.iCount, 1 do
        local playerObj = heroManager:GetHero(i)
        if playerObj and playerObj.team ~= myHero.team then
                playerObj.posion = { tick = 0, count = 0, }
                table.insert(enemyTable,playerObj)
        end
	end
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	enemy = GetEnemy(Target)

	if enemy then
		if (GetTickCount() - enemy.posion.tick > 6500) or enemy.dead then enemy.posion.count = 0 end 
	end 

	if Target and MainMenu.AutoCarry then

		if enemy.posion.count > 4 then 
			if SkillE:Ready() then SkillE:Cast(Target) end 
		end 

		if SkillQ:Ready() and PluginMenu.useQ then SkillQ:Cast(Target) end 
		if SkillW:Ready() then SkillW:Cast(Target) end 	
		if SkillR:Ready() and ((DamageCalculation.CalculateRealDamage(Target) > Target.health) or (getDmg("R", Target, myHero) > Target.health)) then SkillR:Cast(Target) end 	
	end
end

function GetEnemy(target) 
	for i, enemy in pairs(enemyTable) do 
		if enemy and not enemy.dead and enemy.visible and enemy == target then
			return enemy
		end 
	end 
end 

function OnGainBuff(unit, buff) 
	if unit == nil or buff == nil then return end 
	if buff.source == myHero then
		for i, enemy in pairs(enemyTable) do 
			if enemy and not enemy.dead and enemy.visible and enemy == unit then
				enemy.posion.tick = GetTickCount()
				enemy.posion.count = 1
			end 
		end 
	end 
end 

function OnChangeStack(unit, buff) 
	if unit == nil or buff == nil then return end 
	if buff.source == myHero then
		for i, enemy in pairs(enemyTable) do 
			if enemy and not enemy.dead and enemy.visible and enemy == unit then
				enemy.posion.tick = GetTickCount()
				enemy.posion.count = buff.stack
			end 
		end 
	end 
end 

