local gfx <const> = playdate.graphics
local menu = playdate.getSystemMenu()

class('GameScene').extends(Scene)

local level = nil
local levelIndex = nil
local player = nil
local currentLevelName = nil

function loadLevel(name)
    levelIndex = table.indexof(levelsOrder, name)

    currentLevelName = name

    changeScene(GameScene)

    level = Level(name)
    player = Player(level)

    local startPosition = level:getStartPosition()

    if startPosition then
        player.position = startPosition:copy()
        player:moveTo(player.position.x * CELL_SIZE + 2, player.position.y * CELL_SIZE - 5)
    end
end

function goToNextLevel()
    table.insert(finishedLevels, currentLevelName)

    playdate.datastore.write(finishedLevels)

    local currentLevelIndex = table.indexof(levelsOrder, currentLevelName)
    local nextLevelIndex = next(levelsOrder, currentLevelIndex)

    if nextLevelIndex then
        local nextLevelName = levelsOrder[nextLevelIndex]

        player.canMove = false
        player.animationManager:play('turn')

        local timer = playdate.timer.new(400, 0, 400, playdate.easingFunctions.linear)
        timer.timerEndedCallback = function()
            loadLevel(nextLevelName)
        end
    else
        changeScene(EndGameScene)
    end
end

function GameScene:init()
    GameScene.super.init(self)

    self.background = gfx.sprite.new()
    self.background:moveTo(-playdate.display.getWidth(), -playdate.display.getHeight())
    self.background:setCenter(0, 0)
    self.background:add()

    local backgroundImage = gfx.image.new('img/background')
    local backgroundContext = gfx.image.new(playdate.display.getWidth() * 4, playdate.display.getHeight() * 4)
    gfx.pushContext(backgroundContext)
    backgroundImage:drawTiled(0, 0, playdate.display.getWidth() * 4, playdate.display.getHeight() * 4)
    gfx.popContext()
    self.background:setImage(backgroundContext)

    self.levelCounter = gfx.sprite.new()
    self.levelCounter:setIgnoresDrawOffset(true)
    self.levelCounter:moveTo(2, 2)
    self.levelCounter:setCenter(0, 0)
    self.levelCounter:setZIndex(300)
    self.levelCounter:add()

    local levelCounterContext = gfx.image.new(60, 40)
    gfx.pushContext(levelCounterContext)
    setOutlinedFont()
    gfx.drawText(levelIndex .. '/' .. nbLevels, 0, 0)
    setBaseFont()
    gfx.popContext()
    self.levelCounter:setImage(levelCounterContext)

    self.menuHome, error = menu:addMenuItem('go menu', function()
        changeScene(LevelSelectorScene)
    end)

    self.menuRestart, error = menu:addMenuItem('restart level', function()
        loadLevel(currentLevelName)
    end)
end

function GameScene:update()
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        player:move('up')
    end

    if playdate.buttonIsPressed(playdate.kButtonRight) then
        player:move('right')
    end

    if playdate.buttonIsPressed(playdate.kButtonDown) then
        player:move('down')
    end

    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        player:move('left')
    end

    level:update()

    gfx.sprite.redrawBackground()
    gfx.sprite.update()
    playdate.timer.updateTimers()
    self:updateCamera()
end

function GameScene:updateCamera()
    local xOffset = -player.x + (playdate.display.getWidth() / 2)
    local yOffset = -player.y + (playdate.display.getHeight() / 2)

    xOffset = math.clamp(xOffset, -level.width * CELL_SIZE + playdate.display.getWidth() - CELL_SIZE, -CELL_SIZE)
    yOffset = math.clamp(yOffset, -level.height * CELL_SIZE + playdate.display.getHeight() - CELL_SIZE, -CELL_SIZE)

    if level.width * CELL_SIZE < playdate.display.getWidth() then
        xOffset = (playdate.display.getWidth() / 2) - ((level.width * CELL_SIZE) / 2) - CELL_SIZE
    end

    if level.height * CELL_SIZE < playdate.display.getHeight() then
        yOffset = (playdate.display.getHeight() / 2) - ((level.height * CELL_SIZE) / 2) - CELL_SIZE
    end

    gfx.setDrawOffset(xOffset, yOffset)
end

function GameScene:destroy()
    menu:removeMenuItem(self.menuHome)
    menu:removeMenuItem(self.menuRestart)

    self.background:remove()
    self.levelCounter:remove()
    level:remove()
    player:remove()
end
