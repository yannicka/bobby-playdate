class('CreditsScene').extends(Scene)

function CreditsScene:init()
    CreditsScene.super.init(self)

    playdate.graphics.setDrawOffset(0, 0)
end

function CreditsScene:update()
    local playButton = ScreenButton('Credits', 20, 20, 10)
    playButton:render()

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end
end

function CreditsScene:destroy()
end
