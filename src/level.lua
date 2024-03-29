local function splitLines(str)
    local result <const> = {}

    for line in str:gmatch('[^\n]+') do
        table.insert(result, line)
    end

    return result
end

local function parseStringLevel(level)
    -- Retire les espaces au début de chaque ligne
    local levelWithoutSpace = level:gsub('/^ +/gm', '')

    -- Remplace les espaces consécutives par une seule espace
    levelWithoutSpace = levelWithoutSpace:gsub('/ +/g', ' ')

    -- Coupe à chaque ligne
    local lines <const> = splitLines(levelWithoutSpace)

    -- Retire les lignes vides
    local finalLines <const> = {}

    for _, line in ipairs(lines) do
        if playdate.string.trimWhitespace(line) ~= '' then
            table.insert(finalLines, line)
        end
    end

    -- Construit la grille du niveau
    local grid <const> = {}

    for _, line in ipairs(finalLines) do
        local row <const> = {}

        for value in line:gmatch('%S+') do
            table.insert(row, value)
        end

        table.insert(grid, row)
    end

    return grid
end

local function computeCell(value, position)
    local cell = 0

    if value ~= '.' then
        if value == '#' then
            cell = Stone(position)
        elseif value == 'S' then
            cell = Start(position)
        elseif value == 'E' then
            cell = End(position)
        elseif value == '$' then
            cell = Coin(position)
        elseif value == '^' then
            cell = Conveyor(position, 'up')
        elseif value == 'v' then
            cell = Conveyor(position, 'down')
        elseif value == '<' then
            cell = Conveyor(position, 'left')
        elseif value == '>' then
            cell = Conveyor(position, 'right')
        elseif value == 'T' then
            cell = Turnstile(position, 'up-right')
        elseif value == 'F' then
            cell = Turnstile(position, 'up-left')
        elseif value == 'J' then
            cell = Turnstile(position, 'down-right')
        elseif value == 'L' then
            cell = Turnstile(position, 'down-left')
        elseif value == '=' then
            cell = Turnstile(position, 'horizontal')
        elseif value == 'H' then
            cell = Turnstile(position, 'vertical')
        elseif value == '8' then
            cell = Turnstile(position, 'up')
        elseif value == '6' then
            cell = Turnstile(position, 'right')
        elseif value == '2' then
            cell = Turnstile(position, 'down')
        elseif value == '4' then
            cell = Turnstile(position, 'left')
        elseif value == 'B' then
            cell = Button(position, 1)
        elseif value == 'B2' then
            cell = Button(position, 2)
        elseif value == 'B3' then
            cell = Button(position, 3)
        elseif value == '!' then
            cell = Ice(position)
        end
    end

    return cell
end

class('Level').extends(Object)

function Level:init(name)
    Level.super.init(self)

    local level <const> = levels[name]
    local grid <const> = parseStringLevel(level)

    self.grid = {}
    self.width = 0
    self.height = 0
    self.nbCoins = 0

    for y, row in ipairs(grid) do
        self.grid[y] = {}
        self.height += 1

        for x, value in ipairs(row) do
            local position <const> = playdate.geometry.point.new(x, y)
            local cell <const> = computeCell(value, position)

            if cell ~= 0 and cell:isa(Coin) then
                self.nbCoins += 1
            end

            self.grid[y][x] = cell

            if self.height == 1 then
                self.width += 1
            end
        end
    end

    self.endCell = self:getEndCell()
end

function Level:remove()
    for y, row in ipairs(self.grid) do
        for x, cell in ipairs(row) do
            if cell ~= 0 then
                cell:remove()
            end
        end
    end
end

function Level:update()
    if self.nbCoins == 0 then
        self.endCell:activate()
    end
end

function Level:getCellAt(position)
    local row <const> = self.grid[position.y]

    if row then
        if row[position.x] ~= 0 then
            return row[position.x]
        end
    end

    return nil
end

function Level:setCellAt(position, newCell)
    self.grid[position.y][position.x] = newCell
end

function Level:getStartPosition()
    for y, row in ipairs(self.grid) do
        for x, cell in ipairs(row) do
            if cell ~= 0 and cell:isa(Start) then
                return playdate.geometry.point.new(x, y)
            end
        end
    end
end

function Level:getEndCell()
    for y, row in ipairs(self.grid) do
        for x, cell in ipairs(row) do
            if cell ~= 0 and cell:isa(End) then
                return cell
            end
        end
    end
end
