

function newText(name,position,dimensions,pText, font, horizontalAlign, verticalAlign)
  local text = newPanel(name, position, dimensions)

  function text:init()
    self.Text = pText
    self.font = font
    self.TextW = font:getWidth(pText)
    self.TextH = font:getHeight(pText)
    self.horizontalAlign = horizontalAlign
    self.verticalAlign = verticalAlign
    self.color = {r = 255, g = 255, b = 255}
  end

  function text:draw(xParent, yParent)
    love.graphics.setColor(text.color.r, text.color.g, text.color.b)
    love.graphics.setFont(self.font)
    local x = self.position.x + xParent
    local y = self.position.y + yParent
    if self.horizontalAlign == "center" then
      x = x + ((text.dimensions.w - self.TextW) / 2)
    end
    if self.verticalAlign == "center" then
      y = y + ((self.dimensions.h - self.TextH) / 2)
    end
    love.graphics.print(self.Text, x, y)
  end

  function text:setText(ptext)
    text.Text = ptext
    text.TextW = font:getWidth(ptext)
    text.TextH = font:getHeight(ptext)
  end

  text:init()
  return text
end
