import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'cell'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

local level = [[
    # # # # # # # # # # # # # # # # # # # #
    # # # . E . # # . . . . . . . . . . . #
    # # . . . . . # . F . T . . . . 8 . . #
    # $ . . . . . $ . . . . . . . 4 . 6 . #
    # $ . . . . . $ . L . J . . . . 2 . . #
    # $ . . . . . $ . . . . . . . . . . . #
    # # . . S . . . . . . . . . . . . . . #
    # # # . . . . . . . = . H . . . > v . #
    # # # . . . . . . . . . . . . . ^ < . #
    # # # . . . # # . . . . . . . . . . . #
    # # # . . . # # . . . . . . . . . . . #
    # # # # # # # # # # # # # # # # # # # #
]]

local level2 = [[
    # # # # # # # # #
    # # # . E . # # #
    # # . . . . . # #
    # $ . . B > v $ #
    # $ . . . ^ < $ #
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
                    cell = Button({x, y}, 1)
                elseif v2 == '^' then
                    cell = Conveyor({x, y}, 'up')
                elseif v2 == 'v' then
                    cell = Conveyor({x, y}, 'down')
                elseif v2 == '<' then
                    cell = Conveyor({x, y}, 'left')
                elseif v2 == '>' then
                    cell = Conveyor({x, y}, 'right')
                elseif v2 == 'T' then
                    cell = Turnstile({x, y}, 'up-right')
                elseif v2 == 'F' then
                    cell = Turnstile({x, y}, 'up-left')
                elseif v2 == 'J' then
                    cell = Turnstile({x, y}, 'down-right')
                elseif v2 == 'L' then
                    cell = Turnstile({x, y}, 'down-left')
                elseif v2 == '=' then
                    cell = Turnstile({x, y}, 'horizontal')
                elseif v2 == 'H' then
                    cell = Turnstile({x, y}, 'vertical')
                elseif v2 == '8' then
                    cell = Turnstile({x, y}, 'up')
                elseif v2 == '6' then
                    cell = Turnstile({x, y}, 'right')
                elseif v2 == '2' then
                    cell = Turnstile({x, y}, 'down')
                elseif v2 == '4' then
                    cell = Turnstile({x, y}, 'left')
                end
            end

            self.grid[y][x] = cell
        end
    end
end
