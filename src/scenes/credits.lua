local gfx <const> = playdate.graphics

class('CreditsScene').extends(Scene)

local text = [[
*Credits*

Yannick A. "Pif": idea, code, graphics.

_Acknowledgements_

- Thanks to Aur36 for his help on the levels, his numerous tests and feedbacks and his unlimited enthusiasm.
- Thanks to orakle - Ethan G. for his graphic assistance.
- Thanks to Alceste__ for his code and global improvements.
- Thanks to Polyson for his proposal of open-ended levels and his various advices and feedbacks.

Thanks to the members of the development group of which I am a part for their support in the development of the project, and for their various feedbacks.

_Source code_

Source code under the AGPLv3+ free license.

https://gitlab.com/yannicka/bobby-playdate
]]

function CreditsScene:init()
    CreditsScene.super.init(self)

    gfx.setDrawOffset(0, 0)

    self.offset = 0

    self.gridviewSprite = gfx.sprite.new()
    self.gridviewSprite:setCenter(0, 0)
    self.gridviewSprite:moveTo(0, 0)
    self.gridviewSprite:add()
end

function CreditsScene:update()
    gfx.setDrawOffset(0, self.offset)

    local gridviewImage = gfx.image.new(playdate.display.getWidth() - 20, 620)
    gfx.pushContext(gridviewImage)
    gfx.drawTextInRect(text, 10, 10, playdate.display.getWidth() - 20, 620, 5)
    gfx.popContext()
    self.gridviewSprite:setImage(gridviewImage)

    if playdate.buttonIsPressed(playdate.kButtonUp) then
        self.offset += 10

        if self.offset > 0 then
            self.offset = 0
        end
    end

    if playdate.buttonIsPressed(playdate.kButtonDown) then
        self.offset -= 10

        if self.offset < -260 then
            self.offset = -260
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end

    gfx.sprite.update()
    playdate.timer.updateTimers()
end

function CreditsScene:destroy()
    self.gridviewSprite:remove()
end
