local gfx <const> = playdate.graphics

class('Player').extends(gfx.sprite)

function Player:init(level)
    Player.super.init(self)

    self.level = level

    self.position = playdate.geometry.point.new(1, 1)
    self.canMove = true
    self.timer = nil
    self.direction = 'down'

    local playerImage <const> = gfx.imagetable.new('img/player')

    self:setZIndex(300)
    self:setCenter(0, 0)
    self:setImage(playerImage[1])
    self:moveTo(0, 0)
    self:add()

    self.animationManager = AnimationManager(self, playerImage)

    self.update = function()
        self.animationManager:update()
    end

    self.animationManager:addAnimation('idle-up', {4}, 2, false)
    self.animationManager:addAnimation('idle-down', {10}, 2, false)
    self.animationManager:addAnimation('idle-right', {7}, 2, false)
    self.animationManager:addAnimation('idle-left', {1}, 2, false)

    self.animationManager:addAnimation('walk-up', {4, 5, 6, 4}, 2, false)
    self.animationManager:addAnimation('walk-down', {10, 11, 12, 10}, 2, false)
    self.animationManager:addAnimation('walk-right', {7, 8, 7}, 2, false)
    self.animationManager:addAnimation('walk-left', {1, 2, 1}, 2, false)

    self.animationManager:addAnimation('turn', {10, 1, 4, 7}, 2)

    self.animationManager:play('turn')

    local timer <const> = playdate.timer.new(400, 0, 400, playdate.easingFunctions.linear)
    timer.timerEndedCallback = function()
        self.animationManager:play('idle-' .. self.direction, true)
    end
end

function Player:move(direction, animate)
    if not self.canMove then
        return
    end

    if animate then
        self.animationManager:play('walk-' .. direction, true)
    else
        self.animationManager:play('idle-' .. direction, true)
    end

    self.direction = direction

    local cellBefore <const> = self.level:getCellAt(self.position)

    if cellBefore ~= nil then
        if not cellBefore:canLeave(direction) then
            return
        end
    end

    local nextPosition = self.position:copy()

    if direction == 'right' then
        nextPosition.x += 1
    elseif direction == 'left' then
        nextPosition.x -= 1
    elseif direction == 'up' then
        nextPosition.y -= 1
    elseif direction == 'down' then
        nextPosition.y += 1
    end

    local realNextPosition = nextPosition:copy()

    if realNextPosition.x > self.level.width then
        realNextPosition.x = 1
    elseif realNextPosition.x < 1 then
        realNextPosition.x = self.level.width
    end

    if realNextPosition.y > self.level.height then
        realNextPosition.y = 1
    elseif realNextPosition.y < 1 then
        realNextPosition.y = self.level.height
    end

    local cellAtPosition <const> = self.level:getCellAt(realNextPosition)

    if cellAtPosition ~= nil then
        if not cellAtPosition:canEnter(direction) then
            return
        end
    end

    self.canMove = false
    self.timer = playdate.timer.new(150, 0, 150, playdate.easingFunctions.linear)

    self.timer.timerEndedCallback = function()
        self.position = nextPosition
        self.canMove = true

        self:moveTo(nextPosition.x * CELL_SIZE + 2, nextPosition.y * CELL_SIZE - 5)

        if cellBefore then
            cellBefore:onAfterPlayerOut()
        end

        if cellAtPosition then
            cellAtPosition:onAfterPlayerIn(self)

            if cellAtPosition:isa(Coin) then
                self.level:setCellAt(self.position, 0)
                self.level.nbCoins -= 1
            end
        end

        if self.position.x > self.level.width then
            self.position.x = 0
            self:move('right', true)
        elseif self.position.x < 1 then
            self.position.x = self.level.width + 1
            self:move('left', true)
        end

        if self.position.y > self.level.height then
            self.position.y = 0
            self:move('down', true)
        elseif self.position.y < 1 then
            self.position.y = self.level.height + 1
            self:move('up', true)
        end
    end

    if direction == 'right' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition <const> = playdate.geometry.point.new(
                (self.position.x * CELL_SIZE) + (timer.value / 150 * CELL_SIZE) + 2,
                self.position.y * CELL_SIZE - 5
            )

            self:moveTo(realPlayerPosition.x, realPlayerPosition.y)
        end
    elseif direction == 'left' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition <const> = playdate.geometry.point.new(
                (self.position.x * CELL_SIZE) - (timer.value / 150 * CELL_SIZE) + 2,
                self.position.y * CELL_SIZE - 5
            )

            self:moveTo(realPlayerPosition.x, realPlayerPosition.y)
        end
    elseif direction == 'up' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition <const> = playdate.geometry.point.new(
                (self.position.x * CELL_SIZE) + 2,
                self.position.y * CELL_SIZE - (timer.value / 150 * CELL_SIZE) - 5
            )

            self:moveTo(realPlayerPosition.x, realPlayerPosition.y)
        end
    elseif direction == 'down' then
        self.timer.updateCallback = function(timer)
            local realPlayerPosition <const> = playdate.geometry.point.new(
                (self.position.x * CELL_SIZE) + 2,
                self.position.y * CELL_SIZE + (timer.value / 150 * CELL_SIZE) - 5
            )

            self:moveTo(realPlayerPosition.x, realPlayerPosition.y)
        end
    end
end
