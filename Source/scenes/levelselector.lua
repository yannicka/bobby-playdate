class('LevelSelectorScene').extends(Scene)

function loadFinishedLevels()
    local finishedLevels = playdate.datastore.read()
    
    if finishedLevels == nil then
        finishedLevels = {}
    end

    return finishedLevels
end

function LevelSelectorScene:init()
    LevelSelectorScene.super.init(self)

    finishedLevels = loadFinishedLevels()

    self.gridviewSprite = playdate.graphics.sprite.new()
    self.gridviewSprite:setCenter(0, 0)
    self.gridviewSprite:moveTo(0, 0)
    self.gridviewSprite:add()

    self.gridview = playdate.ui.gridview.new(30, 30)

    self.gridview:setNumberOfColumns(10)
    self.gridview:setNumberOfRows(5)
    self.gridview:setCellPadding(4, 4, 4, 4)
    self.gridview:setContentInset(9, 0, 12, 0)
    self.gridview:setSectionHeaderHeight(24)

    function self.gridview:drawSectionHeader(section, x, y, width, height)
        local fontHeight = playdate.graphics.getSystemFont():getHeight()
        playdate.graphics.drawTextAligned('Choix du niveau', x, y, kTextAlignment.left)
    end

    function self.gridview:drawCell(section, row, column, selected, x, y, width, height)
        playdate.graphics.setLineWidth(1)
        playdate.graphics.setColor(playdate.graphics.kColorBlack)

        local levelIndex = tonumber((row - 1) * 10) + tonumber(column)
        local levelName = levelsOrder[levelIndex]
        local finished = table.contains(finishedLevels, levelName)

        if finished then
            playdate.graphics.fillRoundRect(x, y, width, height, 8)
        else
            playdate.graphics.drawRoundRect(x, y, width, height, 8)
        end

        if selected then
            playdate.graphics.setLineWidth(2)
            playdate.graphics.drawRoundRect(x - 3, y - 3, width + 6, height + 6, 11)
        end

        local fontHeight = playdate.graphics.getSystemFont():getHeight()

        playdate.graphics.drawTextInRect(tostring(levelIndex), x, y + (height / 2 - fontHeight / 2) + 3, width, height, nil, nil, kTextAlignment.center)
    end

    for i = 1,50 do
        local levelName = levelsOrder[i]
        local finished = table.contains(finishedLevels, levelName)

        if not finished then
            local row = math.ceil(i / 10)
            local column = i % 10

            self.gridview:setSelection(1, row, column)
            
            break
        end
    end
end

function LevelSelectorScene:update()
    playdate.graphics.setDrawOffset(0, 0)

    if playdate.buttonJustPressed(playdate.kButtonUp) then
        self.gridview:selectPreviousRow(true)
    elseif playdate.buttonJustPressed(playdate.kButtonDown) then
        self.gridview:selectNextRow(true)
    elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
        self.gridview:selectPreviousColumn(true)
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        self.gridview:selectNextColumn(true)
    end

    local crankTicks = playdate.getCrankTicks(2)

    if crankTicks == 1 then
        self.gridview:selectNextRow(true)
    elseif crankTicks == -1 then
        self.gridview:selectPreviousRow(true)
    end

    if self.gridview.needsDisplay then
        local gridviewImage = playdate.graphics.image.new(playdate.display.getWidth(), playdate.display.getHeight())
        playdate.graphics.pushContext(gridviewImage)
        self.gridview:drawInRect(0, 0, playdate.display.getWidth(), playdate.display.getHeight())
        playdate.graphics.popContext()
        self.gridviewSprite:setImage(gridviewImage)
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        local section, row, column = self.gridview:getSelection()
        local levelIndex = tonumber((row - 1) * 10) + tonumber(column)

        self.gridviewSprite:remove()

        local levelName = levelsOrder[levelIndex]
        loadLevel(levelName)
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end

    playdate.graphics.sprite.update()
    playdate.timer.updateTimers()
end

function LevelSelectorScene:destroy()
end
