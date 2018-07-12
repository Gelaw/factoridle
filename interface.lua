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
    groupTest = GUI.newGroup("i")
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

    interface:addGroup(groupTest)
  end

  function interface:addGroup(group)
    table.insert(self.listGroup, group)
  end

  function interface:draw()
    for n,v in pairs(self.listGroup) do
      for i,u in pairs(v.elements) do
        u:draw()
      end
    end
  end

  function interface:update(dt)
    for n,v in pairs(self.listGroup) do
      for i,u in pairs(v.elements) do
        u:update(dt)
      end
    end
  end

  function interface:keypressed(key, scancode, isrepeat)
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
  end


  return interface
end

return Interface
