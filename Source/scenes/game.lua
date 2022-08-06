class('GameScene').extends(Scene)

local menu = playdate.getSystemMenu()

local level = nil
local player = nil
local currentLevelName = nil
local backgroundImage = playdate.graphics.image.new('img/background')

function loadLevel(name)
    changeScene(GameScene)

    if level then
        level:remove()
    end

    if player then
        player:remove()
    end

    currentLevelName = name

    level = Level(name)
    player = Player(level)

    local startPosition = level:getStartPosition()

    if startPosition then
        player.position = startPosition:copy()
        player:moveTo(player.position.x * CELL_SIZE, player.position.y * CELL_SIZE)
    end
end

function goToNextLevel()
    table.insert(finishedLevels, currentLevelName)

    playdate.datastore.write(finishedLevels)

    local currentLevelIndex = table.indexOf(levelsOrder, currentLevelName)
    local nextLevelIndex = next(levelsOrder, currentLevelIndex)

    if nextLevelIndex then
        local nextLevelName = levelsOrder[nextLevelIndex]

        player.canMove = false
        player.animationManager:play('turn')

        local timer = playdate.timer.new(300, 0, 300, playdate.easingFunctions.linear)
        timer.timerEndedCallback = function()
            loadLevel(nextLevelName)
        end
    else
        changeScene(EndGameScene)
    end
end

function GameScene:init()
    GameScene.super.init(self)

    self.background = playdate.graphics.sprite.new()
    self.background:moveTo(-playdate.display.getWidth(), -playdate.display.getHeight())
    self.background:setCenter(0, 0)
    self.background:add()

    local backgroundContext = playdate.graphics.image.new(playdate.display.getWidth() * 4, playdate.display.getHeight() * 4)
    playdate.graphics.pushContext(backgroundContext)
    backgroundImage:drawTiled(0, 0, playdate.display.getWidth() * 4, playdate.display.getHeight() * 4)
    playdate.graphics.popContext()
    self.background:setImage(backgroundContext)

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

    playdate.graphics.sprite.redrawBackground()
    playdate.graphics.sprite.update()
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

    playdate.graphics.setDrawOffset(xOffset, yOffset)
end

function GameScene:destroy()
    menu:removeMenuItem(self.menuHome)
    menu:removeMenuItem(self.menuRestart)

    self.background:remove()
    level:remove()
    player:remove()
end
