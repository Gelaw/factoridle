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
function test()
  for n,v in pairs(interface.listGroup) do
    for i,u in pairs(v.elements) do
      if u.isHover == true or u.isPressed then
        return true
      end
    end
  end
  return false
end
function love.mousemoved(x, y, dx, dy)
  -- if math.abs(dx) < 2 and math.abs(dy) < 2 then
  --   return
  -- end
  if test() == true then
  else
    world:mousemoved(x, y, dx, dy)
  end
end

function love.mousepressed(x, y, button, isTouch)
    interface:onClick(button)
    world:mousepressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
  world:mousereleased(x, y, button, isTouch)

  interface:onRelease(button)

end

function love.keypressed(key, scancode, isrepeat)
  interface:keypressed(key,scancode,isrepeat)
  if key ==  "t" then
    world:initTreeGeneration()
  end
end
