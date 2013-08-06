--[[
		
	SAC - Pantheon Edition

	Version: 0.1 
	- Pre-release
	
--]]

local qRange = 600
local eRange = 225
local wRange = 600

local qMana = 45
local wMana = 55 
local eMana = {45, 50, 55, 60, 65}

local floatText = {"Combo Kill", "Ultimate", "Killsteal", "Not Ready"}

-- Plugin Overrides

function PluginOnLoad() 
	AutoCarry.SkillsCrosshair.range = 600 
	PluginMenu = AutoCarry.PluginMenu 
	MainMenu = AutoCarry.MainMenu 

	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("Killsteal", "Killsteal with Q", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("QFarm", "Last Hit with Q", SCRIPT_PARAM_ONOFF, true)

	QREADY, WREADY, EREADY = false, false, false 
end 


function PluginOnTick() 

	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)

	Target = AutoCarry.GetAttackTarget()

	-- Q KS
	if PluginMenu.Killsteal and QREADY then 
		for i = 1, heroManager.iCount, 1 do
			local qTarget = heroManager:getHero(i)
			if ValidTarget(qTarget, qRange) then
				if qTarget.health <=  PassiveDamage(qTarget) then
					CastSpell(_Q, qTarget)
				end
			end
		end
	end
	-- AutoCarry
	if Target and MainMenu.AutoCarry then

		local damage = DiveDamage(Target)

		if Target.health <= damage and GetDistance(Target) <= wRange then
			CastSpell(_W, Target)
		end

		if QREADY and GetDistance(Target) <= qRange then
			CastSpell(_Q, Target)
		end

		if EREADY and GetDistance(Target) <= eRange then
			CastSpell(_E, Target.x, Target.z)
		end
	end

	-- Farminnn''' 
	if MainMenu.LastHit and PluginMenu.QFarm then
		for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
			if ValidTarget(minion) and QREADY and GetDistance(minion) <= qRange then
				if minion.health <= PassiveDamage(minion) then
					CastSpell(_Q, minion)
				end
			end
 		end
	end

end 

function PluginOnDraw() 
	if Target then
		DrawCircle(Target.x, Target.y, Target.z, 65, 0x00FF00)
		local text = ""
		if Target.health <= DiveDamage(Target) then
			text = "Killable"
		else
			text = "Wait for Cooldowns"
		end
		PrintFloatText(Target, 0, text)
	end
end

function PassiveDamage(minion) 
	local total = 0
	local critDamage = 2
	if GetInventorySlotItem(3031) then critDamage = 2.5 end 

	--> E passive
	if minion.health <= minion.maxHealth*0.15 then 
		if PluginMenu.QFarm and QREADY then
			total = getDmg("Q", minion, myHero) * critDamage
		end
	end
	return total
end

function DiveDamage(enemy) 
	local totalDamage = 0
    local wReady = WREADY and myHero.mana >= wMana
    local qReady = QREADY and myHero.mana >= qMana
    local eReady = EREADY and myHero.mana >= eMana[myHero:GetSpellData(_E).level]
    if wReady then totalDamage = totalDamage + getDmg("W", enemy, myHero) end
    if qReady then totalDamage = totalDamage + getDmg("Q", enemy, myHero) end
    if eReady then totalDamage = totalDamage + getDmg("E", enemy, myHero) end
    return totalDamage
end

function PluginOnCreateObj(obj)
	if obj and GetDistance(obj) <= 100 and obj.name == "pantheon_heartseeker_cas2" then
  		AutoCarry.CanMove = false
 	end
end

function PluginOnDeleteObj(obj)
	if obj and GetDistance(obj) <= 100 and obj.name == "pantheon_heartseeker_cas2" then
  		AutoCarry.CanMove = true
 	end
end