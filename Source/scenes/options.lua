class('OptionsScene').extends(Scene)

function OptionsScene:init()
    OptionsScene.super.init(self)
end

function OptionsScene:update()
    playdate.graphics.setDrawOffset(0, 0)
    
    local playButton = ScreenButton('Options', 20, 20, 10)
    playButton:render()

    if playdate.buttonJustPressed(playdate.kButtonB) then
        currentState = 'home'
    end
end

function OptionsScene:destroy()
end
