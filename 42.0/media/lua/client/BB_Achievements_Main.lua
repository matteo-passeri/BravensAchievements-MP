-- **************************************************
-- Braven's Achievements persistent player state.
-- **************************************************

BB_Achievements = BB_Achievements or {}

local achievementDefinitions = {
    {id = "startGame", name = "IGUI_Achievement_Title_1", description = "IGUI_Achievement_Desc_1", icon = "A1"},
    {id = "killZeds1", name = "IGUI_Achievement_Title_2", description = "IGUI_Achievement_Desc_2", icon = "A2"},
    {id = "killZeds2", name = "IGUI_Achievement_Title_5", description = "IGUI_Achievement_Desc_5", icon = "A5"},
    {id = "killZeds3", name = "IGUI_Achievement_Title_6", description = "IGUI_Achievement_Desc_6", icon = "A6"},
    {id = "carryALot", name = "IGUI_Achievement_Title_3", description = "IGUI_Achievement_Desc_3", icon = "A3"},
    {id = "barricade1", name = "IGUI_Achievement_Title_4", description = "IGUI_Achievement_Desc_4", icon = "A4"},
    {id = "barricade2", name = "IGUI_Achievement_Title_9", description = "IGUI_Achievement_Desc_9", icon = "A9"},
    {id = "surviveDay1", name = "IGUI_Achievement_Title_7", description = "IGUI_Achievement_Desc_7", icon = "A7"},
    {id = "stayAwake", name = "IGUI_Achievement_Title_8", description = "IGUI_Achievement_Desc_8", icon = "A8"},
    {id = "findRevolver", name = "IGUI_Achievement_Title_10", description = "IGUI_Achievement_Desc_10", icon = "A10"},
    {id = "findGun2", name = "IGUI_Achievement_Title_16", description = "IGUI_Achievement_Desc_16", icon = "A16"},
    {id = "findGun3", name = "IGUI_Achievement_Title_17", description = "IGUI_Achievement_Desc_17", icon = "A17"},
    {id = "findGun4", name = "IGUI_Achievement_Title_18", description = "IGUI_Achievement_Desc_18", icon = "A18"},
    {id = "lvlUp1", name = "IGUI_Achievement_Title_11", description = "IGUI_Achievement_Desc_11", icon = "A11"},
    {id = "lvlUp2", name = "IGUI_Achievement_Title_12", description = "IGUI_Achievement_Desc_12", icon = "A12"},
    {id = "lvlUp3", name = "IGUI_Achievement_Title_13", description = "IGUI_Achievement_Desc_13", icon = "A13"},
    {id = "driveVehicle", name = "IGUI_Achievement_Title_14", description = "IGUI_Achievement_Desc_14", icon = "A14"},
    {id = "overburdened", name = "IGUI_Achievement_Title_15", description = "IGUI_Achievement_Desc_15", icon = "A15"},
    {id = "readStuff1", name = "IGUI_Achievement_Title_19", description = "IGUI_Achievement_Desc_19", icon = "A19"},
    {id = "lvlUpMax", name = "IGUI_Achievement_Title_20", description = "IGUI_Achievement_Desc_20", icon = "A20"},
    {id = "hypothermia", name = "IGUI_Achievement_Title_21", description = "IGUI_Achievement_Desc_21", icon = "A21"},
    {id = "hyperthermia", name = "IGUI_Achievement_Title_22", description = "IGUI_Achievement_Desc_22", icon = "A22"},
    {id = "surviveDay28", name = "IGUI_Achievement_Title_23", description = "IGUI_Achievement_Desc_23", icon = "A23"},
    {id = "surviveDay196", name = "IGUI_Achievement_Title_24", description = "IGUI_Achievement_Desc_24", icon = "A24"},
    {id = "haveStuff1", name = "IGUI_Achievement_Title_25", description = "IGUI_Achievement_Desc_25", icon = "A25"},
    {id = "guardinGnome", name = "IGUI_Achievement_Title_26", description = "IGUI_Achievement_Desc_26", icon = "A26"},
    {id = "waitASec", name = "IGUI_Achievement_Title_27", description = "IGUI_Achievement_Desc_27", icon = "A27"},
    {id = "pacifist", name = "IGUI_Achievement_Title_28", description = "IGUI_Achievement_Desc_28", icon = "A28"},
    {id = "iAmLegend", name = "IGUI_Achievement_Title_29", description = "IGUI_Achievement_Desc_29", icon = "A29"},
    {id = "openSesame", name = "IGUI_Achievement_Title_30", description = "IGUI_Achievement_Desc_30", icon = "A30"},
    {id = "gta", name = "IGUI_Achievement_Title_31", description = "IGUI_Achievement_Desc_31", icon = "A31"}
}

local function copyLegacyAchievements(legacy, destination)
    if legacy == nil or legacy.startGame == nil then return false end
    for key, value in pairs(legacy) do
        if type(value) == "table" then
            local copy = {}
            for field, fieldValue in pairs(value) do copy[field] = fieldValue end
            destination[key] = copy
        else
            destination[key] = value
        end
    end
    return true
end

function BB_Achievements_InitDefinitions(achievements)
    achievements = achievements or BB_Achievements
    for _, definition in ipairs(achievementDefinitions) do
        if achievements[definition.id] == nil then
            achievements[definition.id] = {name = definition.name, description = definition.description, icon = definition.icon, achieved = false}
        end
    end
end

function ResetAchievements()
    for _, definition in ipairs(achievementDefinitions) do
        BB_Achievements[definition.id] = {name = definition.name, description = definition.description, icon = definition.icon, achieved = false}
    end
end

function BB_Achievements_InitPlayerState(playerObj)
    if playerObj == nil then return false end

    local playerData = playerObj:getModData()
    local created = playerData.BB_Achievements == nil
    local migrated = false
    if created then
        playerData.BB_Achievements = {}
        -- Legacy Global ModData had no reliable owner in multiplayer, so only
        -- migrate it in single-player where it belongs to the sole character.
        if getWorld():getGameMode() ~= "Multiplayer" then
            migrated = copyLegacyAchievements(ModData.getOrCreate("BB_Achievements"), playerData.BB_Achievements)
        end
    end

    BB_Achievements = playerData.BB_Achievements
    BB_Achievements_InitDefinitions(BB_Achievements)

    if created then
        local playerName = playerObj:getFullName() or "player"
        local migrationText = migrated and " (migrated legacy single-player data)" or ""
        print("[BravensAchievements] Bound persistent achievement data for " .. playerName .. migrationText)
    end
    return true
end
