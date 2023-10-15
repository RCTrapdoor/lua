buttons = {
    {x = 1, y = 1, w = 44, h = 10, text = 'antigrav', state=false},
    {x = 1, y = 12, w = 44, h = 10, text = 'elevator', state=false},
    {x = 1, y = 23, w = 44, h = 10, text = 'lighting', state=false},
    {x = 1, y = 34, w = 44, h = 10, text = 'cabins1', state=false},
    {x = 1, y = 45, w = 44, h = 10, text = 'cabins2', state=false},
    {x = 1, y = 56, w = 44, h = 10, text = 'cabins3', state=false},
    {x = 1, y = 67, w = 44, h = 10, text = 'doors', state=false},
    {x = 1, y = 78, w = 44, h = 10, text = 'lsupport', state=false},
    {x = 1, y = 89, w = 44, h = 10, text = 'wing_sys', state=false},
    {x = 1, y = 100, w = 44, h = 10, text = 'misc', state=false}
}

function pointInRect(x, y, rx, ry, rw, rh)
    return x >= rx and x <= rx + rw and y >= ry and y <= ry + rh
end

function onTick()
  touch = {x = input.getNumber(3), y = input.getNumber(4)}
  click = input.getBool(1) and not press
  press = input.getBool(1)

  if click and pointInRect(touch.x, touch.y, 1, 1, 44, 109) then
    for k = 1, #buttons do
      local button = buttons[k]
      if  pointInRect(touch.x, touch.y, button.x, button.y, button.w, button.h) then
        button.state = not button.state
      end
    end
  end
end

function onDraw()
  for k = 1, #buttons do
    local button = buttons[k]
    screen.setColor(255, 255, 255);
    (button.state and screen.drawRectF or screen.drawRect)(button.x, button.y, button.w, button.h)
    -- ^this could also be written as:
    -- if button.state then
    --   screen.drawRectF(etc)
    -- else
    --   screen.drawRect(etc)
    -- end
    if button.state then
      screen.setColor(0, 0, 0)
    end
    screen.drawText(button.x + 1, button.y + 1, button.text)
  end
end