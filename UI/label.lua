function newLabel(name,position,dimensions,pText, font, horizontalAlign, verticalAlign)
  local label = newPanel(name, position, dimensions)

  function label:init()
    self.Text = pText
    self.font = font
    self.TextW = font:getWidth(pText)
    self.TextH = font:getHeight(pText)
    self.horizontalAlign = horizontalAlign
    self.verticalAlign = verticalAlign
    self.color = {r = 255, g = 255, b = 255}
    self.background = newPanel("fond", {x=0, y = 0}, dimensions)
    self.background.color = {r = 0, g = 0, b = 0, a = 0}
    self.background.transparent = true
  end

  function label:draw(xParent, yParent, myStencilFunction, masknumber)
    if self.visible == false then return end
    love.graphics.setColor(self.background.color.r, self.background.color.g, self.background.color.b, self.background.color.a)
    self.background:draw(xParent + self.position.x, yParent + self.position.y, myStencilFunction, masknumber)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.setFont(self.font)
    local x = self.position.x + xParent
    local y = self.position.y + yParent
    if self.horizontalAlign == "center" then
      x = x + ((self.dimensions.w - self.TextW) / 2)
    end
    if self.verticalAlign == "center" then
      y = y + ((self.dimensions.h - self.TextH) / 2)
    end
    love.graphics.print(self.Text, x, y)
  end

  function label:setText(ptext)
    self.Text = ptext
    self.TextW = font:getWidth(ptext)
    self.TextH = font:getHeight(ptext)
  end

  label:init()
  return label
end
