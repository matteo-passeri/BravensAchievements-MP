-- **************************************************
-- Braven's Achievements persistent player trackers.
-- **************************************************

BB_Achievements_Tracker = BB_Achievements_Tracker or {}

local function copyLegacyTrackers(legacy, destination)
    if legacy == nil or legacy.characterName == nil then return false end
    for key, value in pairs(legacy) do destination[key] = value end
    return true
end

function BB_Achievements_InitTracker(tracker)
    tracker = tracker or BB_Achievements_Tracker
    if tracker.characterName == nil then tracker.characterName = "" end
    if tracker.itemsOnInv == nil then tracker.itemsOnInv = 0 end
    if tracker.barricades == nil then tracker.barricades = 0 end
    if tracker.timeAwake == nil then tracker.timeAwake = 0 end
end

function ResetAchievementTrackers()
    BB_Achievements_Tracker.characterName = ""
    BB_Achievements_Tracker.itemsOnInv = 0
    BB_Achievements_Tracker.barricades = 0
    BB_Achievements_Tracker.timeAwake = 0
end

function BB_Achievements_InitPlayerTracker(playerObj)
    if playerObj == nil then return false end

    local playerData = playerObj:getModData()
    local created = playerData.BB_Achievements_Tracker == nil
    if created then
        playerData.BB_Achievements_Tracker = {}
        -- Global tracker data is unsafe to assign automatically to an
        -- individual multiplayer character.
        if getWorld():getGameMode() ~= "Multiplayer" then
            copyLegacyTrackers(ModData.getOrCreate("BB_Achievements_Tracker"), playerData.BB_Achievements_Tracker)
        end
    end

    BB_Achievements_Tracker = playerData.BB_Achievements_Tracker
    BB_Achievements_InitTracker(BB_Achievements_Tracker)
    return true
end
