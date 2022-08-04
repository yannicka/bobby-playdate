import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'player'

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

local player = Player()

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
end

myGameSetUp()

function playdate.update()
    if player.canMove then
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
    end

    playdate.graphics.sprite.redrawBackground()
    gfx.sprite.update()
    playdate.timer.updateTimers()
end
