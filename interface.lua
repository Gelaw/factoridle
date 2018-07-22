local GUI = require "GUI"

local groupTest
local panelInventaire
local panelCaracteristique
local textCaracteristique
local textInventaire
local button

local Interface = {}

function Interface:new()
  local interface = {}
  interface.listGroup = {}

  function interface:init()
    groupTest = GUI.newGroup("i", 100, 100, -1, -1)
    panelInventaire = GUI.newInventoryPanel("Inventaire",0,0,world.inventory)
    groupTest.w = panelInventaire.w
    groupTest.h = panelInventaire.h
    groupTest:addElement(panelInventaire, "Inventaire")
    groupTest.visible = true
    interface:addGroup(groupTest)

    panelInventaire:setEvent("hover", onPanelHover)
    panelInventaire:setEvent("pressed", onButtonClicked)
  end

  function interface:doesTouch(x,y)
    for n,v in pairs(self.listGroup) do
      if v:doesTouch(x, y) then return true end
    end
    return false
  end

  function interface:addGroup(group)
    table.insert(self.listGroup, group)
  end

  function interface:draw()
    for n,v in pairs(self.listGroup) do
      v:draw()
    end
  end

  function interface:update(dt)
    for n,v in pairs(self.listGroup) do
      v:update(dt)
    end
  end

  function interface:keypressed(key, scancode, isrepeat)
    if key == "i" then
      if groupTest.visible == true then
        groupTest:setVisible(false)
      else
        groupTest:setVisible(true)
      end
    end
  end

  function interface:onClick(x, y, button)
    for n,v in pairs(self.listGroup) do
      if v:doesTouch(x,y) then
        v:onClick(x, y, button)
        return
      end
    end
  end

  function interface:onRelease(x, y, button)
    for n,v in pairs(self.listGroup) do
      if v:doesTouch(x,y) then
        v:onRelease(x, y, button)
        return
      end
    end
  end

  function interface:resetClick()
    for n,v in pairs(self.listGroup) do
      v:resetClick()
    end
  end
  return interface
end

return Interface
