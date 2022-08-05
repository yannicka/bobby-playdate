import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'player'
import 'level'
import 'cell'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

local playerSprite = nil

local level = Level()
local player = Player(level)

function myGameSetUp()
    local backgroundImage = gfx.image.new('img/background')
    assert(backgroundImage)

    gfx.sprite.setBackgroundDrawingCallback(function(x, y, width, height)
        backgroundImage:drawTiled(x, y, width, height)
    end)

    local levelWidth = 20
    local levelHeight = 12
    local xOffset = (playdate.display.getWidth() / 2) - ((levelWidth * CELL_SIZE) / 2) - CELL_SIZE
    local yOffset = (playdate.display.getHeight() / 2) - ((levelHeight * CELL_SIZE) / 2) - CELL_SIZE

    playdate.graphics.setDrawOffset(xOffset, yOffset)
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

    playdate.graphics.sprite.redrawBackground()
    gfx.sprite.update()
    playdate.timer.updateTimers()
end
