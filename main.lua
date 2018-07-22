--Require
local GUI = require "GUI"
local World = require "world"
local Interface = require "interface"

grab = {}
grab.status = nil

local interface


function love.load()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  world = World:new()

  interface = Interface:new()
  interface:init()

end


function love.draw()
  world:draw()
  interface:draw()
  if grab.status == "entity" then
    grab.entity:drawTo(love.mouse.getX(), love.mouse.getY())
  elseif grab.status == "item" and grab.item then
    grab.item:drawTo(love.mouse.getX(), love.mouse.getY())
  end
end

function love.update(dt)
  interface:update(dt)
  world:update(dt)
end

function love.mousemoved(x, y, dx, dy)
  if grab.status == "UI" then
    if grab.ui.mousemoved then
      grab.ui:mousemoved(x, y, dx, dy)
    end
    return
  end
  if grab.status == nil then
    world:mousemoved(x, y, dx, dy)
  end
end

function love.mousepressed(x, y, button, isTouch)
  if interface:doesTouch(x, y) then
    interface:onClick(x, y, button)
    return
  end
  world:mousepressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
  if interface:doesTouch(x, y) then
    interface:onRelease(x, y, button)
    resetClick()
    return
  end
  world:mousereleased(x, y, button, isTouch)
  resetClick()
end

function love.keypressed(key, scancode, isrepeat)
  interface:keypressed(key,scancode,isrepeat)
  if key ==  "t" then
    world:initTreeGeneration()
  end
end

function resetClick()
  world:resetClick()
  interface:resetClick()
  grab = {}
end
