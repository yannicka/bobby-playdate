import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

class('Player').extends(playdate.graphics.sprite)

function Player:init()
    Player.super.init(self)

    self.position = {4, 4}
    self.canMove = true
    self.timer = playdate.timer.new(0)

    local playerImage = gfx.imagetable.new('img/player')
    assert(playerImage)

    self:setZIndex(800)
    self:setCenter(0, 0)
    self:setImage(playerImage[1])
    self:moveTo(self.position[1] * CELL_SIZE, self.position[2] * CELL_SIZE)
    self:add()
end

function Player:move(dir)
    self.canMove = false
    self.timer = playdate.timer.new(150, 0, 150, playdate.easingFunctions.linear)

    if dir == 'right' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE) + (timer.value / 150 * CELL_SIZE),
                self.position[2] * CELL_SIZE
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end

        self.timer.timerEndedCallback = function()
            self.position[1] += 1
            self.canMove = true
        end
    elseif dir == 'left' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE) - (timer.value / 150 * CELL_SIZE),
                self.position[2] * CELL_SIZE
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end

        self.timer.timerEndedCallback = function()
            self.position[1] -= 1
            self.canMove = true
        end
    elseif dir == 'up' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE),
                self.position[2] * CELL_SIZE - (timer.value / 150 * CELL_SIZE)
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end

        self.timer.timerEndedCallback = function()
            self.position[2] -= 1
            self.canMove = true
        end
    elseif dir == 'down' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition = {
                (self.position[1] * CELL_SIZE),
                self.position[2] * CELL_SIZE + (timer.value / 150 * CELL_SIZE)
            }

            self:moveTo(realPlayerPosition[1], realPlayerPosition[2])
        end

        self.timer.timerEndedCallback = function()
            self.position[2] += 1
            self.canMove = true
        end
    end
end
