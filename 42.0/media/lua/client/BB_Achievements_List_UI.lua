-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

require "ISUI/ISPanelJoypad"

-- Create the main window.
BB_Achievements_List_UI = ISCollapsableWindow:derive("BB_Achievements_List_UI")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

function BB_Achievements_List_UI:createChildren()
    ISCollapsableWindow.createChildren(self)
end

function BB_Achievements_List_UI:prerender()
    ISCollapsableWindow.prerender(self)
    self:drawTextCentre(getText("Sandbox_Achievements"), self.width / 2, 0, 1, 1, 1, 1, UIFont.Small)
end

function BB_Achievements_List_UI:render()
    ISCollapsableWindow.render(self)
end

function BB_Achievements_List_UI:close()
    self:setVisible(false)
    self:removeFromUIManager()
    AchievementUIHandler.window = nil
end

function BB_Achievements_List_UI:new(character)
    local width, height = 800, 500
    local playerNum = character:getPlayerNum()
    local x = (getPlayerScreenWidth(playerNum) / 2) - (width / 2)
    local y = (getPlayerScreenHeight(playerNum) / 2) - (height / 2)

    local o = ISCollapsableWindow.new(self, x, y, width, height)
    o.chr = character
    o.playerNum = playerNum
    o.moveWithMouse = true
    o.anchorLeft = true
    o.anchorRight = true
    o.anchorTop = true
    o.anchorBottom = true
    return o
end

function BB_Achievements_List_UI:initialise()
    ISCollapsableWindow.initialise(self)
    local btnHgt = FONT_HGT_SMALL + 2
    local y = 95

    self.achievementList = ISScrollingListBox:new(10, y, self.width - 20, self.height - (5 + btnHgt + 5) - y)
    self.achievementList:initialise()
    self.achievementList:instantiate()
    self.achievementList.itemheight = 72
    self.achievementList.selected = 0
    self.achievementList.joypadParent = self
    self.achievementList.font = UIFont.NewSmall
    self.achievementList.doDrawItem = self.drawAchievements
    self.achievementList.drawBorder = true
    self.achievementList:addColumn(getText("IGUI_Achievement_Icon"), 0)
    self.achievementList:addColumn(getText("IGUI_Achievement_Name"), 69)
    self.achievementList:addColumn(getText("IGUI_Achievement_Description"), 250)
    self.achievementList:addColumn(getText("IGUI_Achievement_Achieved"), (self.width - 100))
    self:addChild(self.achievementList)
end

function BB_Achievements_List_UI:populateList()
    self.achievementList:clear()
    local sortedAchievements = {}

    for _, achievement in pairs(BB_Achievements) do
        table.insert(sortedAchievements, achievement)
    end

    table.sort(sortedAchievements, function(a, b)
        local aName = a.name and a.name:sub(1, 1) or ""
        local bName = b.name and b.name:sub(1, 1) or ""
        return aName < bName
    end)

    if #sortedAchievements == 0 then
        self.achievementList:addItem("None", {name = "None", description = "None", icon = "None", achieved = false})
    else
        for _, achievement in ipairs(sortedAchievements) do
            self.achievementList:addItem(achievement.name, achievement)
        end
    end
end

function BB_Achievements_List_UI:drawAchievements(y, entry, alt)
    local a = 0.9
    self:drawRectBorder(0, (y), self:getWidth(), self.itemheight - 1, a, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    self:drawRect(69, y, 1, self.itemheight, 0.5, 1, 1, 1)
    self:drawRect(250, y, 1, self.itemheight, 0.5, 1, 1, 1)
    self:drawRect(self.width - 80, y, 1, self.itemheight, 0.5, 1, 1, 1)

    if self.selected == entry.index then
        self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15)
    end

    if entry.item.icon then
        local texture = getTexture("media/ui/" .. entry.item.icon .. ".png")
        if texture then
            if not entry.item.achieved then
                self:drawTextureScaled(texture, 3, y + 4, 64, 64, 1, 0.5, 0.5, 0.5)
            else
                self:drawTextureScaled(texture, 3, y + 4, 64, 64, 1)
            end
        end
    end

    if entry.item.name and entry.item.description then
        self:drawText(BB_Achievements_Utils.WrapText(getText(entry.item.name), 20), 100, y + 20, 1, 1, 1, a, UIFont.Medium)
        self:drawText(BB_Achievements_Utils.WrapText(getText(entry.item.description), 80), self.columns[3].size + 10, y + 10, 1, 1, 1, a, self.font)
    else
        self:drawText(BB_Achievements_Utils.WrapText("ERR: INVALID DATA", 20), 100, y + 20, 1, 1, 1, a, UIFont.Medium)
        self:drawText(BB_Achievements_Utils.WrapText("ERR: INVALID DATA", 80), self.columns[3].size + 10, y + 10, 1, 1, 1, a, self.font)
    end

    local achievedTexture = entry.item.achieved and "media/ui/Achieved.png" or "media/ui/Not Achieved.png"
    self:drawTextureScaled(getTexture(achievedTexture), self.columns[4].size + 20, y + 20, 32, 32, 1)

    return y + self.itemheight
end

