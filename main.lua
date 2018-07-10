local GUI = require "GUI"
local World = require "world"
local groupTest
local panelInventaire
local panelCaracteristique
local textCaracteristique
local textInventaire
local button

--function needed by Panel:setEvent
function onPanelHover(target)
  print("Mouse is hover: "..target)
end
function onButtonClicked(target)
  print(target.." clicked")
end
--

function love.load()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  posCam = {x = 0, y = 0}
  world = World:new()
  world:init()



  groupTest = GUI.newGroup()
  panelInventaire = GUI.newPanel("Inventaire",width-300,0,300,200)
  groupTest:addElement(panelInventaire)
  panelCaracteristique = GUI.newPanel("Caracteristique",0,0,300,200)
  groupTest:addElement(panelCaracteristique)
  textCaracteristique = GUI.newText("textCaracteristique",0,0,300,200,"Caracteristique",love.graphics.getFont(), "center", "center")
  groupTest:addElement(textCaracteristique)
  textInventaire = GUI.newText("textInventaire",width-300,0,300,200,"Inventaire",love.graphics.getFont(), "center", "center")
  groupTest:addElement(textInventaire)
  button = GUI.newButton("button",width -110,(height /2) -37 ,100,75,"Click",love.graphics.getFont())
  groupTest:addElement(button)

  panelInventaire:setEvent("hover", onPanelHover)
  panelCaracteristique:setEvent("hover", onPanelHover)
  textCaracteristique:setEvent("hover", onPanelHover)
  textInventaire:setEvent("hover", onPanelHover)
  button:setEvent("hover", onPanelHover)
  button:setEvent("pressed", onButtonClicked)
  panelInventaire:setEvent("pressed", onButtonClicked)
  panelCaracteristique:setEvent("pressed", onButtonClicked)
  textCaracteristique:setEvent("pressed", onButtonClicked)
  textInventaire:setEvent("pressed", onButtonClicked)
end


function love.draw()
  love.graphics.setColor(25, 25, 25)
  for x = - posCam.x%50 - 50 ,  width + 50, 50 do
    for y = - posCam.y%50 - 50,  height + 50, 50 do
      love.graphics.rectangle("fill", x -24 , y -24 , 48, 48)
    end
  end
  world:draw(posCam)
  --draw test GUI
  groupTest:draw()

  love.graphics.setColor(255,255,255)

  love.graphics.print("cam: x:" ..posCam.x.." y:"..posCam.y, 30, 30)
  love.graphics.print("mouse: x:" .. love.mouse.getX() -width/2 + posCam.x   .. " y:" ..love.mouse.getY() -height/2 + posCam.y, 30, 50)
  love.graphics.line(width/2, height/2 - 10, width/2, height/2 + 10)
  love.graphics.line(width/2 - 10, height/2, width/2 + 10, height/2)

  love.graphics.print(inventory:prompt(), 30, height / 2)
end

timer = 0
function love.update(dt)
  groupTest:update(dt)
  world:update(dt)
end

handledEntity = nil

function love.mousemoved(x, y, dx, dy)
  if love.mouse.isDown(1) then
    if handledEntity and handledEntity.move then
      handledEntity:move(dx, dy)
    else
      posCam.x = posCam.x - dx
      posCam.y = posCam.y - dy
    end
  end
end

function love.mousepressed(x, y, button, isTouch)
  for e  = 1, #world.entities, 1 do
    if world.entities[e]:doesTouch(x - width/2 + posCam.x, y - height/2 + posCam.y) then
      if handledEntity == nil then
        handledEntity = world.entities[e]
        return
      end
    end
  end

--TODO gestionnaire click GUI
  for n,v in pairs(groupTest.elements) do
    if v.isHover then
      v:onClick(button)
    end
  end
-----
end

function love.mousereleased(x, y, button, isTouch)
  if handledEntity and handledEntity.pos then
    x, y = 0, 0
    if handledEntity.pos.x %50 < 25 then
      x = handledEntity.pos.x - handledEntity.pos.x %50
    else
      x = handledEntity.pos.x - handledEntity.pos.x %50 + 50
    end
    if handledEntity.pos.y %50 < 25 then
      y = handledEntity.pos.y - handledEntity.pos.y %50
    else
      y = handledEntity.pos.y - handledEntity.pos.y %50 + 50
    end
    isfree = isFree(x, y, handledEntity)
    while isfree==false do
      x  = x + 50
      isfree = isFree(x, y, handledEntity)
    end
    handledEntity.pos.x = x
    handledEntity.pos.y = y
    handledEntity = nil
  end
  for n,v in pairs(groupTest.elements) do
      v:onRelease(button)
  end

end

function love.keypressed(key, scancode, isrepeat)
  if key == "i" then
    if panelInventaire.visible == true then
      panelInventaire:setVisible(false)
      textInventaire:setVisible(false)

    else
      panelInventaire:setVisible(true)
      textInventaire:setVisible(true)
    end
  end
  if key == "c" then
    if panelCaracteristique.visible == true then
      panelCaracteristique:setVisible(false)
      textCaracteristique:setVisible(false)
    else
      panelCaracteristique:setVisible(true)
      textCaracteristique:setVisible(true)
    end
  end
  if key ==  "r" then
    inventory:removeSlot(1)
  end

  --fonction onHover()

end
