-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

require "BB_Achievements_Main"
require "BB_Achievements_Tracker"

local climateManager = nil
local minTicks = 0

local function onLoadCharacter(playerNum, playerObj)
    -- Build 42 supplies playerNum and playerObj. Keep a fallback for older
    -- event dispatchers, but use the event player whenever it is available.
    if playerObj == nil and type(playerNum) ~= "number" then
        playerObj = playerNum
        playerNum = nil
    end
    if playerObj == nil and type(playerNum) == "number" and getSpecificPlayer then
        playerObj = getSpecificPlayer(playerNum)
    end
    if playerObj == nil then playerObj = getPlayer() end
    if playerObj == nil then return end

    -- Existing consumers use singleton globals and getPlayer(), which is the
    -- primary local player. Do not rebind them for another split-screen slot.
    if playerNum ~= nil and playerNum ~= 0 then return end
    if playerObj.getPlayerNum and playerObj:getPlayerNum() ~= 0 then return end

    BB_Achievements_InitPlayerState(playerObj)
    BB_Achievements_InitPlayerTracker(playerObj)
    climateManager = getClimateManager()

    if BB_Achievements_Tracker.characterName == "" then
        BB_Achievements_Tracker.characterName = playerObj:getFullName() or ""
    end

    -- ResetOnSwitch remains for sandbox compatibility. Per-player ModData
    -- already selects the correct character state, so switching does not reset.

    if not BB_Achievements.startGame.achieved then
        AchievementHandler.popIn(BB_Achievements.startGame)
    end
end

Events.OnCreatePlayer.Add(onLoadCharacter)

local function onZombieDead(zombie)
    -- Eh, keep this for the future. Too lazy to delete rn.
end

Events.OnZombieDead.Add(onZombieDead)

local function everyFiveMinutes()

    local playerObj = getPlayer()
    local playerInv = playerObj:getInventory()

    if not BB_Achievements.carryALot.achieved then
        local currCount = playerInv:getItems():size()

        if BB_Achievements_Tracker.itemsOnInv < currCount then
            BB_Achievements_Tracker.itemsOnInv = currCount
            if BB_Achievements_Tracker.itemsOnInv >= 100 then
                AchievementHandler.popIn(BB_Achievements.carryALot)
            end
        end
    end

    if not BB_Achievements.haveStuff1.achieved then
        local currCount = playerInv:getCountTypeRecurse("Base.Money")
        if currCount >= 1000 then
            AchievementHandler.popIn(BB_Achievements.haveStuff1)
        end
    end

    if not BB_Achievements.guardinGnome.achieved then
        local hasItem = playerInv:containsType("Base.Mov_GardenGnome")
        if hasItem then
            AchievementHandler.popIn(BB_Achievements.guardinGnome)
        end
    end

    if not BB_Achievements.findRevolver.achieved then
        local hasItem = playerInv:containsType("Revolver")
        if not hasItem then hasItem = playerInv:containsType("Revolver_Long") end
        if not hasItem then hasItem = playerInv:containsType("Revolver_Short") end

        if hasItem then
            AchievementHandler.popIn(BB_Achievements.findRevolver)
        end
    end

    if not BB_Achievements.findGun2.achieved then
        local hasItem = playerInv:containsType("Shotgun")
        if not hasItem then hasItem = playerInv:containsType("DoubleBarrelShotgun") end
        if not hasItem then hasItem = playerInv:containsType("DoubleBarrelShotgunSawnoff") end
        if not hasItem then hasItem = playerInv:containsType("ShotgunSawnoff") end

        if hasItem then
            AchievementHandler.popIn(BB_Achievements.findGun2)
        end
    end

    if not BB_Achievements.findGun3.achieved then
        local hasItem = playerInv:containsType("HuntingRifle")
        if not hasItem then hasItem = playerInv:containsType("VarmintRifle") end

        if hasItem then
            AchievementHandler.popIn(BB_Achievements.findGun3)
        end
    end

    if not BB_Achievements.findGun4.achieved then
        local hasItem = playerInv:containsType("AssaultRifle")
        if not hasItem then hasItem = playerInv:containsType("AssaultRifle2") end

        if hasItem then
            AchievementHandler.popIn(BB_Achievements.findGun4)
        end
    end

    if not (BB_Achievements.hyperthermia.achieved and BB_Achievements.hypothermia.achieved) then
        local playerTemp = playerObj:getTemperature()

        if not BB_Achievements.hyperthermia.achieved and playerTemp > 40 then
            AchievementHandler.popIn(BB_Achievements.hyperthermia)
        end

        if not BB_Achievements.hypothermia.achieved and playerTemp < 25 then
            AchievementHandler.popIn(BB_Achievements.hypothermia)
        end
    end

    if not BB_Achievements.driveVehicle.achieved then
        local vehicle = playerObj:getVehicle()
        if vehicle and vehicle:getCurrentSpeedKmHour() ~= 0 then
            AchievementHandler.popIn(BB_Achievements.driveVehicle)
        end
    end

    if not BB_Achievements.overburdened.achieved then
        if playerObj:getInventoryWeight() >= playerObj:getMaxWeight() * 2 then
            AchievementHandler.popIn(BB_Achievements.overburdened)
        end
    end

    local totalZombiesKilled = playerObj:getZombieKills() or 0

    if totalZombiesKilled > 0 then
        if not BB_Achievements.killZeds1.achieved then
            AchievementHandler.popIn(BB_Achievements.killZeds1)
        end

        if not BB_Achievements.killZeds2.achieved and totalZombiesKilled >= 50 then
            AchievementHandler.popIn(BB_Achievements.killZeds2)
        elseif not BB_Achievements.killZeds3.achieved and totalZombiesKilled >= 100 then
            AchievementHandler.popIn(BB_Achievements.killZeds3)
        end
    end
