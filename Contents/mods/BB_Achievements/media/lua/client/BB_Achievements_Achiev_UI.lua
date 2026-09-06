-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

require "ISUI/ISPanelJoypad"
BB_Achievements_Pop_UI = ISPanel:derive("BB_Achievements_Pop_UI")

function BB_Achievements_Pop_UI:createChildren()

    BB_Achievements_Utils.DelayFunction(function()
        self:close()
    end, SandboxVars.Achievements.DisplayDuration)

	ISPanel.createChildren(self)
end

function BB_Achievements_Pop_UI:prerender()
	--ISPanel.prerender(self)

    if not self.renderedBackground then
		local texture = getTexture("media/ui/Background UI.png")
        if texture then
            self.renderedBackground = self:drawTextureScaled(texture, 0, 0, self.width, self.height, 0.95)
        end
    end

    if not self.renderedSpiffo then
		local texture = getTexture("media/ui/Spiffo UI.png")
        if texture then
            self.renderedSpiffo = self:drawTextureScaled(texture, 160, -10, 152, 183, 0.3)
        end
    end

    if not self.renderedIcon then
		local texture = getTexture("media/ui/" .. self.icon .. ".png")
        if texture then
            self.renderedIcon = self:drawTextureScaled(texture, 4, 6, 72, 72, 1)
        end
    end

    if not self.descriptionLabel then
		self.titleLabel = ISLabel:new(82, 18, 10, BB_Achievements_Utils.TruncateString(getText(self.name), 18), 1, 1, 1, 1, UIFont.Medium, true)
		self:addChild(self.titleLabel)

		self.descriptionLabel = ISLabel:new(82, 44, 10, BB_Achievements_Utils.WrapAndTruncateString(getText(self.description), 32, 68), 1, 1, 1, 1, UIFont.Small, true)
		self:addChild(self.descriptionLabel)
    end
end

function BB_Achievements_Pop_UI:render()
	ISPanel.render(self)
end

function BB_Achievements_Pop_UI:close()
	self:setVisible(false)
	self:removeFromUIManager()
end

function BB_Achievements_Pop_UI:new(achievement, character)
	local width = 280
	local height = 82
    local playerNum = character:getPlayerNum()

    local x = (getPlayerScreenLeft(playerNum) + getPlayerScreenWidth(playerNum)) - width
    local y = (getPlayerScreenTop(playerNum) + getPlayerScreenHeight(playerNum)) - height
	local o = ISPanel.new(self, x, y, width, height)

	o.width = width
	o.height = height
	o.chr = character
    o.playerNum = playerNum
    o.name = achievement.name
    o.description = achievement.description
	o.icon = achievement.icon
	o.moveWithMouse = false
	o.anchorRight = true
	o.anchorBottom = true
    o.keepOnScreen = true
	return o
end