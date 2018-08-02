function newButton(name,position,dimensions,pText,font)
  local button = newPanel(name,position,dimensions)
  local pressedStatePanel, label

  function button:init()
    self.transparent = false
    self.color = {r = 240, g = 240, b = 240}
    self.Text = pText
    if font then
      self.font = font
    else
      self.font = love.graphics.getFont()
    end
    if self.dimensions.shape == "rect" or self.dimensions.shape == nil then
      pressedStatePanel= newPanel("pressed", {x=dimensions.w /10,y= dimensions.h/10},{w=8*dimensions.w/10, h=8*dimensions.h/10})
       label = newText(name, {x=0, y=0}, {w=dimensions.w, h=dimensions.h}, pText, font, "center", "center")
    elseif dimensions.shape == "circle" then
      pressedStatePanel= newPanel("pressed", {x=0,y=0},{shape="circle", r=8*dimensions.r/10})
      label = newText(name, {x=-dimensions.r, y=-dimensions.r}, {w=dimensions.r*2, h=dimensions.r*2}, pText, font, "center", "center")
    end

    self:addElement(label, "label")
    label.transparent = true

    pressedStatePanel.transparent = true
    pressedStatePanel.color = {r = 0, g = 0, b = 0}
    pressedStatePanel.visible = false
    pressedStatePanel.mode = "line"
    self:addElement(pressedStatePanel, "pressedStatePanel")

    self.actionPerformed = nil
  end

  function button:onClick(x, y , pButton)
    pressedStatePanel.visible = true
    grab.status = "UI"
    grab.ui = self
  end

  function button:onRelease(x, y, pButton)
   if pressedStatePanel.visible then
    pressedStatePanel.visible = false
    if self.actionPerformed then
      self.actionPerformed()
    end
   end
  end

  function button:resetClick()
    pressedStatePanel.visible = false
  end

  button:init()
  return button
end
