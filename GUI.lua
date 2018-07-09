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
      love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
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

return GUI
