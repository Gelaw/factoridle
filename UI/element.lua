function newElement(name, position)
  local element = {}

  function element:init()
    self.position = position
    self.visible = true
    self.name = name
    if self.position.x == nil then
      error(name.." x is nil!")
    end
    if self.position.y == nil then
      error(name.." y is nil!")
    end
  end

  function element:draw(xParent, yParent)
    print("newElement / draw / TODO")
  end

  function element:update(dt)

  end

  element:init()
  return element
end
