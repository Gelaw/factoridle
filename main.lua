--Require
local GUI = require "GUI"
local World = require "world"
local Interface = require "interface"

--image
local titleScreen = love.graphics.newImage("sprite/titleScreen.png")
local titleCursor = love.graphics.newImage("sprite/cursor.png")

grab = {}
grab.status = nil

--Current gameScreen
local gameScreen = "menu"
local cursorPosition = "credits"
local cursorIsVisible = true
local timer = 0

function love.load()
  love.window.setFullscreen( true )
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()

  interface = Interface.new()
  world = World.new()
  interface:init()
end


  function love.draw()
    if gameScreen == "menu" then
      love.graphics.draw(titleScreen, 0, -10, 0, 1.8, 1.7)
      if cursorIsVisible then
        if cursorPosition == "play" then
          love.graphics.draw(titleCursor, width/2 - 200, height/3 + 20, 0, 1.5, 1.5)
        elseif cursorPosition == "howTo" then
          love.graphics.draw(titleCursor, width/2 - 200, height/2 + 60, 0, 1.5, 1.5)
        elseif cursorPosition == "credits" then
          love.graphics.draw(titleCursor, width/2 - 200, height -150, 0, 1.5, 1.5)
        end
      end
      return
    elseif gameScreen == "game" then
      world:draw()
      interface:draw()
      if grab.status == "entity" then
        grab.entity:drawTo(love.mouse.getX(), love.mouse.getY())
      elseif grab.status == "item" and grab.item then
        grab.item:drawTo(love.mouse.getX(), love.mouse.getY())
      end
    end
  end

  function love.update(dt)

    if gameScreen == "menu" then
      timer = timer + dt
      if cursorIsVisible and timer > 0.5  then
        cursorIsVisible = false
        timer = 0
      elseif not cursorIsVisible and timer > 0.2 then
        cursorIsVisible = true
        timer = 0
      end
      return
    end
    interface:update(dt)
    world:update(dt)
  end

  function love.mousemoved(x, y, dx, dy)
    if gameScreen == "menu" then
      if x > width/2 - 200 and x < 1000 then
        if y > height/3 + 20 and y < height/3 + 120 then
          cursorPosition = "play"
        elseif y > height/2 + 60 and y < height/2 + 160 then
          cursorPosition = "howTo"
        elseif y > height - 150 and y < height - 50 then
          cursorPosition = "credits"
        end
      end
      return
    end
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
    if gameScreen == "menu" then
      if button == 1 and cursorPosition == "play" then
        gameScreen = "game"
      end
      return
    end
    if interface:doesTouch(x, y) then
      interface:onClick(x, y, button)
      return
    end
    world:mousepressed(x, y, button, isTouch)
  end

  function love.mousereleased(x, y, button, isTouch)
    if gameScreen == "menu" then
      return
    end
    if interface:doesTouch(x, y) then
      interface:onRelease(x, y, button)
      resetClick()
      return
    end
    world:mousereleased(x, y, button, isTouch)
    resetClick()
  end

  function love.keypressed(key, scancode, isrepeat)
    if gameScreen == "menu" then
      return
    end
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
