--[[
	SAC Shen Plugin
	
	Version 1.0

--]]

local SkillE = {spellKey = _E, range = 1000, speed = 1603, delay = 187, width = 110}

local qRange = 475
local wRange = 200
local eRange = 600
local rRange = 18500

local qMana = 0
local wMana = 0
local eMana = 0
local rMana = 0

local wLastHealth = 0
local wLastTick = 0

local rPlayer = nil
local rDisplay = nil 
local rLastTick = 0

function PluginOnLoad()

	AutoCarry.SkillsCrosshair.range = 630

	MainMenu = AutoCarry.MainMenu
	PluginMenu = AutoCarry.PluginMenu

	PluginMenu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
	PluginMenu:addParam("WRapid", "Use W when lost rapid amount of health", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("WPercentage", "Percent of health to use W",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	PluginMenu:addParam("WTime", "W tracking time",SCRIPT_PARAM_SLICE, 0, 2, 5, 0)
	PluginMenu:addParam("ComboW", "Use W in combo", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("MonitorR", "Monitor allies for R", SCRIPT_PARAM_ONOFF, true)
	PluginMenu:addParam("RPercentage", "Percent of ally health for R",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	PluginMenu:addParam("AutoR", "Press R to teleport to player", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("R"))

	QREADY, WREADY, EREADY, RREADY = false, false, false, false

	wLastTick = GetTickCount()
	rLastTick = GetTickCount()
end 

function PluginOnTick() 
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)

	Target = AutoCarry.GetAttackTarget()

	MonitorPlayer()
	if RREADY and PluginMenu.MonitorR then
		MonitorTeam() 
	end

	if RREADY and rPlayer ~= nil and PluginMenu.AutoR then
		CastSpell(_R, rPlayer)
		rPlayer = nil
	end

	if Target and MainMenu.AutoCarry then

		--> Standard Q harass 
		if QREADY and GetDistance(Target) <= qRange then
			CastSpell(_Q, Target)
		end

		--> Rapid health loss
		if WREADY and PluginMenu.WRapid and TakingRapidDamage() then
			CastSpell(_W)
		end

		--> W when in melee range
		if WREADY and PluginMenu.ComboW and GetDistance(Target) <= wRange then
			CastSpell(_W)
		end 	

		if EREADY and GetDistance(Target) <= eRange then
			CastSpell(_E, Target.x, Target.z)
		end
		
	end

	if MainMenu.LastHit then
		for _, minion in pairs(AutoCarry.EnemyMinions().objects) do 
			if ValidTarget(minion) and HasVorpal(minion) then
				myHero:Attack(minion)
			elseif ValidTarget(minion) and QREADY and GetDistance(minion) <= qRange then
				CastSpell(_Q, minion)

			end
		end
	end

end

function PluginOnDraw() 

	if RREADY and rPlayer ~= nil then
		DrawText("Player needs shield!!! Use R!", 50,520,100,0xFFFF0000)
	end		

end

function MonitorTeam()
	for i=1, heroManager.iCount do
		local champion = heroManager:GetHero(i)
		if IsAlly(champion) and champion.name ~= myHero.name and not champion.dead and GetDistance(champion) <= rRange then
			if champion.health / champion.maxHealth < (PluginMenu.RPercentage / 100) then
				rPlayer = champion

			end
		end
	end
end

function MonitorPlayer()
	if rPlayer == nil then return end 
	if GetTickCount() - rLastTick > (5 * 1000) then 
		if rPlayer.health / rPlayer.maxHealth > (PluginMenu.RPercentage / 100) then
			rPlayer = nil
		end
	end
end

function IsAlly(champion)
	return champion and champion.type == "obj_AI_Hero" and champion.team == myHero.team
end 

function TakingRapidDamage()
	--> Check if enough time has elapsed 
	if GetTickCount() - wLastTick > (PluginMenu.WTime * 1000) then
		--> Check amount of health lost
		if myHero.health - wLastHealth > myHero.maxHealth * (PluginMenu.WPercentage / 100) then
			return true
		else
			--> Reset counters
			wLastTick = GetTickCount()
			wLastHealth = myHero.health
		end
	end
end 

function HasVorpal(target)
	return TargetHaveBuff("ShenVorpalStar")
end 

function Skillshot(spell, target) 
    if not AutoCarry.GetCollision(spell, myHero, target) then
        AutoCarry.CastSkillshot(spell, target)
    end
end