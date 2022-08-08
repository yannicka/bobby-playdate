class('HomeScene').extends(Scene)

function HomeScene:init()
    HomeScene.super.init(self)

    playdate.graphics.setDrawOffset(0, 0)

    self.titleImage = playdate.graphics.image.new('img/title')
    self.buttonSelected = 'play'

    self.playButton = ScreenButton('*Play*', 185, 148, 10)
    self.playButton.selected = true

    self.creditsButton = ScreenButton('Credits', 20, 208, 10)
    self.helpButton = ScreenButton('Instructions', 157, 208, 10)
    self.optionsButton = ScreenButton('Options', 328, 208, 10)
end

function HomeScene:update()
    self.titleImage:draw(0, 0)

    self.playButton:render()
    self.creditsButton:render()
    self.helpButton:render()
    self.optionsButton:render()

    if playdate.buttonJustPressed(playdate.kButtonDown) then
        if self.buttonSelected == 'play' then
            self.playButton.selected = false
            self.helpButton.selected = true

            self.buttonSelected = 'help'
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonUp) then
        self.playButton.selected = true
        self.creditsButton.selected = false
        self.helpButton.selected = false
        self.optionsButton.selected = false

        self.buttonSelected = 'play'
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        if self.buttonSelected == 'help' then
            self.creditsButton.selected = true
            self.helpButton.selected = false

            self.buttonSelected = 'credits'
        elseif self.buttonSelected == 'options' then
            self.helpButton.selected = true
            self.optionsButton.selected = false

            self.buttonSelected = 'help'
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonRight) then
        if self.buttonSelected == 'credits' then
            self.creditsButton.selected = false
            self.helpButton.selected = true

            self.buttonSelected = 'help'
        elseif self.buttonSelected == 'help' then
            self.helpButton.selected = false
            self.optionsButton.selected = true

            self.buttonSelected = 'options'
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        if self.buttonSelected == 'play' then
            changeScene(LevelSelectorScene)
        elseif self.buttonSelected == 'credits' then
            changeScene(CreditsScene)
        elseif self.buttonSelected == 'help' then
            changeScene(HelpScene)
        elseif self.buttonSelected == 'options' then
            changeScene(OptionsScene)
        end
    end
end

function HomeScene:destroy()
end
