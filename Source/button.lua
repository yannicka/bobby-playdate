class('ScreenButton').extends(Object)

local font = playdate.graphics.font.new('img/fonts/whiteglove-stroked')

function ScreenButton:init(text, x, y, padding)
    self.text = text
    self.x = x
    self.y = y
    self.padding = padding
    self.selected = false
    self.finished = false
end

function ScreenButton:render()
    local width, height = playdate.graphics.getTextSize(self.text)

    if self.finished then
        playdate.graphics.setColor(playdate.graphics.kColorBlack)
    else
        playdate.graphics.setColor(playdate.graphics.kColorBlack)
    end

    if self.finished then
        playdate.graphics.fillRoundRect(self.x-self.padding, self.y-self.padding, width+self.padding*2, height+self.padding*2, 8)
    else
        playdate.graphics.drawRoundRect(self.x-self.padding, self.y-self.padding, width+self.padding*2, height+self.padding*2, 8)
    end

    if self.selected then
        playdate.graphics.setLineWidth(2)
        playdate.graphics.drawRoundRect(self.x-self.padding-2, self.y-self.padding-2, width+self.padding*2+4, height+self.padding*2+4, 8)
        playdate.graphics.setLineWidth(1)
    end

    playdate.graphics.drawText(self.text, self.x, self.y)
end
