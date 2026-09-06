-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

local onHotwire = ISHotwireVehicle.perform

function ISHotwireVehicle:perform()
    onHotwire(self)

    local vehicle = self.character:getVehicle()
    BB_Achievements_Utils.DelayFunction(function()
        if vehicle and vehicle:isHotwired() and not BB_Achievements.gta.achieved then
            AchievementHandler.popIn(BB_Achievements.gta)
        end
    end, 150)
end
