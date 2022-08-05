import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

class('Button').extends(Object)

local font = playdate.graphics.font.new('img/fonts/whiteglove-stroked')

function Button:init(text, x, y, padding)
    self.text = text
    self.x = x
    self.y = y
    self.padding = padding
    self.selected = false
end

function Button:render()
    local width, height = playdate.graphics.getTextSize(self.text)

    playdate.graphics.setDrawOffset(0, 0)

    if self.selected then
        playdate.graphics.setLineWidth(4)
    else
        playdate.graphics.setLineWidth(1)
    end

    playdate.graphics.drawRoundRect(self.x-self.padding, self.y-self.padding, width+self.padding*2, height+self.padding*2, 8) 
    playdate.graphics.drawText(self.text, self.x, self.y)
end
