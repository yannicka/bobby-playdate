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

local font = playdate.graphics.font.new('img/fonts/whiteglove-stroked')
playdate.graphics.setFont(font)

local playerSprite = nil

local level = nil
local player = nil

local currentLevelName = nil

local currentState = 'levelselector'

local finishedLevels = playdate.datastore.read()

if finishedLevels == nil then
    finishedLevels = {}
end

function loadLevel(name)
    currentState = 'game'

    if level then
        level:remove()
    end

    if player then
        player:remove()
    end

    currentLevelName = name

    level = Level(name)
    player = Player(level)

    local startPosition = level:getStartPosition()

    if startPosition then
        player.position = startPosition:copy()
        player:moveTo(player.position.x * CELL_SIZE, player.position.y * CELL_SIZE)
    end
end

function goToNextLevel()
    table.insert(finishedLevels, currentLevelName)

    playdate.datastore.write(finishedLevels)

    a = indexOf(levelsOrder, currentLevelName)
    b = next(levelsOrder, a)
    c = levelsOrder[b]

    loadLevel(c)
end

local function updateCamera()
    local xOffset = -player.x + (playdate.display.getWidth() / 2)
    local yOffset = -player.y + (playdate.display.getHeight() / 2)

    xOffset = math.clamp(xOffset, -level.width * CELL_SIZE + playdate.display.getWidth() - CELL_SIZE, -CELL_SIZE)
    yOffset = math.clamp(yOffset, -level.height * CELL_SIZE + playdate.display.getHeight() - CELL_SIZE, -CELL_SIZE)

    if level.width * CELL_SIZE < playdate.display.getWidth() then
        xOffset = (playdate.display.getWidth() / 2) - ((level.width * CELL_SIZE) / 2) - CELL_SIZE
    end

    if level.height * CELL_SIZE < playdate.display.getHeight() then
        yOffset = (playdate.display.getHeight() / 2) - ((level.height * CELL_SIZE) / 2) - CELL_SIZE
    end

    playdate.graphics.setDrawOffset(xOffset, yOffset)
end

local gridviewSprite = playdate.graphics.sprite.new()
gridviewSprite:setCenter(0, 0)
gridviewSprite:moveTo(0, 0)
gridviewSprite:add()

local gridview = playdate.ui.gridview.new(30, 30)

gridview:setNumberOfColumns(10)
gridview:setNumberOfRows(5)
gridview:setCellPadding(4, 4, 4, 4)
gridview:setContentInset(9, 0, 12, 0)
gridview:setSectionHeaderHeight(24)

function gridview:drawSectionHeader(section, x, y, width, height)
    local fontHeight = playdate.graphics.getSystemFont():getHeight()
    playdate.graphics.drawTextAligned('Choix du niveau', x, y, kTextAlignment.left)
end

function gridview:drawCell(section, row, column, selected, x, y, width, height)
    playdate.graphics.setLineWidth(1)
    playdate.graphics.setColor(playdate.graphics.kColorBlack)

    local levelIndex = tonumber((row - 1) * 10) + tonumber(column)
    local levelName = levelsOrder[levelIndex]
    local finished = table.contains(finishedLevels, levelName)

    if finished then
        playdate.graphics.fillRoundRect(x, y, width, height, 8)
    else
        playdate.graphics.drawRoundRect(x, y, width, height, 8)
    end

    if selected then
        playdate.graphics.setLineWidth(2)
        playdate.graphics.drawRoundRect(x - 2, y - 2, width + 4, height + 4, 10)
    end

    local fontHeight = playdate.graphics.getSystemFont():getHeight()

    playdate.graphics.drawTextInRect(tostring(levelIndex), x, y + (height / 2 - fontHeight / 2) + 3, width, height, nil, nil, kTextAlignment.center)
end

for i = 1,50 do
    local levelName = levelsOrder[i]
    local finished = table.contains(finishedLevels, levelName)

    if not finished then
        local row = math.ceil(i / 10)
        local column = i % 10

        gridview:setSelection(1, row, column)
        
        break
    end
end

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

        if playdate.buttonJustPressed(playdate.kButtonA) then
            currentState = 'levelselector'
        end
    elseif currentState == 'options' then
        playdate.graphics.setDrawOffset(0, 0)
    
        local playButton = ScreenButton('Options', 20, 20, 10)
        playButton:render()

        if playdate.buttonJustPressed(playdate.kButtonB) then
            currentState = 'home'
        end
    elseif currentState == 'help' then
        playdate.graphics.setDrawOffset(0, 0)
    
        local playButton = ScreenButton('Page d\'aide', 20, 20, 10)
        playButton:render()

        if playdate.buttonJustPressed(playdate.kButtonB) then
            currentState = 'home'
        end
    elseif currentState == 'credits' then
        playdate.graphics.setDrawOffset(0, 0)
    
        local playButton = ScreenButton('Credits', 20, 20, 10)
        playButton:render()

        if playdate.buttonJustPressed(playdate.kButtonB) then
            currentState = 'home'
        end
    elseif currentState == 'endgame' then
        playdate.graphics.setDrawOffset(0, 0)
    
        local playButton = ScreenButton('Fin du jeu', 20, 20, 10)
        playButton:render()

        if playdate.buttonJustPressed(playdate.kButtonB) then
            currentState = 'home'
        end
    elseif currentState == 'levelselector' then
        playdate.graphics.setDrawOffset(0, 0)

        if playdate.buttonJustPressed(playdate.kButtonUp) then
            gridview:selectPreviousRow(true)
        elseif playdate.buttonJustPressed(playdate.kButtonDown) then
            gridview:selectNextRow(true)
        elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
            gridview:selectPreviousColumn(true)
        elseif playdate.buttonJustPressed(playdate.kButtonRight) then
            gridview:selectNextColumn(true)
        end

        local crankTicks = playdate.getCrankTicks(2)

        if crankTicks == 1 then
            gridview:selectNextRow(true)
        elseif crankTicks == -1 then
            gridview:selectPreviousRow(true)
        end

        if gridview.needsDisplay then
            local gridviewImage = playdate.graphics.image.new(playdate.display.getWidth(), playdate.display.getHeight())
            playdate.graphics.pushContext(gridviewImage)
            gridview:drawInRect(0, 0, playdate.display.getWidth(), playdate.display.getHeight())
            playdate.graphics.popContext()
            gridviewSprite:setImage(gridviewImage)
        end
    
        if playdate.buttonJustPressed(playdate.kButtonA) then
            local section, row, column = gridview:getSelection()
            local levelIndex = tonumber((row - 1) * 10) + tonumber(column)

            gridviewSprite:remove()

            local levelName = levelsOrder[levelIndex]
            loadLevel(levelName)
        end

        if playdate.buttonJustPressed(playdate.kButtonB) then
            currentState = 'home'
        end

        playdate.graphics.sprite.update()
        playdate.timer.updateTimers()
    elseif currentState == 'game' then
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
end
