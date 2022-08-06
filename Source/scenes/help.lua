class('HelpScene').extends(Scene)

function HelpScene:init()
    HelpScene.super.init(self)
end

function HelpScene:update()
    playdate.graphics.setDrawOffset(0, 0)
    
    local playButton = ScreenButton('Page d\'aide', 20, 20, 10)
    playButton:render()

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end
end

function HelpScene:destroy()
end
