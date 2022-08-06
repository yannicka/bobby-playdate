class('OptionsScene').extends(Scene)

function OptionsScene:init()
    OptionsScene.super.init(self)

    playdate.graphics.setDrawOffset(0, 0)
end

function OptionsScene:update()
    local playButton = ScreenButton('Options', 20, 20, 10)
    playButton:render()

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end
end

function OptionsScene:destroy()
end
