function newItemPanel(slot, position, item)
  local itemPanel = newPanel("slot "..slot, position, {w=48, h=48})
  local label, pane

  function itemPanel:init()
    self.item = item
    if item.dataID then
      self.image = item:getImage()
    end
    self.color = {r = 0, g = 0, b = 0, a = 255}
    self.mode = "line"
    label = newLabel("itemQuantity",{x=itemPanel.dimensions.w/2,y=itemPanel.dimensions.h/2},{w=itemPanel.dimensions.w/2,h=itemPanel.dimensions.h/2},  (item.dataID and item.quantity  or  ""),love.graphics.getFont(),"center", "center")
    label.transparent = true
    label.background.color = {r = 0, g = 0, b = 0, a = 100}
    self:addElement(label, "itemQuantity")
  end

  function itemPanel:update()
    if self.item.dataID and self.item.quantity then
      label:setText(self.item.quantity)
      self.image = self.item:getImage()
      label.visible = true
    else
      label.visible = false
      self.image = nil
    end
  end

  itemPanel:init()
  return itemPanel
end
