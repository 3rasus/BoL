--[[
	SAC Fiddlesticks plugin
--]]

require "AoE_Skillshot_Position"

local qRange = 575
local wRange = 475
local eRange = 750
local rRange = 800

local qMana = {65, 75, 85, 95, 105}
local wMana = {80, 90, 100, 110, 120}
local eMana = {50, 70, 90, 110, 130}
local rMana = {150, 200, 250}

local wTick = 0
local wCast = false
local wDuration = 5000

function PluginOnLoad() 

	AutoCarry.SkillsCrosshair.range = 800

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu

	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("RMec", "Use MEC for R", SCRIPT_PARAM_ONOFF, true)

	QREADY, WREADY, EREADY, RREADY = false, false, false, false

	wTick = GetTickCount()
end


function PluginOnTick()	
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)

	Target = AutoCarry.GetAttackTarget() 

	wActive = (GetTickCount() - wTick < 5000 and not WREADY)
	AutoCarry.CanAttack = (not wActive) 

	if Target and MainMenu.AutoCarry then
		if not wActive then
			AutoCarry.CanMove = true
			if EREADY and GetDistance(Target) <= eRange then
				CastSpell(_E, Target)
			end

			if WREADY and GetDistance(Target) <= wRange then
				wTick = GetTickCount()
				CastSpell(_W, Target)
			end

			if QREADY and GetDistance(Target) <= qRange then
				CastSpell(_Q, Target)
			end

			--> Kill with ult
			if RREADY and GetDistance(Target) <= rRange and Target.health < getDmg("R", myHero, Target) then
				CastSpell(_R, Target) 
			elseif RREADY and GetDistance(Target) <= rRange then
				if PluginMenu.RMec then
					local p = GetAoESpellPosition(600, Target)
					if p and GetDistance(p) <= rRange and CountEnemies(p, rRange) >= 2 then
						CastSpell(_R, p.x, p.z)
					end
				end
			end
		end

	end

end


function CalculateDamage(enemy)
	local totalDamage = 0
	local currentMana = myHero.mana 
	local qReady = QREADY and currentMana >= qMana[myHero:GetSpellData(_Q).level]
	local wReady = WREADY and currentMana >= wMana[myHero:GetSpellData(_W).level]
	local eReady = EREADY and currentMana >= eMana[myHero:GetSpellData(_E).level]
	local rReady = RREADY and currentMana >= rMana[myHero:GetSpellData(_R).level] 
	if qReady then totalDamage = totalDamage + getDmg("Q", enemy, myHero) end
	if wReady then totalDamage = totalDamage + getDmg("W", enemy, myHero) end
	if eReady then totalDamage = totalDamage + getDmg("E", enemy, myHero) end
	if rReady then totalDamage = totalDamage + getDmg("R", enemy, myHero) end
	return totalDamage 
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