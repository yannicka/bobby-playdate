class('HelpScene').extends(Scene)

local text = [[
*Instructions*

_Keys_
Move the character with the directional arrows

_Goal_
Complete all levels
For each level, collect all the coins and then reach the exit.

_Blocks_
The rocks block you
The treadmills take you in a given direction.
Buttons only allow you a limited number of passages.
Turnstiles block you in certain directions and turn clockwise when you exit.
Ice slides you to the next void or solid block you encounter.
]]

function HelpScene:init()
    HelpScene.super.init(self)

    playdate.display.setOffset(0, 0)

    self.offset = 0
end

function HelpScene:update()
    local gridviewImage = playdate.graphics.image.new(playdate.display.getWidth() - 20, 500)
    playdate.graphics.pushContext(gridviewImage)
    playdate.graphics.drawTextInRect(text, 10, 10, playdate.display.getWidth() - 20, 500, 5)
    playdate.graphics.popContext()
    gridviewImage:draw(0, self.offset)

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

    playdate.graphics.sprite.update()
    playdate.timer.updateTimers()
end

function HelpScene:destroy()
end
