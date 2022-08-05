import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'cell'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

local level = [[
    # # # # # # # # . # # # # # # # # # # #
    # # # . E . # # . . . . . . . . . . . #
    # # . . . . . # . F . T . . . . 8 . . #
    # $ . . . . . $ . . . . . . . 4 . 6 . #
    # $ . . . . . $ . L . J . . . . 2 . . #
    . $ . . . . . $ . . . . . B3 . . . . . ..
    # # . . S . . . . . . . . . . . . . . #
    # # # . . . . . . . = . H . . > . v . #
    # # # . . . . . . . . . . . . ^ . v . #
    # # # . . . # # . ! ! ! . . . ^ < < . #
    # # # . . . # # . ! ! . . B2 . . . . . #
    # # # # # # # # . # # # # # # # # # # #
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
    self.width = 0
    self.height = 0
    self.nbCoins = 0

    for y,v in ipairs(grid) do
        self.grid[y] = {}
        self.height += 1

        for x,v2 in ipairs(v) do
            local cell = 0

            if v2 ~= '.' then
                if v2 == '#' then
                    cell = Stone({x, y})
                elseif v2 == 'S' then
                    cell = Start({x, y})
                elseif v2 == 'E' then
                    cell = End({x, y})
                elseif v2 == '$' then
                    cell = Coin({x, y})

                    self.nbCoins += 1
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
                elseif v2 == 'B' then
                    cell = Button({x, y}, 1)
                elseif v2 == 'B2' then
                    cell = Button({x, y}, 2)
                elseif v2 == 'B3' then
                    cell = Button({x, y}, 3)
                elseif v2 == '!' then
                    cell = Ice({x, y})
                end
            end

            self.grid[y][x] = cell

            if self.height == 1 then
                self.width += 1
            end
        end
    end

    self.endCell = self:getEndCell()
end

function Level:update()
    if self.nbCoins == 0 then
        self.endCell:activate()
    end
end

function Level:getCellAt(position)
    local row = self.grid[position[2]]

    if row then
        if row[position[1]] ~= 0 then
            return row[position[1]]
        end
    end

    return nil
end

function Level:setCellAt(position, newCell)
    local row = self.grid[position[2]]

    if row then
        row[position[1]] = newCell
    end
end

function Level:getStartPosition()
    for y,row in ipairs(self.grid) do
        for x,cell in ipairs(row) do
            if cell ~= 0 and cell:isa(Start) then
                return {x, y}
            end
        end
    end
end

function Level:getEndCell()
    for y,row in ipairs(self.grid) do
        for x,cell in ipairs(row) do
            if cell ~= 0 and cell:isa(End) then
                return cell
            end
        end
    end
end
