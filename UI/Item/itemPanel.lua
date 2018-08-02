function newItemPanel(slot, position, item)
  local itemPanel = newPanel("slot "..slot, position, {w=48, h=48})
  local textPane, pane

  function itemPanel:init()
    self.item = item
    if item.dataID then
      self.image = item:getImage()
    end
    self.color = {r = 0, g = 200, b = 255, a = 100}

    textPane = newText("itemQuantity",{x=itemPanel.dimensions.w/2,y=itemPanel.dimensions.h/2},{w=itemPanel.dimensions.w/2,h=itemPanel.dimensions.h/2},  (item.dataID and item.quantity  or  ""),love.graphics.getFont(),"center", "center")
    pane = newPanel("panelquantity", {x=itemPanel.dimensions.w/2,y=itemPanel.dimensions.h/2},{w=itemPanel.dimensions.w/2,h=itemPanel.dimensions.h/2})
    pane.color = {r = 10, g = 10, b = 10, a = 100}
    pane.transparent = true
    textPane.transparent = true
    self:addElement(pane, "panelquantity")
    self:addElement(textPane, "itemQuantity")
  end

  function itemPanel:update()
    if self.item.dataID and self.item.quantity then
      self:getElement("itemQuantity"):setText(self.item.quantity)
      self.image = self.item:getImage()
      self.visible = true
    else
      self:getElement("itemQuantity"):setText("")
      self.image = nil
      self.visible = false
    end
  end

  function itemPanel:onClick(x, y, button)
    self.color.a = 50
  end

  function itemPanel:resetClick()
    self.color.a = 100
  end
  itemPanel:init()
  return itemPanel
end
