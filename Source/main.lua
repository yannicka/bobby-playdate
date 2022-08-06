import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/graphics'
import 'CoreLibs/ui'
import 'CoreLibs/crank'
import 'utils'
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

local font = playdate.graphics.font.new('img/fonts/whiteglove-stroked')
playdate.graphics.setFont(font)

local playerSprite = nil

level = nil
player = nil

local currentLevelName = nil

finishedLevels = playdate.datastore.read()

if finishedLevels == nil then
    finishedLevels = {}
end

local scene = HomeScene()

function changeScene(newScene)
    scene:destroy()
    scene = newScene()
end

function playdate.update()
    playdate.graphics.setColor(playdate.graphics.kColorWhite)
    playdate.graphics.fillRect(0, 0, playdate.display.getWidth(), playdate.display.getHeight())

    scene:update()
end
