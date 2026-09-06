-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

AchievementHandler = {}

AchievementHandler.popIn = function (achievement)
    if achievement.achieved == true then print("ERROR: ACHIEVEMENT ALREADY COMPLETED!") return end
    local playerObj = getPlayer()
    local ui = BB_Achievements_Pop_UI:new(achievement, playerObj)
    ui:initialise()
    ui:addToUIManager()

    if SandboxVars.Achievements.PlaySound then
        BB_Achievements_Utils.TryPlaySoundClip(playerObj, "AchievementUnlocked")
    end

    achievement.achieved = true
end