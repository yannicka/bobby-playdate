import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

class('Player').extends(playdate.graphics.sprite)

function Player:init()
	Player.super.init(self)

    self.position = {0, 0}
    self.canMove = true
    self.timer = playdate.timer.new(0)

    local playerImage = gfx.imagetable.new('img/player')
    assert(playerImage)

    self:setCenter(0, 0)
    self:setImage(playerImage[1])
    self:moveTo(self.position[1] * CELL_SIZE, self.position[2] * CELL_SIZE)
    self:add()
end
