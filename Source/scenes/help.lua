class('HelpScene').extends(Scene)

function HelpScene:init()
    HelpScene.super.init(self)
end

function HelpScene:update()
    playdate.graphics.setDrawOffset(0, 0)

    playdate.graphics.drawText('Keys', 20, 20)
    playdate.graphics.drawText('Move the character with the directional arrows.', 20, 40)

    playdate.graphics.drawText('Goal', 20, 60)
    playdate.graphics.drawText('Complete all levels.', 20, 80)
    playdate.graphics.drawText('For each level, collect all the coins and then reach the exit.', 20, 100)

    playdate.graphics.drawText('Blocks', 20, 120)
    playdate.graphics.drawText('The rocks block you.', 20, 140)
    playdate.graphics.drawText('The treadmills take you in a given direction.', 20, 160)
    playdate.graphics.drawText('Buttons only allow you a limited number of passages.', 20, 180)
    playdate.graphics.drawText('Turnstiles block you in certain directions and turn clockwise when you exit.', 20, 200)
    playdate.graphics.drawText('Ice slides you to the next void or solid block you encounter.', 20, 220)

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end
end

function HelpScene:destroy()
end
