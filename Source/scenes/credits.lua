class('CreditsScene').extends(Scene)

local text = [[
*Credits*

Yannick A. "Pif": idea, code, graphics.

_Acknowledgements_

Thanks to Aur36 for his help with the levels, his numerous tests and feedbacks and his unlimited enthusiasm.
Thanks to orakle - Ethan G. for his graphic assistance.
Thanks to Alceste__ for his code improvements and global functioning.
Thanks to Polyson for his proposal of open-ended levels and his various advices and feedbacks.

Thanks to the members of the development group of which I am a part for their support in the development of the project, and for their various feedbacks.

_Source code_

Source code under the AGPLv3+ free license.

https://gitlab.com/yannicka/bobby
]]

function CreditsScene:init()
    CreditsScene.super.init(self)

    playdate.graphics.setDrawOffset(0, 0)

    self.offset = 0

    self.gridviewSprite = playdate.graphics.sprite.new()
    self.gridviewSprite:setCenter(0, 0)
    self.gridviewSprite:moveTo(0, 0)
    self.gridviewSprite:add()
end

function CreditsScene:update()
    playdate.graphics.setDrawOffset(0, self.offset)

    local gridviewImage = playdate.graphics.image.new(playdate.display.getWidth() - 20, 630)
    playdate.graphics.pushContext(gridviewImage)
    playdate.graphics.drawTextInRect(text, 10, 10, playdate.display.getWidth() - 20, 630, 5)
    playdate.graphics.popContext()
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

        if self.offset < -270 then
            self.offset = -270
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end

    playdate.graphics.sprite.update()
    playdate.timer.updateTimers()
end

function CreditsScene:destroy()
    self.gridviewSprite:remove()
end
