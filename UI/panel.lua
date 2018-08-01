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

  function panel:draw(xParent, yParent, wParent, hParent, xoffset, yoffset)
    if not self.visible then return end
    if self.dimensions.shape == nil or self.dimensions.shape == "rect" then
    local sx = self.position.x - xoffset
    local sy = self.position.y - yoffset
    if sx > wParent or
       sy > hParent or
       sx < -self.dimensions.w or
       sy < -self.dimensions.h then
      return
    end

    if self.position.x + self.dimensions.w < xoffset or
      self.position.y + self.dimensions.h < yoffset then
      return
    end

    local x, y, w, h = 0,0,0,0

    if sy< 0 and self.position.y-yoffset + self.dimensions.h > hParent then
      y = yParent
      h = hParent
    elseif sy< 0 then
      y = yParent
      h = self.dimensions.h + sy
    elseif sy + self.dimensions.h > hParent then
      y = yParent + sy
      h = hParent - sy
    else
      y = yParent + sy
      h = self.dimensions.h
    end

    if sx< 0 and self.position.x-xoffset + self.dimensions.w > wParent then
      x = xParent
      w = wParent
    elseif sx< 0 then
      x = xParent
      w = self.dimensions.w + sx
    elseif sx + self.dimensions.w > wParent then
      x = xParent + sx
      w = wParent - sx
    else
      x = xParent + sx
      w = self.dimensions.w
    end

    if self.image == nil then
      love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
      love.graphics.rectangle(self.mode, x, y, w, h)
    else
      love.graphics.setColor(255,255,255)
      love.graphics.draw(self.image, x, y, 0, 1, 1, xoffset, yoffset)
    end
    for n,v in pairs(self.elements) do
      v:draw(x, y, w, h, sx <0 and -sx or 0, sy<0 and - sy or 0)
      end
    elseif self.dimensions.shape == "circle" then
      if self.image == nil then
        love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
        love.graphics.rectangle(self.mode, x, y, w, h)
        love.graphics.circle(self.mode, x, y, self.dimensions.r)
      else
        love.graphics.setColor(255,255,255)
        love.graphics.draw(self.image, x, y, 0, 1, 1, xoffset, yoffset)
      end
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
    if x> self.position.x and y > self.position.y
        and x < self.position.x + self.dimensions.w
        and y<self.position.y + self.dimensions.h and self.transparent == false then
      return true
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
