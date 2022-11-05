local gfx <const> = playdate.graphics

class('EndGameScene').extends(Scene)

function EndGameScene:init()
    EndGameScene.super.init(self)

    gfx.setDrawOffset(0, 0)
end

function EndGameScene:update()
    local text = '/o/ End of the game! Well done! /o/'

    local fontHeight = gfx.getSystemFont():getHeight()

    local screenWidth = playdate.display.getWidth()
    local screenHeight = playdate.display.getHeight()

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
end
