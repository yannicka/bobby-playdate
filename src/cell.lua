local gfx <const> = playdate.graphics

local tilesImage <const> = gfx.imagetable.new('img/tiles')

class('Cell').extends(gfx.sprite)

function Cell:init(position)
    Cell.super.init(self)

    self.position = position
    self.animationManager = AnimationManager(self, tilesImage)

    self.update = function()
        self.animationManager:update()
    end

    self:setZIndex(100)
    self:setCenter(0, 0)
    self:setImage(tilesImage[1])
    self:moveTo(position.x * CELL_SIZE, position.y * CELL_SIZE)
    self:add()
end

-- Évènement : lorsque le joueur est entré dans la case
function Cell:onAfterPlayerIn(player)
    -- À surcharger
end

-- Évènement : lorsque le joueur a quitté la case
function Cell:onAfterPlayerOut()
    -- À surcharger
end

-- Est-ce qu'on peut rentrer sur la case ?
function Cell:canEnter(direction)
    return true
end

-- Est-ce qu'on peut sortir de la case ?
function Cell:canLeave(direction)
    return true
end

-- Rocher
class('Stone').extends(Cell)

function Stone:init(position)
    Stone.super.init(self, position)

    self:setImage(tilesImage[2])
end

function Stone:canEnter()
    return false
end

-- Bouton
class('Button').extends(Cell)

function Button:init(position, value)
    Button.super.init(self, position)

    self.value = value

    self:updateImage()
end

function Button:onAfterPlayerOut()
    self.value -= 1

    self:updateImage()
end

function Button:canEnter(direction)
    return self.value ~= 0
end

function Button:updateImage()
    if self.value == 0 then
        self:setImage(tilesImage[81])
    elseif self.value == 1 then
        self:setImage(tilesImage[82])
    elseif self.value == 2 then
        self:setImage(tilesImage[83])
    elseif self.value == 3 then
        self:setImage(tilesImage[84])
    end
end

-- Tapis roulant
class('Conveyor').extends(Cell)

function Conveyor:init(position, direction)
    Conveyor.super.init(self, position)

    self.direction = direction

    if direction == 'up' then
        self.animationManager:addAnimation('move', {31, 32, 33, 34, 35}, 2)
        self.animationManager:play('move')
    elseif direction == 'down' then
        self.animationManager:addAnimation('move', {51, 52, 53, 54, 55}, 2)
        self.animationManager:play('move')
    elseif direction == 'right' then
        self.animationManager:addAnimation('move', {41, 42, 43, 44, 45}, 2)
        self.animationManager:play('move')
    elseif direction == 'left' then
        self.animationManager:addAnimation('move', {61, 62, 63, 64, 65}, 2)
        self.animationManager:play('move')
    end
end

function Conveyor:onAfterPlayerIn(player)
    player:move(self.direction)
end

-- Tourniquet
class('Turnstile').extends(Cell)

function Turnstile:init(position, angle)
    Conveyor.super.init(self, position)

    self.angle = angle

    self:updateImage()
end

function Turnstile:onAfterPlayerOut()
    if self.angle == 'up-left' then
        self.angle = 'up-right'
    elseif self.angle == 'up-right' then
        self.angle = 'down-right'
    elseif self.angle == 'down-right' then
        self.angle = 'down-left'
    elseif self.angle == 'down-left'then
        self.angle = 'up-left'
    elseif self.angle == 'horizontal' then
        self.angle = 'vertical'
    elseif self.angle == 'vertical' then
        self.angle = 'horizontal'
    elseif self.angle == 'up' then
        self.angle = 'right'
    elseif self.angle == 'right' then
        self.angle = 'down'
    elseif self.angle == 'down' then
        self.angle = 'left'
    elseif self.angle == 'left' then
        self.angle = 'up'
    end

    self:updateImage()
end

