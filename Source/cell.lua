import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

local tilesImage = gfx.imagetable.new('img/tiles')
assert(tilesImage)

class('Cell').extends(playdate.graphics.sprite)

function Cell:init(position)
    Cell.super.init(self)

    self.position = position

    self:setCenter(0, 0)
    self:setImage(tilesImage[1])
    self:setZIndex(700)
    self:moveTo((position[1]-1) * CELL_SIZE, (position[2]-1) * CELL_SIZE)
    self:add()
end

function Cell:update(dt)
    -- self.animationManager.update(dt)
end

function Cell:render(ctx)
    ctx.save()
    ctx.translate(self.position.x * CELL_SIZE, self.position.y * CELL_SIZE)

    self.animationManager.render(ctx)

    ctx.restore()
end

-- Évènement : avant que le joueur n'entre dans la case
function Cell:onBeforePlayerIn(_player)
    -- À surcharger
end

-- Évènement : lorsque le joueur est entièrement dans la case
--
-- @return `this` si la case est inchangée ou `null` pour la supprimer
function Cell:onAfterPlayerIn(_player, _game)
    return this
end

-- Évènement : lorsque le joueur a quitté la case
function Cell:onAfterPlayerOut()
    -- À surcharger
end

-- Est-ce qu'on peut rentrer sur la case ?
function Cell:canEnter(_direction)
    return false
end

-- Est-ce qu'on peut sortir de la case ?
function Cell:canLeave(_direction)
    return false
end

function Cell:getPosition()
    return self.position
end

function Cell:getAnimationManager()
    return self.animationManager
end

class('Coin').extends(Cell)

function Coin:init(position)
    Coin.super.init(self, position)

    self:setImage(tilesImage[11])
end
