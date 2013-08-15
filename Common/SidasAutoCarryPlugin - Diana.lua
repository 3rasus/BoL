--[[
	Diana SAC Plugin
	
	Major credit to Llama for Prediction 
    
    Version 1.2
    - Converted to iFoundation_v2 
    - Bug fixes

    LAST TESTED 8.12 WORKING PERFECTLY

--]]
    
require "iFoundation_v2"    
-->> START From Llama <<--
--------------------------
local thetaIterator = 4 --increase to improve performance (0 - 10)
local rangeIterator = 30 --increase to improve performance (from 0-100)
local roundRange = 100 --higher means more minions collected, but possibly less accurate.

--[[  Q Calculations  ]] --
local rangeMax = 830
local enemyMinions = {}
local accel = -1483
local highestCollision
local highestAngle
local highestRange
local MODE_MINION = 1
local MODE_CHAMP = 2
--------------------------
--[[    Prediction      ]] --
local AttackDelayLatency = 1000
local lastBasicAttack = 0
local swingDelay = 1000
local HitBoxSize = GetDistance(myHero.minBBox)
local shotFired = false
local animationEnd = true
local animationTimer = 0
local mainTimer = GetTickCount()
local rtarget

if VIP_USER then
    tp = TargetPredictionVIP(rangeMax, 1800, 0.25, 10)
else
    tp = TargetPrediction(rangeMax, 1800, 250)
end

local MoonLightArray = {}
-->> END From Llama <<--

local qTick = 0
local rDelay = 0

local SkillQ = Caster(_Q, 830, SPELL_LINEAR_COL, math.huge, 0, 0, true)
local SkillW = Caster(_W, 200, SPELL_SELF)
local SkillE = Caster(_E, 250, SPELL_SELF)
local SkillR = Caster(_R, 825, SPELL_TARGETED)

