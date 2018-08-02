function newPanel(name,position,dimensions)
  local panel = newElement(name,position)

  function panel:init()
    self.dimensions = dimensions
    self.image = nil
    self.elements = {}
    self.color = {r = 255, g = 255, b = 255, a = 255}
    self.transparent = false
    self.mode = "fill"
    if self.dimensions.shape == nil or self.dimensions.shape == "rect" then
      if self.dimensions.w == nil then
        error(self.name.." w is nil!")
      end
      if self.dimensions.h == nil then
        error(self.name.." h is nil!")
      end
    elseif self.dimensions.shape == "circle" then
      if self.dimensions.r == nil then
        error(self.name.." r is nil!")
      end
    else
      error(self.name .." has unknown shape!")
    end
  end

  function panel:addElement(element, id)
    if self.elements[id] == nil then
        self.elements[id] = element
        return true
    end
    return false
  end

  function panel:getElement(id)
    for eid, element in pairs(self.elements) do
      if eid == id then
        return element
      end
    end
  end

  function panel:draw(xParent, yParent, stencilFunction, masknumber)
    if not self.visible then return end
    local myStencilFunction = function ()
      stencilFunction()
      if self.dimensions.shape == "rect" or self.dimensions.shape == nil then
        love.graphics.rectangle("fill", self.position.x + xParent -1, self.position.y + yParent-1, self.dimensions.w+2, self.dimensions.h+2)
      elseif self.dimensions.shape == "circle" then
        love.graphics.circle("fill", self.position.x + xParent, self.position.y + yParent, self.dimensions.r+1)
      end
    end
    love.graphics.stencil(myStencilFunction, "increment")
    love.graphics.setStencilTest("equal", masknumber +1)
    if self.image == nil then
      love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
      if self.dimensions.shape == "rect" or self.dimensions.shape == nil then
        love.graphics.rectangle(self.mode, self.position.x + xParent, self.position.y + yParent, self.dimensions.w, self.dimensions.h)
      elseif self.dimensions.shape == "circle" then
        love.graphics.circle(self.mode, self.position.x + xParent, self.position.y + yParent, self.dimensions.r)
      end
    else
      love.graphics.setColor(255,255,255)
      if self.dimensions.shape == "rect" or self.dimensions.shape == nil then
        love.graphics.draw(self.image, self.position.x + xParent, self.position.y + yParent)
      elseif self.dimensions.shape == "circle" then
        love.graphics.draw(self.image, self.position.x - self.dimensions.r, self.position.y- self.dimensions.r)
      end
    end
    love.graphics.setStencilTest()
    for n,v in pairs(self.elements) do
      v:draw(self.position.x + xParent,  self.position.y + yParent, myStencilFunction, masknumber + 1)
    end
  end

  function panel:update(dt)
    for n,v in pairs(self.elements) do
      v:update(dt)
    end
  end

  function panel:resetClick()
    for p, v in pairs(self.elements) do
      v:resetClick()
    end
  end

  function panel:doesTouch(x, y)
    for p, v in pairs(self.elements) do
      if v:doesTouch(x - self.position.x, y - self.position.y) then
        return true
      end
    end
    if self.dimensions.shape == "rect" or self.dimensions.shape == nil then
      if x> self.position.x and y > self.position.y
          and x < self.position.x + self.dimensions.w
          and y<self.position.y + self.dimensions.h and self.transparent == false then
        return true
      end
    elseif self.dimensions.shape == "circle" then
      if math.sqrt((x - self.position.x)*(x - self.position.x) + (y - self.position.y)*(y - self.position.y)) < self.dimensions.r then
        return true
      end
    end
    return false
  end

  function panel:onClick(x, y, pButton)
    for p, v in pairs(self.elements) do
      if v:doesTouch(x - self.position.x, y - self.position.y) then
        v:onClick(x - self.position.x, y - self.position.y, pButton)
        return
      end
    end
  end

  function panel:onRelease(x, y, pButton)
    for p, v in pairs(self.elements) do
      if v:doesTouch(x - self.position.x, y - self.position.y) then
        v:onRelease(x - self.position.x, y - self.position.y, pButton)
        return
      end
    end
  end

  function panel:resetClick()
    for n, v in pairs(self.elements) do
      v:resetClick()
    end
  end

  panel:init()
  return panel
end
