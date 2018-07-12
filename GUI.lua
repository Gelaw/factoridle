local GUI = {}

function GUI.newGroup(key)
  local group = {}
  group.elements = {}
  group.key = {}

  function group:addElement(element)
    table.insert(self.elements, element)
  end

  function group:draw()
    --save current graphics context
    --love.graphics.push()
    for n,v in pairs(group.elements) do
      v:draw()
    end
    --set previously saved graphics context
    --love.graphics.pop()
  end
  function group:update(dt)
    for n,v in pairs(group.elements) do
      v:update(dt)
    end
  end
  return group
end

local function newElement(name, x, y)
  local element = {}

  element.x = x
  element.y = y
  element.visible = false
  element.name = name
  function element:draw()
    print("newElement / draw / TODO")
  end
  function element:setVisible(visible)
    self.visible = visible
  end
  function element:update(dt)
  end

  function element:onClick(pButton)
  end
  function element:onRelease(pButton)
  end

  return element
end

function GUI.newPanel(name,x,y,w,h)
  local panel = newElement(name,x, y)
  panel.w = w
  panel.h = h
  panel.image = nil
  panel.isHover = false
  panel.listEvents = {}

  function panel:setImage(image)
    self.image = image
    self.w = image:getWidth()
    self.h = image:getHeight()
  end

  function panel:setEvent(eventType, pFunction)
    self.listEvents[eventType] = pFunction
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
  function panel:update(dt)
   self:updatePanel()
  end
  function panel:hover()
    local mx, my = love.mouse.getPosition()
    if mx > self.x and mx < self.x + self.w and
      my > self.y and my < self.y + self.h then
        if self.isHover == false then
          self.isHover = true
          if self.listEvents["hover"] ~= nil and self.visible == true then
            self.listEvents["hover"](self)
          end
        end
    else
      if self.isHover == true then
        self.isHover = false
      end
    end

  end
  function panel:onClick(pButton)
    if self.isHover and self.visible then
      self.listEvents["pressed"](self)
    end
  end
  function panel:updatePanel(dt)
    self:hover()
  end

  return panel
end

function GUI.newText(name,x,y,w,h,pText, font, horizontalAlign, verticalAlign)
  local text = GUI.newPanel(name,x, y, w, h)
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
  function text:update(dt)
  end
  function text:updateText(dt)
  end
  return text
end

function GUI.newButton(name,x,y,w,h,pText,font)
  local button = GUI.newPanel(name,x, y, w, h)
  button.Text = pText
  button.font = font
  button.label = GUI.newText(name,x, y - h, w, h, pText, font, "center", "center")
  button.isPressed = false
  button.oldButtonState = false
  button.visible = true

  function button:draw()
    if self.isPressed then
      self:drawPanel()
      love.graphics.setColor(50,50,255,100)
      love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    elseif self.isHover then
      self:drawPanel()
      love.graphics.setColor(255,0,255)
      love.graphics.rectangle("line",self.x+2, self.y+2, self.w-4, self.h-4)
    else
          self:drawPanel()
    end
    love.graphics.setColor(255, 0, 0)
    self.label.visible = true
    self.label:draw()
    love.graphics.setColor(255, 255, 255)

  end

  function button:onClick(pButton)
    if self.isHover and pButton == 1 and
        self.isPressed == false and
        self.oldButtonState == false then
      self.isPressed = true
      if self.listEvents["pressed"] ~= nil then
        self.listEvents["pressed"](self)
      end
    end
    self.oldButtonState = true
  end

  function button:onRelease(pButton)

    if self.isPressed == true and pButton == 1 then
      self.isPressed = false
    end
    if self.isHover == false then
      self.isPressed = false
    end
    self.oldButtonState = false

  end
  function button:update(dt)
    self:updatePanel()
  end

  return button
end

return GUI
