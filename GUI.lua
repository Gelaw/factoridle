local GUI = {}

function GUI.newGroup()
  local group = {}
  group.elements = {}

  function group:addElement(element)
    table.insert(self.elements, element)
  end

  function group:draw()
    --save current graphics context
    love.graphics.push()
    for n,v in pairs(group.elements) do
      v:draw()
    end
    --set previously saved graphics context
    love.graphics.pop()
  end

  return group
end

local function newElement (x, y)
  local element = {}

  element.x = x
  element.y = y
  element.visible = false

  function element:draw()
    print("newElement / draw / TODO")
  end
  function element:setVisible(visible)
    self.visible = visible
  end

  return element
end

function GUI.newPanel(x,y,w,h)
  local panel = newElement(x, y)
  panel.w = w
  panel.h = h
  panel.image = nil

  function panel:setImage(image)
    self.image = image
    self.w = image:getWidth()
    self.h = image:getHeight()
  end

  function panel:drawPanel()
    love.graphics.setColor(255, 255, 255)
    if self.image == nil then
      love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    else
      love.graphics.draw(self.image, self.x, self.y)
    end
  end

  function panel:draw()
    if panel.visible then
      self:drawPanel()
    end
  end

  return panel
end

function GUI.newText(x,y,w,h,pText, font, horizontalAlign, verticalAlign)
  local text = GUI.newPanel(x, y, w, h)
  text.Text = pText
  text.font = font
  text.TextW = font:getWidth(pText)
  text.TextH = font:getHeight(pText)
  text.horizontalAlign = horizontalAlign
  text.verticalAlign = verticalAlign

  function  text:drawText()
    love.graphics.setColor(255, 0, 0)
    love.graphics.setFont(self.font)
    local x = self.x
    local y = self.y
    if self.horizontalAlign == "center" then
      x = x + ((self.w - self.TextW) / 2)
    end
    if self.verticalAlign == "center" then
      y = y + ((self.y - self.TextH + 20) / 2)
    end
    love.graphics.print(self.Text, x, y)
  end
  function text:draw()
    if self.visible == false then return end
    self:drawText()
  end
  return text
end

return GUI
