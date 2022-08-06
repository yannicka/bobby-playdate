class('GameScene').extends(Scene)

function GameScene:init()
    GameScene.super.init(self)
end

function GameScene:update()
    local backgroundImage = playdate.graphics.image.new('img/background')
    assert(backgroundImage)

    playdate.graphics.sprite.setBackgroundDrawingCallback(function(x, y, width, height)
        backgroundImage:drawTiled(x, y, width, height)
    end)

    if playdate.buttonIsPressed(playdate.kButtonUp) then
        player:move('up')
    end

    if playdate.buttonIsPressed(playdate.kButtonRight) then
        player:move('right')
    end

    if playdate.buttonIsPressed(playdate.kButtonDown) then
        player:move('down')
    end

    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        player:move('left')
    end

    level:update()

    playdate.graphics.sprite.redrawBackground()
    playdate.graphics.sprite.update()
    playdate.timer.updateTimers()
    updateCamera()
end

function GameScene:destroy()
end
