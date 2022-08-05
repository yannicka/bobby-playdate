import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'utils'
import 'player'
import 'level'
import 'cell'
import 'button'
import 'levels'

local font = playdate.graphics.font.new('img/fonts/whiteglove-stroked')

local playerSprite = nil

local level = nil
local player = nil

function loadLevel(name)
    player = nil
    level = nil

    level = Level(name)
    player = Player(level)
end

local kGameState = {home, options, help, game, endgame, credits, chooselevel}
local currentState = 'game'

local function updateCamera()
    local xOffset = -player.x + (playdate.display.getWidth() / 2)
    local yOffset = -player.y + (playdate.display.getHeight() / 2)

    xOffset = math.clamp(xOffset, -level.width * CELL_SIZE + playdate.display.getWidth() - CELL_SIZE, -CELL_SIZE)
    yOffset = math.clamp(yOffset, -level.height * CELL_SIZE + playdate.display.getHeight(), -CELL_SIZE)

    if level.width * CELL_SIZE < playdate.display.getWidth() then
        xOffset = (playdate.display.getWidth() / 2) - ((level.width * CELL_SIZE) / 2) - CELL_SIZE
    end

    if level.height * CELL_SIZE < playdate.display.getHeight() then
        yOffset = (playdate.display.getHeight() / 2) - ((level.height * CELL_SIZE) / 2) - CELL_SIZE
    end

    playdate.graphics.setDrawOffset(xOffset, yOffset)
end

local function myGameSetUp()
    loadLevel('Test')

    local startPosition = level:getStartPosition()

    if startPosition then
        player.position = startPosition:copy()
        player:moveTo(player.position.x * CELL_SIZE, player.position.y * CELL_SIZE)
    end

    local backgroundImage = playdate.graphics.image.new('img/background')
    assert(backgroundImage)

    playdate.graphics.sprite.setBackgroundDrawingCallback(function(x, y, width, height)
        backgroundImage:drawTiled(x, y, width, height)
    end)

    updateCamera()

    playdate.graphics.setFont(font)
end

myGameSetUp()

function playdate.update()
    playdate.graphics.setColor(playdate.graphics.kColorWhite)
    playdate.graphics.fillRect(0, 0, playdate.display.getWidth(), playdate.display.getHeight())

    if currentState == 'home' then
        playdate.graphics.setDrawOffset(0, 0)
    
        local playButton = ScreenButton('Play', 20, 20, 10)
        playButton.selected = true
        playButton:render()

        local helpButton = ScreenButton('Instructions', 20, 70, 10)
        helpButton:render()

        local creditsButton = ScreenButton('Credits', 20, 120, 10)
        creditsButton:render()

        local optionsButton = ScreenButton('Options', 20, 170, 10)
        optionsButton:render()

        if playdate.buttonIsPressed(playdate.kButtonA) then
            currentState = 'levelselector'
        end
    elseif currentState == 'help' then
        playdate.graphics.setDrawOffset(0, 0)
    
        local playButton = ScreenButton('Page d aide', 20, 20, 10)
        playButton:render()

        if playdate.buttonIsPressed(playdate.kButtonB) then
            currentState = 'home'
        end
    elseif currentState == 'levelselector' then
        playdate.graphics.setDrawOffset(0, 0)
    
        for i = 1, 50 do
            local button = ScreenButton(i, i * 30, 20, 8)
            if i == 1 then
                button.selected = true
            end
            button:render()
        end

        if playdate.buttonIsPressed(playdate.kButtonB) then
            currentState = 'home'
        end

        if playdate.buttonIsPressed(playdate.kButtonA) then
            currentState = 'game'
        end
    elseif currentState == 'game' then
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
end
