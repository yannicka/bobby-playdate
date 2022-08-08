class('EndGameScene').extends(Scene)

function EndGameScene:init()
    EndGameScene.super.init(self)

    playdate.graphics.setDrawOffset(0, 0)
end

function EndGameScene:update()
    local playButton = ScreenButton('End of the game', 20, 20, 10)
    playButton:render()

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end
end

function EndGameScene:destroy()
end