function PluginOnLoad()
	AutoCarry.SkillsCrosshair.range = 800

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu

	PluginMenu:addParam("MisayaCombo", "Misaya Combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))

    enemyMinions = minionManager(MINION_ENEMY, rangeMax, player, MINION_SORT_HEALTH_ASC)

    Buffs.Instance()
end

function PluginOnTick() 

	-->> Llama Prediction <<--
	if GetTickCount() - animationTimer > AttackDelayLatency then
        animationEnd = false
    end
    AttackDelayLatency = ((1000 * (-0.435 + (0.625 / 0.625))) / (myHero.attackSpeed / (1 / 0.625))) - GetLatency() * 2

	Target = AutoCarry.GetAttackTarget()

	if Target then
		qPred = tp:GetPrediction(Target)
	end

	if Target and MainMenu.AutoCarry then

		--> Q Poke 
		if myHero:CanUseSpell(_Q) == READY and GetDistance(Target) <= SkillQ.range then
			CrescentCollision(MODE_CHAMP)
			CastQ()
		end

		if SkillR:Ready() and (HasMoonlight(Target) or getDmg("R", Target, myHero) > Target.health)then
			SkillR:Cast(Target)
		end

		if SkillW:Ready() then SkillW:Cast(Target) end 

		if SkillE:Ready() then SkillE:Cast(Target) end 

	end

	if Target and PluginMenu.MisayaCombo then
		if myHero:CanUseSpell(_Q) == READY and GetDistance(Target) <= SkillQ.range then
			CrescentCollision(MODE_CHAMP)
			CastQ()
			rDelay = (250 + (GetDistance(qPred) / 1.8))
			qTick = GetTickCount() 
		end

		if SkillR:Ready() then
			if GetTickCount() - qTick >= rDelay and GetTickCount() - qTick < 3000 - rDelay then
				SkillR:Cast(Target)
			end
		end

		if SkillW:Ready() then SkillW:Cast(Target) end 

        if SkillE:Ready() then SkillE:Cast(Target) end 
	end

    if MainMenu.LastHit then 
        enemyMinions:update() 
        CrescentCollision(MODE_MINION)
        if highestCollision > 0 and highestRange > 0 then
            CastSpell(_Q, myHero.x + highestRange * math.cos(highestAngle), myHero.z + highestRange * math.sin(highestAngle))
        elseif #enemyMinions.objects == 1 then
            CastSpell(_Q, enemyMinions.objects[1].x, enemyMinions.objects[1].z)
        end
    end

end 

function HasMoonlight(target)
	return Buffs.TargetHaveBuff("dianamoonlight", target)
end

function PluginOnProcessSpell(unit, spell)
    if unit.isMe and spell.name == "DianaArc" then MoonLight = false end
end

function CastQ() 
	if qPred ~= nil and SkillQ:Ready() and GetDistance(qPred) <= rangeMax then 
		if highestCollision > 0 then
			CastSpell(_Q, myHero.x + highestRange * math.cos(highestAngle), myHero.z + highestRange * math.sin(highestAngle))
		else
			CastSpell(_Q, qPred.x, qPred.z)
		end
        
	end
end 

--> START Llama Prediction <<--
function areClockwise(testv1, testv2)
    return -testv1.x * testv2.z + testv1.z * testv2.x > 0 --true if v1 is clockwise to v2
end

function getHitBoxRadius(target)
    return GetDistance(target.maxBBox, target.minBBox) / 2
end

function getMyTrueRange()
    return getRange() + HitBoxSize
end

function getRange()
    return myHero.range
end

function CrescentCollision(mode)

    local targetOriginal = {}
    local targetArray = {}
    local tsTargetOriginal = {}
    local theta, tsTargetAngle, tsTarget, tsAngle, tsVo, tsTestZ
    local targetAngle, target, angle, vo, testZ
    local tsFlag = false
    highestCollision = 0
    highestAngle = 0
    highestRange = 0
    if mode == MODE_CHAMP then
        for i = 1, heroManager.iCount do
            local hero = heroManager:GetHero(i)
            if ValidTarget(hero, rangeMax) then
                local dis = tp:GetPrediction(hero)
                table.insert(targetArray, dis)
            end
        end
        if Target and qPred then
            tsTargetOriginal = Vector(qPred.x - myHero.x, myHero.y, qPred.z - myHero.z)
            tsTargetAngle = tsTargetOriginal:polar()
        end
    elseif mode == MODE_MINION then
        targetArray = enemyMinions.objects
    end

    if #targetArray > 1 and QREADY then
        local rightTheta, leftTheta = GetBoundingVectors(targetArray)
        for newTheta = rightTheta, leftTheta, thetaIterator do --increase theta
            theta = math.rad(newTheta)

            for range = 400, rangeMax, rangeIterator do --increase range
                if highestCollision < #targetArray then
                    local collisionCount = 0
                    if mode == MODE_CHAMP and Target and qPred then --prioritize Target
                        tsTargetOriginal = Vector(qPred.x - myHero.x, myHero.y, qPred.z - myHero.z)
                        tsTarget = tsTargetOriginal:rotated(0, theta, 0)
                        tsAngle = math.rad((-47) - (830 - range) / (-20)) --interpolate launch angle
                        tsVo = math.sqrt((range * accel) / math.sin(2 * tsAngle)) -- initial velocity
                        tsTestZ = math.tan(tsAngle) * tsTarget.x - (accel / (2 * tsVo ^ 2 * math.cos(tsAngle) ^ 2)) * tsTarget.x ^ 2
                        if math.abs(math.ceil(tsTestZ) - math.ceil(qPred.z)) <= roundRange then
                            tsFlag = true
                            collisionCount = collisionCount + 1
                        else
                            tsFlag = false
                        end
                    end
                    if mode == MODE_MINION or (tsFlag and mode == MODE_CHAMP) then --only search other champs if Target is a collision
                        for index, minions in pairs(targetArray) do --iterate over minion/champ array
                            if mode == MODE_MINION or minions.charName ~= Target.charName then
                                targetOriginal = Vector(minions.x - myHero.x, myHero.y, minions.z - myHero.z)
                                targetAngle = targetOriginal:polar()

                                if (targetAngle <= newTheta) and ((mode ~= MODE_CHAMP) or (tsTargetAngle and tsTargetAngle <= newTheta)) then --angle of theta must be greater than target
                                    target = targetOriginal:rotated(0, theta, 0) --rotate to neutral axis
                                    angle = math.rad((-47) - (830 - range) / (-20)) --interpolate launch angle
                                    vo = math.sqrt((range * accel) / math.sin(2 * angle)) -- initial velocity
                                    testZ = math.tan(angle) * target.x - (accel / (2 * vo ^ 2 * math.cos(angle) ^ 2)) * target.x ^ 2

                                    if math.abs(math.ceil(testZ) - math.ceil(target.z)) <= roundRange then --compensate for rounding
                                        --collision detected
                                        collisionCount = collisionCount + 1
                                    end

                                    if collisionCount > highestCollision then
                                        highestCollision = collisionCount
                                        highestAngle = theta --in radians
                                        highestRange = range
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function GetBoundingVectors(coneTargetsTable)

    --Build table of enemies in range
    local n = 1
    local v1, v2, v3 = 0, 0, 0
    local largeN, largeV1, largeV2 = 0, 0, 0
    local theta1, theta2 = 0, 0

    if #coneTargetsTable >= 2 then -- true if calculation is needed
        for i = 1, #coneTargetsTable, 1 do
            for j = 1, #coneTargetsTable, 1 do
                if i ~= j then
                    --Position vector from player to 2 different targets.
                    v1 = Vector(coneTargetsTable[i].x - myHero.x, myHero.y, coneTargetsTable[i].z - myHero.z)
                    v2 = Vector(coneTargetsTable[j].x - myHero.x, myHero.y, coneTargetsTable[j].z - myHero.z)

                    if #coneTargetsTable == 2 then --only 2 targets, the result is found.
                        largeV1 = v1
                        largeV2 = v2
                    else
                        --Determine # of vectors between v1 and v2
                        local tempN = 0
                        for k = 1, #coneTargetsTable, 1 do
                            if k ~= i and k ~= j then
                                --Build position vector of third target
                                v3 = Vector(coneTargetsTable[k].x - myHero.x, myHero.y, coneTargetsTable[k].z - myHero.z)
                                --For v3 to be between v1 and v2
                                --it must be clockwise to v1
                                --and counter-clockwise to v2
                                if areClockwise(v3, v1) and not areClockwise(v3, v2) then
                                    tempN = tempN + 1
                                end
                            end
                        end
                        if tempN > largeN then
                            --store the largest number of contained enemies
                            --and the bounding position vectors
                            largeN = tempN
                            largeV1 = v1
                            largeV2 = v2
                        end
                    end
                end
            end
        end
    end

    theta1 = largeV1:polar() - 20
    theta2 = largeV2:polar() + 20
    if theta2 < theta1 then
        theta1 = theta1 - 360
    end
    return theta1, theta2
end
-->> END Llama <<--