import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'cell'

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
    # $ . . B . . $ #
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

    self.grid = {}

    for y,v in ipairs(grid) do
        self.grid[y] = {}

        for x,v2 in ipairs(v) do
            local cell = nil

            if v2 ~= '.' then
                if v2 == '#' then
                    cell = Stone({x, y})
                elseif v2 == '$' then
                    cell = Coin({x, y})
                elseif v2 == 'B' then
                    cell = Button({x, y})
                end
            end

            self.grid[y][x] = cell
        end
    end
end
