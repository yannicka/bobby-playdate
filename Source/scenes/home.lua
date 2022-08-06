class('HomeScene').extends(Scene)

function HomeScene:init()
    HomeScene.super.init(self)
end

function HomeScene:update()
    playdate.graphics.setDrawOffset(0, 0)
    
    local playButton = ScreenButton('Play', 20, 20, 10)
    playButton.selected = true
    playButton:render()

    local helpButton = ScreenButton('Instructions', 20, 70, 10)
    helpButton:render()

    local creditsButton = ScreenButton('Credits', 20, 120, 10)
    creditsButton:render()

    local optionsButton = ScreenButton('Options', 20, 170, 10)
    optionsButton:render()

    if playdate.buttonJustPressed(playdate.kButtonA) then
        currentState = 'levelselector'
    end
end

function HomeScene:destroy()
end
