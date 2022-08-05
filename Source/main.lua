import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'player'
import 'level'
import 'cell'

function math.clamp(x, min, max)
    return math.max(math.min(x, max), min)
end

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

local playerSprite = nil

local level = Level()
local player = Player(level)

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

function myGameSetUp()
    local startPosition = level:getStartPosition()

    if startPosition then
        player.position = {startPosition[1], startPosition[2]}
        player:moveTo(player.position[1] * CELL_SIZE, player.position[2] * CELL_SIZE)
    end

    local backgroundImage = gfx.image.new('img/background')
    assert(backgroundImage)

    gfx.sprite.setBackgroundDrawingCallback(function(x, y, width, height)
        backgroundImage:drawTiled(x, y, width, height)
    end)

    updateCamera()
end

myGameSetUp()

function playdate.update()
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
    gfx.sprite.update()
    playdate.timer.updateTimers()
    updateCamera()
end
