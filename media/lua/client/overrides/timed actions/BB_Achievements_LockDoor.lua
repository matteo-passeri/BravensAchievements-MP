-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

local onLockDoor = ISLockDoor.perform

function ISLockDoor:perform()
    onLockDoor(self)

    local door = self.door
    BB_Achievements_Utils.DelayFunction(function()
        if door and not door:isLocked() and not BB_Achievements.openSesame.achieved then
            AchievementHandler.popIn(BB_Achievements.openSesame)
        end
    end, 150)
end