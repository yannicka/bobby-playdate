import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

class('ScreenButton').extends(Object)

local font = playdate.graphics.font.new('img/fonts/whiteglove-stroked')

function ScreenButton:init(text, x, y, padding)
    self.text = text
    self.x = x
    self.y = y
    self.padding = padding
    self.selected = false
end

function ScreenButton:render()
    local width, height = playdate.graphics.getTextSize(self.text)

    playdate.graphics.setColor(playdate.graphics.kColorBlack)

    if self.selected then
        playdate.graphics.setLineWidth(4)
    else
        playdate.graphics.setLineWidth(1)
    end

    playdate.graphics.drawRoundRect(self.x-self.padding, self.y-self.padding, width+self.padding*2, height+self.padding*2, 8) 
    playdate.graphics.drawText(self.text, self.x, self.y)
end
