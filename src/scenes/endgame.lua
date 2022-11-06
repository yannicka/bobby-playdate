local gfx <const> = playdate.graphics
local menu <const> = playdate.getSystemMenu()

class('EndGameScene').extends(Scene)

function EndGameScene:init()
    EndGameScene.super.init(self)

    self.menuHome, error = menu:addMenuItem('go home', function()
        changeScene(HomeScene)
    end)
end

function EndGameScene:update()
    gfx.setDrawOffset(0, 0)

    local text <const> = '/o/ End of the game! Well done! /o/'
    local fontHeight <const> = gfx.getSystemFont():getHeight()
    local screenWidth <const> = playdate.display.getWidth()
    local screenHeight <const> = playdate.display.getHeight()

    gfx.drawTextAligned(
        text,
        screenWidth / 2,
        screenHeight / 2 - fontHeight / 2,
        kTextAlignment.center
    )

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end
end

function EndGameScene:destroy()
    menu:removeMenuItem(self.menuHome)
end
