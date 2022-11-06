local gfx <const> = playdate.graphics
local menu <const> = playdate.getSystemMenu()

class('OptionsScene').extends(Scene)

function OptionsScene:init()
    OptionsScene.super.init(self)

    self.menuHome, error = menu:addMenuItem('go home', function()
        changeScene(HomeScene)
    end)

    self.buttonSelected = 'back'

    self.backButton = ScreenButton('Go back', 80, 116, 10)
    self.backButton.selected = true

    self.resetButton = ScreenButton('Reset progress', 191, 116, 10)

    gfx.setDrawOffset(0, 0)
end

function OptionsScene:update()
    gfx.drawText('*Options*', 10, 14)

    self.backButton:render()
    self.resetButton:render()

    if self.buttonSelected == 'reset' then
        gfx.drawText('This option will erase\nall your progress.', 191, 152)
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        if self.buttonSelected == 'reset' then
            self.backButton.selected = true
            self.resetButton.selected = false

            self.buttonSelected = 'back'
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonRight) then
        if self.buttonSelected == 'back' then
            self.backButton.selected = false
            self.resetButton.selected = true

            self.buttonSelected = 'reset'
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        if self.buttonSelected == 'back' then
            changeScene(HomeScene)
        elseif self.buttonSelected == 'reset' then
            finishedLevels = {}
            playdate.datastore.write(finishedLevels, 'finished-levels')

            changeScene(HomeScene)
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end
end

function OptionsScene:destroy()
    menu:removeMenuItem(self.menuHome)
end
