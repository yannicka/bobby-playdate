import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/graphics'
import 'CoreLibs/ui'
import 'CoreLibs/crank'
import 'utils'
import 'player'
import 'level'
import 'cell'
import 'button'
import 'levels'
import 'scenes/scene'
import 'scenes/credits'
import 'scenes/endgame'
import 'scenes/game'
import 'scenes/help'
import 'scenes/home'
import 'scenes/levelselector'
import 'scenes/options'

local font = playdate.graphics.font.new('img/fonts/whiteglove-stroked')
playdate.graphics.setFont(font)

local playerSprite = nil

level = nil
player = nil

local currentLevelName = nil

finishedLevels = playdate.datastore.read()

if finishedLevels == nil then
    finishedLevels = {}
end

local scene = LevelSelectorScene()

function changeScene(newScene)
    scene:destroy()
    scene = newScene()
end

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

    a = indexOf(levelsOrder, currentLevelName)
    b = next(levelsOrder, a)
    c = levelsOrder[b]

    loadLevel(c)
end

function updateCamera()
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

function playdate.update()
    playdate.graphics.setColor(playdate.graphics.kColorWhite)
    playdate.graphics.fillRect(0, 0, playdate.display.getWidth(), playdate.display.getHeight())

    scene:update()
end
