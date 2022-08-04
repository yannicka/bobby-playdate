import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

local playerSprite = nil

local level = [[
    # # # # # # # # # # # # # # # # # # # #
    # # # . E . # # . . . . . . . . . . . #
    # # . . . . . # . . . . . . . . . . . #
    # $ . . . . . $ . . . . . . . . . . . #
    # $ . . . . . $ . . . . . . . . . . . #
    # $ . . . . . $ . . . . . . . . . . . #
    # # . . S . . # . . . . . . . . . . . #
    # # # . . . # # . . . . . . . . . . . #
    # # # . . . # # . . . . . . . . . . . #
    # # # . . . # # . . . . . . . . . . . #
    # # # . . . # # . . . . . . . . . . . #
    # # # # # # # # # # # # # # # # # # # #
]]

local level = [[
    # # # # # # # # #
    # # # . E . # # #
    # # . . . . . # #
    # $ . . . . . $ #
    # $ . . . . . $ #
    # $ . . . . . $ #
    # # . . S . . # #
    # # # . . . # # #
    # # # # # # # # #
]]

local function splitLines(str)
    local result = {}

    for line in str:gmatch('[^\n]+') do
        table.insert(result, line)
    end

    return result
end

local currentPlayerPosition = {0, 0}
local nextPlayerPosition = {0, 0}
local playerCanMove = true
local playerTimer = playdate.timer.new(0)

function parseStringLevel(level)
    -- Retire les espaces au début de chaque ligne
    local levelWithoutSpace = level:gsub('/^ +/gm', '')
  
    -- Remplace les espaces consécutives par une seule espace
    levelWithoutSpace = levelWithoutSpace:gsub('/ +/g', ' ')
  
    -- Coupe à chaque ligne
    local lines = splitLines(levelWithoutSpace)
  
    -- Retire les lignes vides
    -- lines = lines.filter((el: string) => el.length > 0)
  
    local map = {}

    for i,line in ipairs(lines) do
        local t = {}
        for w in line:gmatch('%S+') do
            table.insert(t, w)
        end

        table.insert(map, t)
    end

    return map
end

function myGameSetUp()
    currentPlayerPosition = nextPlayerPosition

    local grid = parseStringLevel(level)

    -- playdate.display.setScale(2)

    local tilesImage = gfx.imagetable.new('img/tiles')
    assert(tilesImage)

    local backgroundImage = gfx.image.new('img/background')
    assert(backgroundImage)

    gfx.sprite.setBackgroundDrawingCallback(function(x, y, width, height)
        backgroundImage:drawTiled(x, y, width, height)
    end)

    local levelWidth = 9
    local levelHeight = 9
    local xOffset = (playdate.display.getWidth() / 2) - ((levelWidth * CELL_SIZE) / 2)
    local yOffset = (playdate.display.getHeight() / 2) - ((levelHeight * CELL_SIZE) / 2)

    playdate.graphics.setDrawOffset(xOffset, yOffset)

    for y,v in ipairs(grid) do
        for x,v2 in ipairs(v) do
            print(v2)
            if v2 ~= '.' then
                local tile = gfx.sprite.new()
                tile:setCenter(0, 0)
                if v2 == '#' then
                    tile:setImage(tilesImage[1])
                end
                if v2 == '$' then
                    tile:setImage(tilesImage[11])
                end
                tile:moveTo((x-1)*CELL_SIZE, (y-1)*CELL_SIZE) 
                tile:add()
            end
        end
    end

    local playerImage = gfx.imagetable.new('img/player')
    assert(playerImage)

    playdate.graphics.setDrawOffset(xOffset, yOffset)

    playerSprite = gfx.sprite.new()
    playerSprite:setCenter(0, 0)
    playerSprite:setImage(playerImage[1])
    playerSprite:moveTo(currentPlayerPosition[1]*CELL_SIZE, currentPlayerPosition[2]*CELL_SIZE)
    playerSprite:add()
end

myGameSetUp()

function playdate.update()
    if playerCanMove then
        if playdate.buttonIsPressed(playdate.kButtonUp) then
            -- playerSprite:moveBy(0, -2)
        end

        if playdate.buttonIsPressed(playdate.kButtonRight) then
            playerCanMove = false
            playerTimer = playdate.timer.new(200, 0, 200, playdate.easingFunctions.linear)

            playerTimer.updateCallback = function(timer)
                local realPlayerPosition = {
                    (currentPlayerPosition[1]*CELL_SIZE) + ((timer.value)/200*CELL_SIZE),
                    currentPlayerPosition[2]*CELL_SIZE
                }

                playerSprite:moveTo(realPlayerPosition[1], realPlayerPosition[2])
            end

            playerTimer.timerEndedCallback = function()
                currentPlayerPosition[1] += 1
                playerCanMove = true
            end
        end

        if playdate.buttonIsPressed(playdate.kButtonDown) then
            -- playerSprite:moveBy(0, 2)
        end

        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            -- playerSprite:moveBy(-2, 0)
        end
    end

    -- local realPlayerPosition = {currentPlayerPosition[1]*CELL_SIZE, currentPlayerPosition[2]*CELL_SIZE}

    -- playerSprite:moveTo(realPlayerPosition[1], realPlayerPosition[2])

    playdate.graphics.sprite.redrawBackground()
    gfx.sprite.update()
    playdate.timer.updateTimers()
end
