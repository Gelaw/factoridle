local GUI = require "UI.GUI"

local Inventaire
local panelInventaire
local panelCaracteristique
local textCaracteristique
local textInventaire
local button

local Interface = {}

function Interface.new()
  local interface = {}
  interface.listGroup = {}

  function interface:init()
    Inventaire = GUI.newPlayerGroup(world.player)
    interface:addGroup(Inventaire, "Inventaire")
  end

  function interface:doesTouch(x,y)
    for n,v in pairs(self.listGroup) do
      if v:doesTouch(x, y) then return true end
    end
    return false
  end

  function interface:addGroup(group, name)
    if self.listGroup then
      if self.listGroup[name] == nil then
        self.listGroup[name] = group
        return true
      end
    end
    return false
  end

  function interface:getGroup(name)
    return self.listGroup[name]
  end

  function interface:toggle(name)
    if self:getGroup(name) then
      self:getGroup(name).visible = not self:getGroup(name).visible
    end
  end

  function interface:addGroupRG(ressourceGenerator)
    local PRG = GUI.newRessourceGeneratorPanel(ressourceGenerator,{x=0,y=0})
    local RG = newGroup(ressourceGenerator:getName(), {x=100, y=100}, {w=PRG.dimensions.w, h= PRG.dimensions.h + 50})
    RG:addElement(PRG, ressourceGenerator:getName())
    RG.visible = false
    local quitbutton = GUI.newButton("quit", {x=RG.dimensions.w - 35, y=5}, {w=30, h=30}, "X", love.graphics.getFont(), "center", "center")
    quitbutton.actionPerformed = function()
      RG.visible = false
    end
    quitbutton.color = {r = 240, g = 0, b = 0}
    PRG:addElement(quitbutton, "quit")
    interface:addGroup(RG, ressourceGenerator:getName())
  end

  function interface:addGroupMachine(machine)
    local PM = GUI.newMachinePanel(machine,{x=0,y=0})
    local M = newGroup(machine:getName(), {x=100, y=100}, {w=PM.dimensions.w,h=PM.dimensions.h + 50})
    M:addElement(PM, machine:getName())
    M.visible = false
    local quitbutton = GUI.newButton("quit", {x=M.dimensions.w - 35,y= 5}, {w=30, h=30}, "X", love.graphics.getFont(), "center", "center")
    quitbutton.actionPerformed = function()
      M.visible = false
    end
    quitbutton.color = {r = 240, g = 30, b = 30}
    PM:addElement(quitbutton, "quit")
    interface:addGroup(M, machine:getName())
  end

  function interface:removeGroup(groupname)
    self.listGroup[groupname] = nil
  end

  function interface:draw()
    for n, v in pairs(self.listGroup) do
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
      Inventaire:toggle()
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
