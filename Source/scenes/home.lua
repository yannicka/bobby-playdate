class('HomeScene').extends(Scene)

function HomeScene:init()
    HomeScene.super.init(self)

    self.titleImage = playdate.graphics.image.new('img/title')
end

function HomeScene:update()
    playdate.graphics.setDrawOffset(0, 0)

    self.titleImage:draw(120, 16)
    
    local playButton = ScreenButton('*Play*', 200, 140, 10)
    playButton.selected = true
    playButton:render()

    local creditsButton = ScreenButton('Credits', 20, 202, 10)
    creditsButton:render()

    local helpButton = ScreenButton('Instructions', 170, 202, 10)
    helpButton:render()

    local optionsButton = ScreenButton('Options', 328, 202, 10)
    optionsButton:render()

    if playdate.buttonJustPressed(playdate.kButtonA) then
        changeScene(LevelSelectorScene)
    end
end

function HomeScene:destroy()
end
