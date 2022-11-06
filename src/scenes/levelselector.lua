local gfx <const> = playdate.graphics
local menu <const> = playdate.getSystemMenu()

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

    self.menuHome, error = menu:addMenuItem('go home', function()
        changeScene(HomeScene)
    end)

    gfx.setDrawOffset(0, 0)

    finishedLevels = loadFinishedLevels()

    self.gridviewSprite = gfx.sprite.new()
    self.gridviewSprite:setCenter(0, 0)
    self.gridviewSprite:moveTo(0, 0)
    self.gridviewSprite:add()

    self.gridview = playdate.ui.gridview.new(30, 30)
    self.gridview:setNumberOfColumns(10)
    self.gridview:setNumberOfRows(5)
    self.gridview:setCellPadding(4, 4, 4, 4)
    self.gridview:setContentInset(9, 0, 12, 0)
    self.gridview:setSectionHeaderHeight(28)

    function self.gridview:drawSectionHeader(section, x, y, width, height)
        gfx.drawTextAligned('*Select level*', x + 4, y, kTextAlignment.left)
    end

    function self.gridview:drawCell(section, row, column, selected, x, y, width, height)
        local initialDrawMode <const> = gfx.getImageDrawMode()

        gfx.setLineWidth(1)

        local levelIndex <const> = tonumber((row - 1) * 10) + tonumber(column)
        local levelName <const> = levelsOrder[levelIndex]
        local finished <const> = table.contains(finishedLevels, levelName)

        if finished then
            gfx.fillRoundRect(x, y, width, height, 8)
        else
            gfx.drawRoundRect(x, y, width, height, 8)
        end

        if selected then
            gfx.setLineWidth(2)
            gfx.drawRoundRect(x - 3, y - 3, width + 6, height + 6, 11)
        end

        if finished then
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        end

        local fontHeight <const> = gfx.getSystemFont():getHeight()

        gfx.drawTextInRect(
            '*' .. tostring(levelIndex) .. '*',
            x,
            y + (height / 2 - fontHeight / 2) + 2,
            width,
            height,
            nil,
            nil,
            kTextAlignment.center
        )

        if finished then
            gfx.setImageDrawMode(initialDrawMode)
        end
    end

    for levelIndex = 1, nbLevels do
        local levelName <const> = levelsOrder[levelIndex]
        local finished <const> = table.contains(finishedLevels, levelName)

        if not finished then
            local row <const> = math.ceil(levelIndex / 10)
            local column <const> = levelIndex % 10

            self.gridview:setSelection(1, row, column)

            break
        end
    end
end

function LevelSelectorScene:update()
    if playdate.buttonJustPressed(playdate.kButtonUp) then
        self.gridview:selectPreviousRow(true)
    elseif playdate.buttonJustPressed(playdate.kButtonDown) then
        self.gridview:selectNextRow(true)
    elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
        self.gridview:selectPreviousColumn(true)
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        self.gridview:selectNextColumn(true)
    end

    local crankTicks <const> = playdate.getCrankTicks(2)

    if crankTicks == 1 then
        self.gridview:selectNextColumn(true)
    elseif crankTicks == -1 then
        self.gridview:selectPreviousColumn(true)
    end

    if self.gridview.needsDisplay then
        local gridviewImage <const> = gfx.image.new(playdate.display.getWidth(), playdate.display.getHeight())
        gfx.pushContext(gridviewImage)
        self.gridview:drawInRect(0, 0, playdate.display.getWidth(), playdate.display.getHeight())
        gfx.popContext()
        self.gridviewSprite:setImage(gridviewImage)
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        local section <const>, row <const>, column <const> = self.gridview:getSelection()
        local levelIndex <const> = tonumber((row - 1) * 10) + tonumber(column)

        local levelName <const> = levelsOrder[levelIndex]
        loadLevel(levelName)
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end

    gfx.sprite.update()
    playdate.timer.updateTimers()
end

function LevelSelectorScene:destroy()
    menu:removeMenuItem(self.menuHome)

    self.gridviewSprite:remove()
end
