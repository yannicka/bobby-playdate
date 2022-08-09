import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/graphics'
import 'CoreLibs/ui'
import 'CoreLibs/crank'
import 'utils'
import 'animation'
import 'player'
import 'level'
import 'cell'
import 'button'
import 'levels'
import 'scenes/scene'
import 'scenes/credits'
import 'scenes/endgame'
import 'scenes/game'
import 'scenes/help'
import 'scenes/home'
import 'scenes/levelselector'
import 'scenes/options'

local gfx <const> = playdate.graphics

local font = gfx.font.new('img/fonts/whiteglove-stroked')
gfx.setFont(font)

finishedLevels = loadFinishedLevels()

local scene = HomeScene()

function changeScene(newScene)
    scene:destroy()
    scene = newScene()
end

function playdate.update()
    gfx.clear(gfx.kColorWhite)

    scene:update()
end
