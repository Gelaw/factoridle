local GUI = require "GUI"

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
    PRG = GUI.newRessourceGeneratorPanel(ressourceGenerator,0,0)
    RG = GUI.newGroup(ressourceGenerator:getName(), 100, 100, PRG.w,  PRG.h + 50)
    RG:addElement(PRG, ressourceGenerator:getName())
    RG.visible = false
    interface:addGroup(RG, ressourceGenerator:getName())
  end

  function interface:addGroupMachine(machine)
    PM = GUI.newMachinePanel(machine,0,0)
    M = GUI.newGroup(machine:getName(), 100, 100, PM.w,PM.h + 50)
    M:addElement(PM, machine:getName())
    M.visible = false
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
