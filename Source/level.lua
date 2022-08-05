import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'cell'

local gfx <const> = playdate.graphics

local CELL_SIZE <const> = 20

local levels = {
    ['Test'] = [[
        # # # # # # # # . # # # # # # # # # # #
        # # # . E . # # . . . . . . . . . . . #
        # # . . . . . # . F . T . . . . 8 . . #
        # $ . . . . . $ . . . . . . . 4 . 6 . #
        # $ . . . . . $ . L . J . . . . 2 . . #
        . $ . . . . . $ . . . . . B3 . . . . . .
        # # . . S . . . . . . . . . . . . . . #
        # # # . . . . . . . = . H . . > . v . #
        # # # . . . . . . . . . . . . ^ . v . #
        # # # . . . # # . ! ! ! . . . ^ < < . #
        # # # . . . # # . ! ! . . B2 . . . . . #
        # # # # # # # # . # # # # # # # # # # #
    ]],
    
    ['Halley'] = [[
        # # # # # # # # #
        # # # . E . # # #
        # # . . . . . # #
        # $ . . . . . $ #
        # $ . . . . . $ #
        # $ . . . . . $ #
        # # . . S . . # #
        # # # . . . # # #
        # # # # # # # # #
    ]],

    -- Caméra
    ['Encke'] = [[
        # # # # # # # # # # #
        # $ . . . . . . . $ #
        # . . . . . . . . . #
        # . . # # . # # . . #
        # . . # $ . $ # . . #
        # . . . . E . . . . #
        # . . # $ . $ # . . #
        # . . # # . # # . . #
        # . . . . S . . . . #
        # $ . . . . . . . $ #
        # # # # # # # # # # #
    ]],

    -- Tapis roulants
    ['Biela'] = [[
        # # # # # # # # #
        # # . . E . . # #
        # # . . . . . # #
        # $ > . . . < $ #
        # $ # . # . # $ #
        # $ < . . . > $ #
        # # . . S . . # #
        # # . . . . . # #
        # # # # # # # # #
    ]],

    ['Faye'] = [[
        # # # # # # # # #
        # # # # E # # # #
        # # # # . # # # #
        # . . > . > . . #
        # $ . # # # . $ #
        # # ^ # $ # v # #
        # # ^ . . . v # #
        # . . . S . . . #
        # # # # # # # # #
    ]],

    -- Glace
    ['Brorsen'] = [[
        # # # # # # # # #
        # S . ! ! ! ! . #
        # # # # # # ! . #
        # $ $ $ $ $ # . #
        # # # # ! ! # . #
        # ! ! ! # ! # . #
        # ! $ ! . ! # . #
        # ! ! ! . . . E #
        # # # # # # # # #
    ]],

    ['Tuttle'] = [[
        # # # # # # # # #
        # S # . . . . . #
        # . ! # . . . $ #
        # # ! $ # $ . . #
        # . ! ! ! ! # . #
        # . # . # # . . #
        # . . . # . . . #
        # . $ . # . . E #
        # # # # # # # # #
    ]],

    -- Tourniquets
    ['Tempel'] = [[
        # # # # # # # # #
        # . . . S . . . #
        # . . # . # . . #
        # # # # $ # # # #
        # . . $ H $ . . #
        # . # # $ # # . #
        # . . # . # . . #
        # . . . E . . . #
        # # # # # # # # #
    ]],

    ['Olbers'] = [[
        # # # # # # # # #
        # . . . . . . . #
        # . . # # # . . #
        # . # # $ # # . #
        # S . $ J $ # . #
        # . # # $ # # . #
        # . . # # # . . #
        # . . . E . . . #
        # # # # # # # # #
    ]],

    -- Boutons
    ['Wolf'] = [[
        # # # # # # # # #
        # $ . . # . . $ #
        # . . # # # . . #
        # . . . # . . . #
        # S . . B . . E #
        # . . . # . . . #
        # . . # # # . . #
        # $ . . # . . $ #
        # # # # # # # # #
    ]],

    ['Finlay'] = [[
        # # # # # # # # #
        # S . B . . . $ #
        # . . # . # . . #
        # . # . . . # . #
        # . B . $ . # . #
        # B # . . . # . #
        # . . # # # # # #
        # $ . . . . . E #
        # # # # # # # # #
    ]],

    -- Premiers « vrais » niveaux
    ['Brooks'] = [[
        # # # # # # # # #
        # S . . # . . . #
        # . . . # # . $ #
        # # # L = # . . #
        # . # L T $ . . #
        # . # # # # . . #
        # . . . . . $ . #
        # . . . E . . . #
        # # # # # # # # #
    ]],

    ['Holmes'] = [[
        # # # # # # # # #
        # . . . . . . . #
        # . S . . $ $ # #
        # . . . # . . . #
        # . . = ! ! ! ! #
        # . . # . # # # #
        # $ . # . . . . #
        # . . # $ . . E #
        # # # # # # # # #
    ]],

    ['Borrelly'] = [[
        # # # # # # # # #
        # S # # # . ! # #
        # . . ! ! $ ! $ #
        # # # ! ! . ! . #
        # . . ! ! ! ! ! #
        # . . . ! # . # #
        # # # # ! # . . #
        # . $ . $ # . E #
        # # # # # # # # #
    ]],

    ['Westphal'] = [[
        # # # # # # # # # # # #
        # $ . = . . . . . . . #
        # . . # . . $ . . . . #
        # # H # . # # # . . . #
        # . . . = S E . J . $ #
        # # H # . # # # . . . #
        # . . # . . $ . . . . #
        # $ . = . . . . . . . #
        # # # # # # # # # # # #
    ]],

    ['Kopff'] = [[
        # # # # # # # # # # # # # # # # # # # #
        # S . . . . . . . . . . . . # . . . $ #
        # . # # # # # # # # # . # . # . # . . #
        # . . . . # . . . . . . # . # # # . # #
        # # # # . # . # # # # # # . # . . . . #
        # . . . . # . # . # . . . . # . # # . #
        # . # # . # . # . # . # # # # . # . . #
        # . . # . . . . . # . . . . . . # . # #
        # # . # # # # # . # # # # . # . # . . #
        # . . # . . . # . # . . . . # . # # # #
        # . # # . # . # . # # # # . # . . . . #
        # . . . . # . # . # . . . . # # # # . #
        # # # # # # . # . # . # # # # . # . . #
        # . # . . . . # . # . . # . . . # . # #
        # . . . # . # # . # # . # . # # # . . #
        # . # # # . # . . . . . # . # . # # . #
        # . # . . . # # # # # # # . # . . . . #
        # . # # # # # . # . . . # . # . # # # #
        # $ . . . . . . . . # . . . # . . . E #
        # # # # # # # # # # # # # # # # # # # #
    ]],

    ['Schaumasse'] = [[
        # # # # # # # # #
        # $ . # S # $ . #
        # . . ! ! ! . . #
        # ! ! ! ! ! ! ! #
        # ! $ ! B ! $ ! #
        # ! ! ! ! ! ! ! #
        # # # . . . # # #
        # . . . . . . E #
        # # # # # # # # #
    ]],

    ['Crommelin'] = [[
        # # # # # # # # #
        # S . . ! . . . #
        # . $ # ! . $ . #
        # # # # ! # # # #
        # ! ! ! L ! ! ! #
        # B # # ! # # . #
        # . $ # ! . $ . #
        # . . B ! # . E #
        # # # # # # # # #
    ]],

    -- Par Aur36
    ['Reinmuth'] = [[
        # # # # # # # # #
        # $ . . E . . $ #
        # $ $ . . . $ $ #
        # # # # ^ # # # #
        # $ B B $ B B $ #
        # B # # ^ # # B #
        # B # # ^ # # B #
        # $ B B $ B B $ #
        # B # # B # # ^ #
        # B # # B # # ^ #
        # $ B B $ B B $ #
        # B # # ^ # # B #
        # B # # ^ # # B #
        # $ B B S B B $ #
        # # # # # # # # #
    ]],

    -- Par Aur36
    ['Daniel'] = [[
        # # # # # # # # # # # # #
        # $ . . . . . B . . . $ #
        # . . . . . . # . . . . #
        # ^ # # # # # # B # # # #
        # . . . . . . . . # . . #
        # . $ . T = T . . # . $ #
        # . $ . H $ H . . # . $ #
        # . $ . F = T . . # . $ #
        # . . . . . . . . # . . #
        # ^ # B # # # # # # . . #
        # . . . . . . . . # . . #
        # . S . $ $ $ . . > . E #
        # # # # # # # # # # # # #
    ]],

    ['Gale'] = [[
        #  #  #  #  #  #  #  #  #
        #  S  #  .  .  .  .  .  #
        #  .  #  #  .  .  $  .  #
        #  .  .  #  #  .  .  .  #
        #  .  $  .  #  #  B2 #  #
        #  .  $  $  .  .  .  .  #
        #  #  .  $  .  .  .  .  #
        #  #  #  .  .  .  .  E  #
        #  #  #  #  #  #  #  #  #
    ]],

    ['Whipple'] = [[
        #  #  #  #  #  #  #  #  #
        #  S  .  .  #  .  .  .  #
        #  .  $  .  #  .  $  .  #
        #  .  .  #  .  .  .  .  #
        #  v  v  #  B2 #  ^  ^  #
        #  .  .  .  .  #  .  .  #
        #  .  $  .  #  .  $  .  #
        #  .  .  .  B  .  .  E  #
        #  #  #  #  #  #  #  #  #
    ]],

    ['Forbes'] = [[
        # # # # # # # # #
        # # S . E . . # #
        # . . . $ . . . #
        # . # # # # 2 # #
        # . # $ $ $ $ . #
        # $ # . # . # . #
        # . 6 B B B B B #
        # . # $ $ $ $ # #
        # # # # # # # # #
    ]],

    ['Oterma'] = [[
        # # # # # # # # # # #
        # $ . B . $ . B . $ #
        # . . # . . . # . . #
        # B # # # B # # # B #
        # $ . B . S . B . $ #
        # B # # # B # # # B #
        # . . # . . . # . . #
        # $ . B . E . B . $ #
        # # # # # # # # # # #
    ]],

    ['Wirtanen'] = [[
        # # # # # # # # #
        # # # # E # # # #
        # B . . . . . B #
        # $ # # . # # $ #
        # B . $ B $ . B #
        # # # $ B $ # # #
        # # # # . # # # #
        # . . . S . . . #
        # # # # # # # # #
    ]],

    ['Johnson'] = [[
        # # # # # # # # #
        # S . . # . # # #
        # . . . B . . # #
        # . . # # # . . #
        # . $ T $ F $ . #
        # . . . # . . . #
        # # . . B . . . #
        # # # . # . . E #
        # # # # # # # # #
    ]],

    ['Arend'] = [[
        # # # # # # # # #
        # S # . # . . . #
        # . # . # . # . #
        # . 6 . 8 . $ . #
        # B # # # . # . #
        # $ < . < . $ . #
        # . # . # . # . #
        # . # . # . . E #
        # # # # # # # # #
    ]],

    ['Harrington'] = [[
        # # # # . # # # #
        # S # # . . . . #
        # . # # # # # . #
        # . # . . # # . #
        . . # # $ # # . .
        # # # # . # # # #
        . . . . . # . . .
        # . . # . # . E #
        # # # # . # # # #
    ]],

    ['Tsuchinshan'] = [[
        #  #  #  #  #  #  #  #  #
        #  $  B  $  #  .  .  #  #
        #  B  2  B2 $  T  .  .  #
        #  S  #  B  #  B  #  .  #
        #  B  2  B2 $  J  .  .  #
        #  .  #  $  #  $  #  .  #
        #  .  #  B  #  #  #  .  #
        #  .  .  .  .  .  .  E  #
        #  #  #  #  #  #  #  #  #
    ]],

    ['Wild'] = [[
        # # # # # # # # #
        # . . . . < . $ #
        # # . # v # # ^ #
        # . . > $ B . . #
        # S # # F B B E #
        # . . > $ B . . #
        # # . # ^ # # v #
        # . . . . < . $ #
        # # # # # # # # #
    ]],

    ['Kojima'] = [[
        # # # # # # # # #
        # S # . $ = $ . #
        # . # . . # . . #
        # $ = . B # B T #
        # . F . J . T . #
        # F B # # . B $ #
        # . . # . . # . #
        # . $ = $ . # E #
        # # # # # # # # #
    ]],

    ['Taylor'] = [[
        # # # # # # # # # # # # #
        # . . . . . # . . . . . #
        # . $ . . . # . . . $ . #
        # . . . # F > . # . . . #
        # . . # F J . L T # . . #
        # . . . J . . . L T . . #
        # # # ^ . . S . . v # # #
        # . . L T . E . F . . . #
        # . . # L T . F J # . . #
        # . . . # . < J # . . . #
        # . $ . . . # . . . $ . #
        # . . . . . # . . . . . #
        # # # # # # # # # # # # #
    ]],

    ['Klemola'] = [[
        # # # # # # # # # #
        # # # . . . . # # #
        # # . . . . . . # #
        # . . J J L L . . #
        # S . H J $ H . . #
        # . . H $ F H . E #
        # . . T T F F . . #
        # # . . . . . . # #
        # # # . . . . # # #
        # # # # # # # # # #
    ]],

    ['Kohoutek'] = [[
        # # . # # # # # # # . # #
        # . . . # . . . # . . . #
        . . $ . # . $ . B . $ . .
        # . . . # . . . # . . . #
        # # B # # # B # # # B # #
        # . . . # . . . # . . . #
        # . $ . # . S . B . $ . #
        # . . . # . . . # . . . #
        # # B # # # B # # # B # #
        # . . . # . . . # . . . #
        # . $ . # . E . # . $ . #
        # . . . # . . . # . . . #
        # # . # # # # # # # . # #
    ]],

    ['Clark'] = [[
        #  #  #  #  #  #  #  #  #
        #  S  #  $  #  $  #  $  #
        #  $  #  $  B  T  B  $  #
        #  $  #  $  #  $  #  $  #
        #  $  B  F  B2 $  #  $  #
        #  $  #  $  #  $  #  $  #
        #  $  #  $  B  J  B  $  #
        #  $  B  $  #  $  #  E  #
        #  #  #  #  #  #  #  #  #
    ]],

    ['Longmore'] = [[
        #  #  #  #  #  #  #  #  #
        #  $  L  $  8  =  8  .  #
        #  .  F  B2 #  .  6  .  #
        #  H  #  4  #  4  #  #  #
        #  .  .  .  .  .  .  .  #
        #  .  .  .  S  .  .  .  #
        #  #  .  .  E  .  .  #  #
        #  #  #  .  .  .  #  #  #
        #  #  #  #  #  #  #  #  #
    ]],

    ['Gunn'] = [[
        # # # # # # # # # # # # #
        # $ . . . # $ . ! ! . $ #
        # . . . . # . . ! ! . . #
        # # # ! ! T ! ! ! ! # # #
        # $ . ! ! ! B ! ! ! . $ #
        # # v ! ! . # # ! ! # # #
        # . . ! ! . $ . ! ! . $ #
        # # # ! ! # B . ! ! # # #
        # S . ! ! # ! ! ! ! . $ #
        # # ! ! ! ! ! ! # ! # # #
        # . . ! ! . . . # . . . #
        # $ . ! ! . $ . # . . E #
        # # # # # # # # # # # # #
    ]],

    ['Gehrels'] = [[
        # # # # # # # # #
        # ! . . # . . ! #
        # ! $ . # . $ ! #
        # ! . J B L . ! #
        # ^ # H # H # ^ #
        # ! $ L ! J $ ! #
        # ! . ! ! ! . ! #
        # ! S # E # . ! #
        # # # # # # # # #
    ]],

    ['Helin'] = [[
        # # # # # # # # #
        # S . B . # . $ #
        # . $ J $ 6 . . #
        # . B # . # # 4 #
        # B $ . J v . . #
        # 4 # # . < v # #
        # . . B ^ < . $ #
        # $ . < . $ < E #
        # # # # # # # # #
    ]],

    ['Russell'] = [[
        # # # . # # # . # # #
        # . . . $ S $ . . . #
        # # # # # # # # # . #
        B . $ . # . . $ # . .
        # . # # # B # . 6 B #
        # L . # $ . # # # . #
        # . # # # B # . # . #
        . . . . = . # . $ . .
        # . # . # . # # # # #
        # $ # . # . . . . E #
        # # # . # # # . # # #
    ]],

    ['Giclas'] = [[
        # # # # # # # # # # # # #
        # . . . . . # . . . . . #
        # # . $ . . # . . $ . # #
        # . # . . F = T . . # . #
        # . . # . H . H . # . . #
        # . $ . F J . L T . $ . #
        # . . . H . E . H . . . #
        # # # F J . . . L T # # #
        # . . H . . . . . H . . #
        # . . L = = 8 = = J . . #
        # $ . B . = 2 = . B . $ #
        # . . # . . S . . # . . #
        # # # # # # # # # # # # #
    ]],

    ['Boethin'] = [[
        # # # # # # # # # # # # #
        # $ . B . . $ . . B . $ #
        # . F = T # H # F = T . #
        # . H $ H $ H $ H $ . . #
        # # 4 = J # H # 4 = = # #
        # . H . . . H . H . . . #
        # . H . S . H . H . E . #
        # . . . . . . . . . . . #
        # # # # # # # # # # # # #
    ]],

    ['Bus'] = [[
        # # # # # # # # # # # # #
        # . . B . $ # $ . B . . #
        # . $ . # . # . # . $ . #
        # . . # # F B T # # . . #
        # . B 4 $ . . . $ 6 B . #
        # # # . # . . . # . # # #
        # # . L B # B # B J . # #
        # # . B . . S . . B . # #
        # . $ . # # E # # . $ . #
        # # # # # # # # # # # # #
    ]],

    ['Howell'] = [[
        # # # # # # # # #
        # $ . . # . . $ #
        # . F = 8 = T . #
        # . H B S B H . #
        # # 4 ! ! ! 6 # #
        # . H B E B H . #
        # . L = 2 = J . #
        # $ . . # . . $ #
        # # # # # # # # #
    ]],

    ['Sanguin'] = [[
        # # # # # # # # #
        # $ . . F . . . #
        # # # B H B S . #
        # . B . H . B . #
        # L = = B = = J #
        # . B . H . B $ #
        # $ # B H B # # #
        # E # . L . $ . #
        # # # # # # # # #
    ]],

    ['Lovas'] = [[
        # # # # # # # # #
        # S # . B . # . #
        # . B $ # $ B # #
        # . J . B . J . #
        # . B # . # # . #
        # . J $ J $ # . #
        # E # # $ # # . #
        # . < . B . . $ #
        # # # # # # # # #
    ]],

    ['Chiron'] = [[
        # # # # # # # # # # # # #
        # ! ! ! ! # ! ! ! ! ! # #
        # ! $ ! ! ! ! ! ! ! T . #
        # ! ! ! ! ! ! ! ! # . . #
        # ! ! ! ! # B # # . $ . #
        # ! ! ! # . . . # . . . #
        # 6 # # # . S . # # # 6 #
        # . . . # . E . # . . . #
        # . $ . # # B # # . $ . #
        # . . # . . H . . # . . #
        # . L = = T 6 F = = J . #
        # # . . . L 2 J . . . . #
        # # # # # # # # # # # # #
    ]],

    ['Machholz'] = [[
        # # . # . # . # #
        # $ . # $ # . $ #
        . # B # . # B # .
        T . . F H T . . F
        4 = = = S = = = 6
        J . . L H J . . L
        . # B # . # B # .
        # $ . # $ # . $ #
        # # . # E # . # #
    ]],

    ['Takamizawa'] = [[
        # # # # # # # # # # # # #
        # E . . . B . $ . $ . . #
        # . . . . # # # # # # . #
        # # # # B T $ $ $ $ . . #
        # $ . . . H $ $ $ $ # . #
        # # # $ . L = F = = T # #
        # # # F = = = H = = J # #
        # . . H . $ . H . $ . # #
        # . . H # # # H # # # . #
        # . . H . $ . ! . $ $ . #
        # . . . . $ . ! . $ $ . #
        # . . . S . . B . . . . #
        # # # # # # # # # # # # #
    ]],

    ['Kowal'] = [[
        # # # # # # # # # # # # #
        # . . . # . . . # . . . #
        # . $ . # . E . # . $ . #
        # . . . F T . F T . . . #
        # . . F J L = J L T . . #
        # # # H $ . # . $ H # # #
        # . . L T . # . F J . . #
        # . . . L T # F J . . . #
        # . . . . L F J . . . . #
        # # . . . . H . . . . # #
        # # # . . . . . . . # # #
        # # # # . . S . . # # # #
        # # # # # # # # # # # # #
    ]],

    ['Hartley'] = [[
        # # # # # # # # # # # # #
        # . . . # . . . # . . . #
        # . $ . 4 . $ . 6 . $ . #
        # . . . # . . . # . . . #
        # # # 8 B F # T B 8 # # #
        # . . . # . . . # . . . #
        # . $ . 6 . S . 4 . $ . #
        # . . . # . . . # . . . #
        # # # 2 B L # J B 2 # # #
        # . . . # . . . # . . . #
        # . $ . 4 . E . 6 . $ . #
        # . . . # . . . # . . . #
        # # # # # # # # # # # # #
    ]],
}