end

local function everyMinute()
    minTicks = minTicks + 1

    if minTicks >= 5 then
        everyFiveMinutes()
        minTicks = 0
    end
end

Events.EveryOneMinute.Add(everyMinute)

local function everyTenMinutes()

    if not BB_Achievements.stayAwake.achieved then

        if climateManager:getNightStrength() >= 0.5 then
            BB_Achievements_Tracker.timeAwake = BB_Achievements_Tracker.timeAwake + 10

            if BB_Achievements_Tracker.timeAwake >= 300 then
                AchievementHandler.popIn(BB_Achievements.stayAwake)
            end
        elseif BB_Achievements_Tracker.timeAwake > 0 then
            BB_Achievements_Tracker.timeAwake = 0
        end
    end
end

Events.EveryTenMinutes.Add(everyTenMinutes)

local function everyHour()

    if not (BB_Achievements.surviveDay1.achieved
    and BB_Achievements.surviveDay28.achieved
    and BB_Achievements.surviveDay196.achieved
    and BB_Achievements.pacifist.achieved) then

        local playerObj = getPlayer()
        local daysSurvived = (playerObj:getHoursSurvived() / 24)

        if not BB_Achievements.surviveDay1.achieved and daysSurvived >= 1 then
            AchievementHandler.popIn(BB_Achievements.surviveDay1)
        end

        if not BB_Achievements.surviveDay28.achieved and daysSurvived >= 28 then
            AchievementHandler.popIn(BB_Achievements.surviveDay28)
        end

        if not BB_Achievements.pacifist.achieved and daysSurvived >= 30 then
            local totalZombiesKilled = playerObj:getZombieKills() or 0
            if totalZombiesKilled == 0 then
                AchievementHandler.popIn(BB_Achievements.pacifist)
            end
        end

        if not BB_Achievements.surviveDay196.achieved and daysSurvived >= 196 then
            AchievementHandler.popIn(BB_Achievements.surviveDay196)
        end

        if not BB_Achievements.iAmLegend.achieved and daysSurvived >= 365 then
            AchievementHandler.popIn(BB_Achievements.iAmLegend)
        end
    end
end

Events.EveryHours.Add(everyHour)

local unusedPerks = {
    "None",
    "Agility",
    "Melee",
    "Crafting",
    "Survivalist",
    "Passive",
    "Firearm",
    "Blacksmith",
    "Melting",
    "Combat"
}

local function onLevelPerk(character, perk, level, levelUp)
    if character:getHoursSurvived() < 1 then return end

    if not BB_Achievements.lvlUp1.achieved then
        AchievementHandler.popIn(BB_Achievements.lvlUp1)
    end

    if not BB_Achievements.lvlUp2.achieved and level >= 7 then
        AchievementHandler.popIn(BB_Achievements.lvlUp2)
    end

    if not BB_Achievements.lvlUp3.achieved and level >= 10 then
        AchievementHandler.popIn(BB_Achievements.lvlUp3)
    end

    if not BB_Achievements.lvlUpMax.achieved then

        local perfectionCount = 0
        for i=1,Perks.getMaxIndex() do
            local currPerk = Perks.fromIndex(i - 1)
            if currPerk then
                local perkLevel = character:getPerkLevel(currPerk)
                if not BB_Achievements_Utils.tableContains(unusedPerks, currPerk:getName()) then
                    if perkLevel >= 10 then
                        perfectionCount = perfectionCount + 1
                    end
                end
            end
        end

        if not BB_Achievements.lvlUpMax.achieved and perfectionCount >= 5 then
            AchievementHandler.popIn(BB_Achievements.lvlUpMax)
        end
    end
end

Events.LevelPerk.Add(onLevelPerk)

local function onKeyPressed(key)
    local keybind = SandboxVars.Achievements.KeybindToggleWindow; if not keybind then return end
    if string.len(keybind) > 1 then return end
    keybind = BB_Achievements_Utils.KeyMappings[SandboxVars.Achievements.KeybindToggleWindow]
    if not keybind then return end

    if key == keybind then
        if not AchievementUIHandler.window then
            AchievementUIHandler.onMenuItemMouseDownMainMenu()
        else
            AchievementUIHandler.window:close()
        end
    end
end

Events.OnKeyPressed.Add(onKeyPressed)
