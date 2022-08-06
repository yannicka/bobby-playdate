class('EndGameScene').extends(Scene)

function EndGameScene:init()
    EndGameScene.super.init(self)
end

function EndGameScene:update()
    playdate.graphics.setDrawOffset(0, 0)
    
    local playButton = ScreenButton('Fin du jeu', 20, 20, 10)
    playButton:render()

    if playdate.buttonJustPressed(playdate.kButtonB) then
        currentState = 'home'
    end
end

function EndGameScene:destroy()
end