local level = levels['Test']

local function splitLines(str)
    local result = {}

    for line in str:gmatch('[^\n]+') do
        table.insert(result, line)
    end

    return result
end

function parseStringLevel(level)
    -- Retire les espaces au début de chaque ligne
    local levelWithoutSpace = level:gsub('/^ +/gm', '')
  
    -- Remplace les espaces consécutives par une seule espace
    levelWithoutSpace = levelWithoutSpace:gsub('/ +/g', ' ')
  
    -- Coupe à chaque ligne
    local lines = splitLines(levelWithoutSpace)
  
    -- Retire les lignes vides
    -- lines = lines.filter((el: string) => el.length > 0)
  
    local map = {}

    for i,line in ipairs(lines) do
        local t = {}
        for w in line:gmatch('%S+') do
            table.insert(t, w)
        end

        table.insert(map, t)
    end

    return map
end

class('Level').extends(Object)

function Level:init()
    Level.super.init(self)

    local grid = parseStringLevel(level)

    self.grid = {}
    self.width = 0
    self.height = 0
    self.nbCoins = 0

    for y,v in ipairs(grid) do
        self.grid[y] = {}
        self.height += 1

        for x,v2 in ipairs(v) do
            local cell = 0

            if v2 ~= '.' then
                if v2 == '#' then
                    cell = Stone({x, y})
                elseif v2 == 'S' then
                    cell = Start({x, y})
                elseif v2 == 'E' then
                    cell = End({x, y})
                elseif v2 == '$' then
                    cell = Coin({x, y})

                    self.nbCoins += 1
                elseif v2 == '^' then
                    cell = Conveyor({x, y}, 'up')
                elseif v2 == 'v' then
                    cell = Conveyor({x, y}, 'down')
                elseif v2 == '<' then
                    cell = Conveyor({x, y}, 'left')
                elseif v2 == '>' then
                    cell = Conveyor({x, y}, 'right')
                elseif v2 == 'T' then
                    cell = Turnstile({x, y}, 'up-right')
                elseif v2 == 'F' then
                    cell = Turnstile({x, y}, 'up-left')
                elseif v2 == 'J' then
                    cell = Turnstile({x, y}, 'down-right')
                elseif v2 == 'L' then
                    cell = Turnstile({x, y}, 'down-left')
                elseif v2 == '=' then
                    cell = Turnstile({x, y}, 'horizontal')
                elseif v2 == 'H' then
                    cell = Turnstile({x, y}, 'vertical')
                elseif v2 == '8' then
                    cell = Turnstile({x, y}, 'up')
                elseif v2 == '6' then
                    cell = Turnstile({x, y}, 'right')
                elseif v2 == '2' then
                    cell = Turnstile({x, y}, 'down')
                elseif v2 == '4' then
                    cell = Turnstile({x, y}, 'left')
                elseif v2 == 'B' then
                    cell = Button({x, y}, 1)
                elseif v2 == 'B2' then
                    cell = Button({x, y}, 2)
                elseif v2 == 'B3' then
                    cell = Button({x, y}, 3)
                elseif v2 == '!' then
                    cell = Ice({x, y})
                end
            end

            self.grid[y][x] = cell

            if self.height == 1 then
                self.width += 1
            end
        end
    end

    self.endCell = self:getEndCell()
end

function Level:update()
    if self.nbCoins == 0 then
        self.endCell:activate()
    end
end

function Level:getCellAt(position)
    local row = self.grid[position[2]]

    if row then
        if row[position[1]] ~= 0 then
            return row[position[1]]
        end
    end

    return nil
end

function Level:setCellAt(position, newCell)
    local row = self.grid[position[2]]

    if row then
        row[position[1]] = newCell
    end
end

function Level:getStartPosition()
    for y,row in ipairs(self.grid) do
        for x,cell in ipairs(row) do
            if cell ~= 0 and cell:isa(Start) then
                return {x, y}
            end
        end
    end
end

function Level:getEndCell()
    for y,row in ipairs(self.grid) do
        for x,cell in ipairs(row) do
            if cell ~= 0 and cell:isa(End) then
                return cell
            end
        end
    end
end
