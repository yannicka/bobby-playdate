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

local fontPaths <const> = {
    [gfx.font.kVariantNormal] = 'img/fonts/Sasser-Slab',
    [gfx.font.kVariantBold] = 'img/fonts/Sasser-Slab-Bold',
    [gfx.font.kVariantItalic] = 'img/fonts/Sasser-Slab-Italic',
}

local baseFontFamily <const> = gfx.font.newFamily(fontPaths)
local outlinedFont <const> = gfx.font.new('img/fonts/Pedallica')

function setBaseFont()
    gfx.setFont(baseFontFamily[gfx.font.kVariantNormal], gfx.font.kVariantNormal)
    gfx.setFont(baseFontFamily[gfx.font.kVariantBold], gfx.font.kVariantBold)
    gfx.setFont(baseFontFamily[gfx.font.kVariantItalic], gfx.font.kVariantItalic)
end

function setOutlinedFont()
    gfx.setFont(outlinedFont)
end

setBaseFont()

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
