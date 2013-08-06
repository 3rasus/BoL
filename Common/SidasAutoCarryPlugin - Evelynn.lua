--[[
	SAC Evelynn Plugin 
	Credits to Burn for his origional combo

	Version: 1.0
	
]] 

require "AoE_Skillshot_Position"

-- Constants
local eRange = 225
local qRange = 500 
local rRange = 650

local qMana = {16, 22, 28, 34, 40}
local wMana = 0
local eMana = {50, 55, 60, 65, 70}
local rMana = 100



function PluginOnLoad() 

	-- AutoCarry Settings
	AutoCarry.SkillsCrosshair.range = 500

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu
	
	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("RMec", "Use MEC for R", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("UseW", "Auto-Enable W when low health", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("WPercentage", "Percentage of health to use W",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)

	-- Local variables
	QREADY, WREADY, EREADY, RREADY = false, false, false, false
end


function PluginOnTick()
	-- Readies 
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)

	Target = AutoCarry.GetAttackTarget()

	
	if Target and MainMenu.AutoCarry then

		if WREADY and PluginMenu.UseW and myHero.health <= myHero.maxHealth * (PluginMenu.WPercentage / 100) then
			CastSpell(_W)
		end

		if QREADY and GetDistance(Target) <= qRange then
			CastSpell(_Q)
		end

		if EREADY and GetDistance(Target) <= eRange then
			CastSpell(_E, Target)
		end

		if RREADY and GetDistance(Target) <= rRange then
			if PluginMenu.RMec then
				local p = GetAoESpellPosition(350, Target)
				if p and GetDistance(p) <= rRange then
					CastSpell(_R, p.x, p.z)
				end
			else
				CastSpell(_R, Target.x, Target.z)
			end
		end

	end

	-- Last Hitting
	if MainMenu.LastHit then
		for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
			if ValidTarget(minion) and QREADY and GetDistance(minion) <= qRange then
				if minion.health < getDmg("Q", minion, myHero) then
					CastSpell(_Q, minion)
				end
			end
		end
	end


end

function CountEnemies(point, range)
    local ChampCount = 0
    for j = 1, heroManager.iCount, 1 do
        local enemyhero = heroManager:getHero(j)
        if myHero.team ~= enemyhero.team and ValidTarget(enemyhero, rRange + 50) then
            if GetDistance(enemyhero, point) <= range then
                ChampCount = ChampCount + 1
            end
        end
    end            
    return ChampCount
end

function PluginOnDraw() 
	if Target then
		DrawCircle(Target.x, Target.y, Target.z, 65, 0x00FF00)
		local text = ""
		if Target.health <= CalculateDamage(Target) then
			text = "Killable"
		else
			text = "Wait for Cooldowns"
		end
		PrintFloatText(Target, 0, text)
	end
end


function CalculateDamage(enemy) 
	local totalDamage = 0
	local currentMana = myHero.mana 
	local qReady = QREADY and currentMana >= qMana[myHero:GetSpellData(_Q).level]
	local eReady = EREADY and currentMana >= eMana[myHero:GetSpellData(_E).level]
	local rReady = RREADY and currentMana >= rMana
	if qReady then totalDamage = totalDamage + getDmg("Q", enemy, myHero) end
	if eReady then totalDamage = totalDamage + getDmg("E", enemy, myHero) end
	if rReady then totalDamage = totalDamage + getDmg("R", enemy, myHero) end
	return totalDamage
end
