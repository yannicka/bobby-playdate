import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

class('Player').extends(playdate.graphics.sprite)

function Player:init(level)
    Player.super.init(self)

    self.level = level

    self.position = {5, 5}
    self.canMove = true
    self.timer = nil
    self.direction = 'down'

    local playerImage = gfx.imagetable.new('img/player')
    assert(playerImage)

    self:setZIndex(800)
    self:setCenter(0, 0)
    self:setImage(playerImage[1])
    self:moveTo(self.position[1] * CELL_SIZE, self.position[2] * CELL_SIZE)
    self:add()
end

function Player:move(direction)
    if not self.canMove then
        return
    end

    local cellBefore = self.level:getCellAt(self.position)

    if cellBefore ~= nil then
        if not cellBefore:canLeave(direction) then
            return
        end
    end

    local nextPosition = {self.position[1], self.position[2]}

    if direction == 'right' then
        nextPosition[1] += 1
    elseif direction == 'left' then
        nextPosition[1] -= 1
    elseif direction == 'up' then
        nextPosition[2] -= 1
    elseif direction == 'down' then
        nextPosition[2] += 1
    end

    local cellAtPosition = self.level:getCellAt(nextPosition)

    if cellAtPosition ~= nil then
        if not cellAtPosition:canEnter(direction) then
            return
        end
    end

    self.direction = direction
    self.canMove = false
    self.timer = playdate.timer.new(150, 0, 150, playdate.easingFunctions.linear)

    self.timer.timerEndedCallback = function()
        self.position = nextPosition
        self.canMove = true

        self:moveTo(nextPosition[1] * CELL_SIZE, nextPosition[2] * CELL_SIZE)

        if cellBefore then
            cellBefore:onAfterPlayerOut()
        end

        if cellAtPosition then
            cellAtPosition:onAfterPlayerIn(self)

            if cellAtPosition:isa(Coin) then
                self.level:setCellAt(self.position, nil)
            end
        end
    end

    if direction == 'right' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE) + (timer.value / 150 * CELL_SIZE),
                self.position[2] * CELL_SIZE
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end
    elseif direction == 'left' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE) - (timer.value / 150 * CELL_SIZE),
                self.position[2] * CELL_SIZE
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end
    elseif direction == 'up' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE),
                self.position[2] * CELL_SIZE - (timer.value / 150 * CELL_SIZE)
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end
    elseif direction == 'down' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE),
                self.position[2] * CELL_SIZE + (timer.value / 150 * CELL_SIZE)
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end
    end
end
