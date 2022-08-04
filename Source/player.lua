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

    local playerImage = gfx.imagetable.new('img/player')
    assert(playerImage)

    self:setZIndex(800)
    self:setCenter(0, 0)
    self:setImage(playerImage[1])
    self:moveTo(self.position[1] * CELL_SIZE, self.position[2] * CELL_SIZE)
    self:add()
end

function Player:move(dir)
    if not self.canMove then
        return
    end

    local nextPosition = {self.position[1], self.position[2]}

    if dir == 'right' then
        nextPosition[1] += 1
    elseif dir == 'left' then
        nextPosition[1] -= 1
    elseif dir == 'up' then
        nextPosition[2] -= 1
    elseif dir == 'down' then
        nextPosition[2] += 1
    end

    local cellBefore = self.level.grid[self.position[2]][self.position[1]]
    local cellAtPosition = self.level.grid[nextPosition[2]][nextPosition[1]]

    if cellAtPosition ~= nil then
        if not cellAtPosition:canEnter(player) then
            return
        end
    end

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
                self.level.grid[self.position[2]][self.position[1]] = nil
            end
        end
    end

    if dir == 'right' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE) + (timer.value / 150 * CELL_SIZE),
                self.position[2] * CELL_SIZE
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end
    elseif dir == 'left' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE) - (timer.value / 150 * CELL_SIZE),
                self.position[2] * CELL_SIZE
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end
    elseif dir == 'up' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE),
                self.position[2] * CELL_SIZE - (timer.value / 150 * CELL_SIZE)
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end
    elseif dir == 'down' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE),
                self.position[2] * CELL_SIZE + (timer.value / 150 * CELL_SIZE)
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end
    end
end
