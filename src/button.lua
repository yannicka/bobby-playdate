local gfx <const> = playdate.graphics

class('ScreenButton').extends(Object)

function ScreenButton:init(text, x, y, padding)
    self.text = text
    self.x = x
    self.y = y
    self.padding = padding
    self.selected = false
    self.finished = false
end

function ScreenButton:render()
    gfx.setLineWidth(1)

    local width, height = gfx.getTextSize(self.text)

    gfx.drawRoundRect(
        self.x - self.padding,
        self.y - self.padding,
        width + (self.padding * 2),
        height + (self.padding * 2),
        8
    )

    if self.selected then
        gfx.setLineWidth(2)
        gfx.drawRoundRect(
            self.x - self.padding - 3,
            self.y - self.padding - 3,
            width + (self.padding * 2) + 6,
            height + (self.padding * 2) + 6,
            11
        )
    end

    gfx.drawText(self.text, self.x, self.y)
end
