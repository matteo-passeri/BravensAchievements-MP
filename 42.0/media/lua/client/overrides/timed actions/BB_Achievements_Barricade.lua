-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

local onBarricade = ISBarricadeAction.perform

function ISBarricadeAction:perform()
    if not BB_Achievements.barricade1.achieved then
        AchievementHandler.popIn(BB_Achievements.barricade1)
    end

    if not BB_Achievements.barricade2.achieved then
        BB_Achievements_Tracker.barricades = BB_Achievements_Tracker.barricades + 1
        if not BB_Achievements.barricade2.achieved and BB_Achievements_Tracker.barricades >= 100 then
            AchievementHandler.popIn(BB_Achievements.barricade2)
        end
    end

    onBarricade(self)
end