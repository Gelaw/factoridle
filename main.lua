--Require
local GUI = require "GUI"
local World = require "world"
local Interface = require "interface"

--
local interface
--
--function needed by Panel:setEvent
function onPanelHover(target)
  print("Mouse is hover: "..target.name)
end
function onButtonClicked(target)
  print(target.name .." clicked")
end
--

function love.load()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  world = World:new()

  interface = Interface:new()
  interface:init()

  interface:addGroup(groupTest)
end


function love.draw()
  world:draw()

  interface:draw()

  love.graphics.setColor(255,255,255)

end

function love.update(dt)
  interface:update(dt)
  world:update(dt)
end

function love.mousemoved(x, y, dx, dy)
  world:mousemoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button, isTouch)
  world:mousepressed(x, y, button, isTouch)

--TODO gestionnaire click GUI
  for n,v in pairs(interface.listGroup) do
    for i,u in pairs(v.elements) do
      if u.isHover then
        u:onClick(button)
      end
    end
  end
-----
end

function love.mousereleased(x, y, button, isTouch)
  world:mousereleased(x, y, button, isTouch)

  for n,v in pairs(interface.listGroup) do
    for i,u in pairs(v.elements) do
        u:onRelease(button)
    end
  end

end

function love.keypressed(key, scancode, isrepeat)
  interface:keypressed(key,scancode,isrepeat)
  if key ==  "t" then
    world:initTreeGeneration()
  end
end
