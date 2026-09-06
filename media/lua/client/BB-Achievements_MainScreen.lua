-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

AchievementUIHandler = {}

local mainScreenInstantiate = MainScreen.instantiate

AchievementUIHandler.onMenuItemMouseDownMainMenu = function()
    if not AchievementUIHandler.window then
        AchievementUIHandler.window = BB_Achievements_List_UI:new(getPlayer())
        AchievementUIHandler.window:initialise()
        AchievementUIHandler.window:addToUIManager()
        AchievementUIHandler.window:populateList()
    else
        AchievementUIHandler.window:close()
    end
end

function MainScreen:instantiate()
    mainScreenInstantiate(self)

    local mainScreen = MainScreenState.getInstance();
	if mainScreen ~= nil and (ISDemoPopup.instance == nil) then

        if getPlayer() then
            local playerNum = getPlayer():getPlayerNum()

            local width = 80
            local height = 20
            local x = ((getPlayerScreenLeft(playerNum) + getPlayerScreenWidth(playerNum)) - width) - 35
            local y = ((getPlayerScreenTop(playerNum) + getPlayerScreenHeight(playerNum)) - height) - 70

            local achievementsButton = ISButton:new(x, y, width, height, getText("Sandbox_Achievements"), self, AchievementUIHandler.onMenuItemMouseDownMainMenu)
            self:addChild(achievementsButton)
        end
	end
end