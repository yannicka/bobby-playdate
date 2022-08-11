local gfx <const> = playdate.graphics

class('HelpScene').extends(Scene)

local text = [[
*Instructions*

_Keys_
Move the character with the directional arrows.

_Goal_
Complete all levels.
For each level, collect all the coins and then reach the exit.

_Blocks_
- The rocks block you.
- The conveyor belts take you in a one direction.
- The buttons only allow a certain number of passes.
- The turnstiles block you from certain directions and turn clockwise when you exit.
- The ice makes you slide to the next void or solid block you encounter.
]]

function HelpScene:init()
    HelpScene.super.init(self)

    gfx.setDrawOffset(0, 0)

    self.offset = 0

    self.gridviewSprite = gfx.sprite.new()
    self.gridviewSprite:setCenter(0, 0)
    self.gridviewSprite:moveTo(0, 0)
    self.gridviewSprite:add()
end

function HelpScene:update()
    gfx.setDrawOffset(0, self.offset)

    local gridviewImage = gfx.image.new(playdate.display.getWidth() - 20, 500)
    gfx.pushContext(gridviewImage)
    gfx.drawTextInRect(text, 10, 10, playdate.display.getWidth() - 20, 500, 5)
    gfx.popContext()
    -- gridviewImage:draw(0, self.offset)
    self.gridviewSprite:setImage(gridviewImage)

    if playdate.buttonIsPressed(playdate.kButtonUp) then
        self.offset += 10

        if self.offset > 0 then
            self.offset = 0
        end
    end

    if playdate.buttonIsPressed(playdate.kButtonDown) then
        self.offset -= 10

        if self.offset < -140 then
            self.offset = -140
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end

    gfx.sprite.update()
    playdate.timer.updateTimers()
end

function HelpScene:destroy()
    self.gridviewSprite:remove()
end
