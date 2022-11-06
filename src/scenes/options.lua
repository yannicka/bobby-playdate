local gfx <const> = playdate.graphics
local menu <const> = playdate.getSystemMenu()

class('OptionsScene').extends(Scene)

function OptionsScene:init()
    OptionsScene.super.init(self)

    self.menuHome, error = menu:addMenuItem('go home', function()
        changeScene(HomeScene)
    end)

    gfx.setDrawOffset(0, 0)
end

function OptionsScene:update()
    gfx.drawText('*Options*', 10, 14)

    local playButton <const> = ScreenButton('Reset progress', 20, 50, 10)
    playButton.selected = true
    playButton:render()

    if playdate.buttonJustPressed(playdate.kButtonA) then
        finishedLevels = {}
        playdate.datastore.write(finishedLevels, 'finished-levels')
        changeScene(HomeScene)
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end
end

function OptionsScene:destroy()
    menu:removeMenuItem(self.menuHome)
end
