
function newGroup(key, position, dimensions)
  local group = {}

  function group:init()
    group.elements = {}
    group.key = key
    group.position = position
    group.dimensions = dimensions
    group.visible = true
    group.movable = true
    if self.position.x == nil then
      error(name.." x is nil!")
    end
    if self.position.y == nil then
      error(name.." y is nil!")
    end
    if self.dimensions.w == nil then
      error(self.name.." w is nil!")
    end
    if self.dimensions.h == nil then
      error(self.name.." h is nil!")
    end
  end

  function group:addElement(element, id)
    if self.elements[id] == nil then
        self.elements[id] = element
        return true
    end
    return false
  end

  function group:getElement(id)
    for eid, element in pairs(self.elements) do
      if eid == id then
        return element
      end
    end
  end

  function group:draw()
    if self.visible then
      for n,v in pairs(self.elements) do
        v:draw(self.position.x, self.position.y, self.dimensions.w, self.dimensions.h, 0, 0)
      end
    end
  end

  function group:update(dt)
    for n,v in pairs(self.elements) do
      v:update(dt)
    end
  end

  function group:setVisible(visible)
    self.visible = visible
  end

  function group:doesTouch(x, y)
    if x> self.position.x and y > self.position.y and x < self.position.x + self.dimensions.w and y<self.position.y + self.dimensions.h and self.visible then
      return true
    end
    return false
  end

  function group:onClick(x, y, pButton)
    for p, panel in pairs(self.elements) do
      if panel:doesTouch(x - self.position.x, y - self.position.y) then
        panel:onClick(x - self.position.x, y - self.position.y, pButton)
        return
      end
    end
    grab.status = "UI"
    grab.ui = self
  end

  function group:mousemoved(x, y, dx, dy)
    if self.movable then
      self.position.x = self.position.x + dx
      self.position.y = self.position.y + dy
    end
  end

  function group:onRelease(x, y, pButton)
    for p, panel in pairs(self.elements) do
      if panel:doesTouch(x - self.position.x, y - self.position.y) then
        panel:onRelease(x - self.position.x, y - self.position.y, pButton)
        return
      end
    end
  end

  function group:resetClick()
    for p, panel in pairs(self.elements) do
      panel:resetClick()
    end
  end

  group:init()
  return group
end