function Turnstile:canEnter(direction)
    if self.angle == 'up-left' and (direction == 'up' or direction == 'left') then
        return true
    end

    if self.angle == 'up-right' and (direction == 'up' or direction == 'right') then
        return true
    end

    if self.angle == 'down-right' and (direction == 'down' or direction == 'right') then
        return true
    end

    if self.angle == 'down-left' and (direction == 'down' or direction == 'left') then
        return true
    end

    if self.angle == 'horizontal' and (direction == 'right' or direction == 'left') then
        return true
    end

    if self.angle == 'vertical' and (direction == 'up' or direction == 'down') then
        return true
    end

    if self.angle == 'up' and direction ~= 'down' then
        return true
    end

    if self.angle == 'right' and direction ~= 'left' then
        return true
    end

    if self.angle == 'down' and direction ~= 'up' then
        return true
    end

    if self.angle == 'left' and direction ~= 'right' then
        return true
    end

    return false
end

function Turnstile:canLeave(direction)
    if self.angle == 'up-left' and (direction == 'down' or direction == 'right') then
        return true
    end

    if self.angle == 'up-right' and (direction == 'down' or direction == 'left') then
        return true
    end

    if self.angle == 'down-right' and (direction == 'up' or direction == 'left') then
        return true
    end

    if self.angle == 'down-left' and (direction == 'up' or direction == 'right') then
        return true
    end

    if self.angle == 'horizontal' and (direction == 'right' or direction == 'left') then
        return true
    end

    if self.angle == 'vertical' and (direction == 'up' or direction == 'down') then
        return true
    end

    if self.angle == 'up' and direction ~= 'up' then
        return true
    end

    if self.angle == 'right' and direction ~= 'right' then
        return true
    end

    if self.angle == 'down' and direction ~= 'down' then
        return true
    end

    if self.angle == 'left' and direction ~= 'left' then
        return true
    end

    return false
end

function Turnstile:updateImage()
    if self.angle == 'up-left' then
        self:setImage(tilesImage[71])
    elseif self.angle == 'up-right' then
        self:setImage(tilesImage[72])
    elseif self.angle == 'down-right' then
        self:setImage(tilesImage[73])
    elseif self.angle == 'down-left'then
        self:setImage(tilesImage[74])
    elseif self.angle == 'horizontal' then
        self:setImage(tilesImage[75])
    elseif self.angle == 'vertical' then
        self:setImage(tilesImage[76])
    elseif self.angle == 'up' then
        self:setImage(tilesImage[77])
    elseif self.angle == 'right' then
        self:setImage(tilesImage[78])
    elseif self.angle == 'down' then
        self:setImage(tilesImage[79])
    elseif self.angle == 'left' then
        self:setImage(tilesImage[80])
    end
end

-- Balise de début de niveau
class('Start').extends(Cell)

function Start:init(position)
    Start.super.init(self, position)
end

-- Balise de fin de niveau
class('End').extends(Cell)

function End:init(position)
    End.super.init(self, position)

    self.animationManager:addAnimation('active', {22, 23, 24, 25}, 3)

    self:setImage(tilesImage[21])

    self.active = false
end

function End:onAfterPlayerIn(player)
    if self.active then
        goToNextLevel()
    end
end

function End:activate()
    self.active = true

    self.animationManager:play('active')
end

-- Pièce
class('Coin').extends(Cell)

function Coin:init(position)
    Coin.super.init(self, position)

    local frames <const> = {}
    for _ = 0, math.random(45, 90) do
        table.insert(frames, 11)
    end

    table.insert(frames, 12)
    table.insert(frames, 13)
    table.insert(frames, 12)

    self.animationManager:addAnimation('turn', frames, 3)
    self.animationManager:play('turn')
end

function Coin:onAfterPlayerIn(player)
    self:remove()
end

-- Glace
class('Ice').extends(Cell)

function Ice:init(position)
    Ice.super.init(self, position)

    self:setImage(tilesImage[3])
end

function Ice:onAfterPlayerIn(player)
    player:move(player.direction)
end
