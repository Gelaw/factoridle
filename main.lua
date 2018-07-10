local Entity = require "entity"
local Inventory = require "inventory"
local Item = require "item"
local GUI = require "GUI"
entities = {}
local groupTest
local panelTest1
local panelTest2
local textTest1
local textTest2
local button

function love.load()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  posCam = {x = 0, y = 0}
  entities[1] = Entity:new()
  entities[1]:init({x = 200, y = 200})

  entities[2] = Entity:new()
  entities[2]:init({x = 300, y = 300})

  inventory = Inventory:new()
  inventory:init(20)

  groupTest = GUI.newGroup()
  panelTest1 = GUI.newPanel(width-300,0,300,200)
  groupTest:addElement(panelTest1)
  panelTest2 = GUI.newPanel(0,0,300,200)
  groupTest:addElement(panelTest2)
  textTest2 = GUI.newText(0,0,300,200,"Caracteristique",love.graphics.getFont(), "center", "center")
  groupTest:addElement(textTest2)
  textTest1 = GUI.newText(width-300,0,300,200,"Inventaire",love.graphics.getFont(), "center", "center")
  groupTest:addElement(textTest1)
  button = GUI.newButton(width -110,(height /2) -37 ,100,75,"Click",love.graphics.getFont())
  groupTest:addElement(button)
end


function love.draw()
  love.graphics.setColor(25, 25, 25)
  for x = - posCam.x%50 - 50 ,  width, 50 do
    for y = - posCam.y%50 - 50,  height, 50 do
      love.graphics.rectangle("fill", x +1 , y +1 , 48, 48)
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

  love.graphics.print(inventory:prompt(), 30, height / 2)
  groupTest:draw()
end
timer = 0
function love.update(dt)
  groupTest:update(dt)
  timer = timer + dt
  if timer > 1 then
    timer = 0
    item = Item:new()
    item:init(math.floor((#Item.stereotypes - 1) * love.math.random() + 2), 1)
    inventory:add(item)
  end
end

function testmove(entity, dx, dy)
  for e  = 1, #entities, 1 do
    if entity ~= entities[e]
      and (entities[e]:doesTouch(entity.pos.x + dx - entity.dim.width / 2 + 1, entity.pos.y + dy - entity.dim.height / 2 + 1)
        or entities[e]:doesTouch(entity.pos.x + dx + entity.dim.width / 2 - 1, entity.pos.y + dy + entity.dim.height / 2 - 1)
        or entities[e]:doesTouch(entity.pos.x + dx + entity.dim.width / 2 - 1, entity.pos.y + dy - entity.dim.height / 2 + 1)
        or entities[e]:doesTouch(entity.pos.x + dx - entity.dim.width / 2 + 1, entity.pos.y + dy + entity.dim.height / 2 - 1)) then
        return
    end
  end
  entity:move(dx, dy)
end

handledEntity = {}

function love.mousemoved(x, y, dx, dy)
  if love.mouse.isDown(1) then
    if handledEntity and handledEntity.move then
      testmove(handledEntity, dx,dy)
    else
      posCam.x = posCam.x - dx
      posCam.y = posCam.y - dy
    end
  end
end

function love.mousepressed(x, y, button, isTouch)
  for e  = 1, #entities, 1 do
    if entities[e]:doesTouch(x - width/2 + posCam.x, y - height/2 + posCam.y) then
      if handledEntity == nil then
        handledEntity = entities[e]
        return
      end
    end
  end
end

function love.mousereleased(x, y, button, isTouch)
  if handledEntity then
    handledEntity = nil
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "i" then
    if panelTest1.visible == true then
      panelTest1:setVisible(false)
      textTest1:setVisible(false)

    else
      panelTest1:setVisible(true)
      textTest1:setVisible(true)
    end
  end
  if key == "c" then
    if panelTest2.visible == true then
      panelTest2:setVisible(false)
      textTest2:setVisible(false)
    else
      panelTest2:setVisible(true)
      textTest2:setVisible(true)
    end
  end
  if key ==  "r" then
    inventory:removeSlot(1)
  end
end
