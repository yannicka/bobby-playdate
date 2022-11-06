local gfx <const> = playdate.graphics
local menu <const> = playdate.getSystemMenu()

class('CreditsScene').extends(Scene)

local text <const> = [[
*Credits*

Yannick A. "Pif": idea, code, graphics.

_Acknowledgements_

- Thanks to Aur36 for his help on the levels, his numerous tests and feedback and his unlimited enthusiasm.
- Thanks to orakle - Ethan G. for his graphic assistance.
- Thanks to Alceste__ for his code and global improvements.
- Thanks to Polyson for his proposal of open-ended levels and his various advices and feedback.

Thanks to the members of the development group of which I am a part for their support in the development of the project, and for their various feedback.

_Source code_

Source code under the AGPLv3+ free license.
> gitlab.com/yannicka/bobby-playdate
]]

function CreditsScene:init()
    CreditsScene.super.init(self)

    self.menuHome, error = menu:addMenuItem('go home', function()
        changeScene(HomeScene)
    end)

    gfx.setDrawOffset(0, 0)

    self.offset = 0

    self.gridviewSprite = gfx.sprite.new()
    self.gridviewSprite:setCenter(0, 0)
    self.gridviewSprite:moveTo(10, 14)
    self.gridviewSprite:add()
end

function CreditsScene:update()
    gfx.setDrawOffset(0, self.offset)

    local gridviewImage <const> = gfx.image.new(playdate.display.getWidth() - 20, 750)
    gfx.pushContext(gridviewImage)
    gfx.drawTextInRect(text, 0, 0, playdate.display.getWidth() - 20, 750, 5)
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

        if self.offset < -430 then
            self.offset = -430
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end

    gfx.sprite.update()
end

function CreditsScene:destroy()
    menu:removeMenuItem(self.menuHome)

    self.gridviewSprite:remove()
end
