local gfx <const> = playdate.graphics
local menu <const> = playdate.getSystemMenu()

class('HelpScene').extends(Scene)

local text <const> = [[
*Instructions*

_Keys_
Move the character with the arrow keys.

_Goal_
For each level, collect all the coins and then reach the exit.
Complete all levels.

_Blocks_
- Rocks block you.
- Conveyor belts let you move in only one direction.
- Buttons only allow a certain number of passes.
- Turnstiles block you from certain directions and turn clockwise when you exit.
- Ice makes you slide to the next grass or solid block you encounter.
]]

function HelpScene:init()
    HelpScene.super.init(self)

    self.menuHome, error = menu:addMenuItem('go home', function()
        changeScene(HomeScene)
    end)

    gfx.setDrawOffset(0, 0)

    self.offset = 0

    self.gridviewSprite = gfx.sprite.new()
    self.gridviewSprite:setCenter(0, 0)
    self.gridviewSprite:moveTo(10, 14)
    self.gridviewSprite:add()
end

function HelpScene:update()
    gfx.setDrawOffset(0, self.offset)

    local gridviewImage <const> = gfx.image.new(playdate.display.getWidth() - 20, 600)
    gfx.pushContext(gridviewImage)
    gfx.drawTextInRect(text, 0, 0, playdate.display.getWidth() - 20, 600, 5)
    gfx.popContext()
    self.gridviewSprite:setImage(gridviewImage)

    if playdate.buttonIsPressed(playdate.kButtonUp) then
        self.offset += 10

        if self.offset > 0 then
            self.offset = 0
        end
    end

    if playdate.buttonIsPressed(playdate.kButtonDown) then
        self.offset -= 10

        if self.offset < -266 then
            self.offset = -266
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        changeScene(HomeScene)
    end

    gfx.sprite.update()
end

function HelpScene:destroy()
    menu:removeMenuItem(self.menuHome)

    self.gridviewSprite:remove()
end
