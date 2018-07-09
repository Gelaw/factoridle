local Entity = require "entity"
entities = {}
inventory = {}

function love.load()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  posCam = {x = 0, y = 0}
  posMouse = {x = width/2 - love.mouse.getX() , y = height/2 - love.mouse.getY()}
  entities[1] = Entity:new()
  entities[1]:init({x = 200, y = 200})

  entities[2] = Entity:new()
  entities[2]:init({x = 300, y = 300})
end


function love.draw()
  love.graphics.setColor(25, 25, 25)
  for x = - posCam.x%50 - 50 ,  width, 50 do
    for y = - posCam.y%50 - 50,  height, 50 do
      love.graphics.rectangle("fill", x + 1, y + 1, 48, 48)
    end
  end
  for e  = 1, #entities, 1 do
    entities[e]:draw(posCam)
  end
  love.graphics.setColor(255,255,255)
  love.graphics.print("cam: x:" ..posCam.x.." y:"..posCam.y, 30, 30)
  love.graphics.print("mouse: x:" .. love.mouse.getX() -width/2 + posCam.x   .. " y:" ..love.mouse.getY() -height/2 + posCam.y, 30, 50)
  love.graphics.line(width/2, height/2 - 10, width/2, height/2 + 10)
  love.graphics.line(width/2 - 10, height/2, width/2 + 10, height/2)
end

function love.update(dt)

end

focus = {}

function love.mousemoved(x, y, dx, dy)
  if love.mouse.isDown(1) then
    if focus and focus.move then
      print(" ")
      focus:move(dx,dy)
    else
      posCam.x = posCam.x - dx
      posCam.y = posCam.y - dy
    end
  end
end

function love.mousepressed(x, y, button, isTouch)
  for e  = 1, #entities, 1 do
    if entities[e]:doesTouch(x - width/2 + posCam.x, y - height/2 + posCam.y) then
      if focus == nil then
        focus = entities[e]
        return
      end
    end
  end
end

function love.mousereleased(x, y, button, isTouch)
  if focus then
    focus = nil
  end
end
