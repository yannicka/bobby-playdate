import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

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

class('Level').extends(Object)

function Level:init()
	Level.super.init(self)

    local grid = parseStringLevel(level)

    local tilesImage = gfx.imagetable.new('img/tiles')
    assert(tilesImage)

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
