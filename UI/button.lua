function newButton(name,position,dimensions,pText,font)
  local button = newPanel(name,position,dimensions)
  local pressedStatePanel, label, timerPanel, inactivePanel

  function button:init()
    self.transparent = false
    self.color = {r = 240, g = 240, b = 240, a = 255}
    self.Text = pText
    if font then
      self.font = font
    else
      self.font = love.graphics.getFont()
    end
    if self.dimensions.shape == "rect" or self.dimensions.shape == nil then
      pressedStatePanel= newPanel("pressed", {x=dimensions.w /10,y= dimensions.h/10},{w=8*dimensions.w/10, h=8*dimensions.h/10})
      label = newLabel(name, {x=0, y=0}, {w=dimensions.w, h=dimensions.h}, pText, font, "center", "center")
      timerPanel = newPanel("timerPanel", {x=self.dimensions.w/2,y=self.dimensions.h/2}, {shape="arc",r=self.dimensions.w/2+self.dimensions.h/2,a=1})
      inactivePanel = newPanel("inactivePanel", {x=0, y=0}, {w=self.dimensions.w,h=self.dimensions.h})
    elseif dimensions.shape == "circle" then
      pressedStatePanel= newPanel("pressed", {x=0,y=0},{shape="circle", r=8*dimensions.r/10})
      label = newLabel(name, {x=-dimensions.r, y=-dimensions.r}, {w=dimensions.r*2, h=dimensions.r*2}, pText, font, "center", "center")
      timerPanel = newPanel("timerPanel", {x=0, y=0}, {shape="arc", r=self.dimensions.r, a=1})
      inactivePanel = newPanel("inactivePanel", {x=-dimensions.r, y=-dimensions.r}, {w=dimensions.r*2, h=dimensions.r*2})
    end

    inactivePanel.visible = false
    inactivePanel.color.a = 0
    inactivePanel.image = hatches
    self:addElement(inactivePanel, "inactivePanel")

    timerPanel.visible = false
    timerPanel.color = {r=0, g=0, b=0, a=50}
    self:addElement(timerPanel, "timerPanel")

    self:addElement(label, "label")
    label.transparent = true

    pressedStatePanel.transparent = true
    pressedStatePanel.color = {r = 0, g = 0, b = 0}
    pressedStatePanel.visible = false
    pressedStatePanel.mode = "line"
    self:addElement(pressedStatePanel, "pressedStatePanel")

    self.actionPerformed = nil

    self.active = true
  end

  function button:onClick(x, y , pButton)
    if self.active then
      pressedStatePanel.visible = true
      grab.status = "UI"
      grab.ui = self
    end
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

  function button:update(dt)
    if self.timer then
      self.timer = self.timer - dt
      timerPanel.dimensions.a = self.timer/self.timerBaseValue
      if self.timer < 0 then
        self.timerBaseValue = nil
        self.timer = nil
        timerPanel.visible = false
        self.active = true
      end
    end
    inactivePanel.visible = not self.active
  end

  function button:addTimer(timer)
    self.timerBaseValue = timer
    self.timer = timer
    timerPanel.visible = true
    self.active = false
  end

  button:init()
  return button
end
