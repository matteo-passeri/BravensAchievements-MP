-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

local onEat = ISEatFoodAction.perform

function ISEatFoodAction:perform()
    if self.item:getType() == "Bleach" and not BB_Achievements.waitASec.achieved then
        AchievementHandler.popIn(BB_Achievements.waitASec)
    end
    onEat(self)
end