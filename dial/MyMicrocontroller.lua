simulator:setScreen(1, "5x3")

ticks = 0

function onTick()
    ticks = ticks + 1
    speed = 240 * (math.cos(ticks / 60) + 1)/2
    angle = (math.pi * 3 / 2) * speed / 240
end

function onDraw()
    cx, cy = 16, 16 -- center of a 1x1 monitor
    screen.drawCircle(cx, cy, 16)
  
    x = cx + 16 * math.cos((math.pi * 5/4) - angle)
    y = cy - 16 * math.sin((math.pi * 5/4) - angle)
  
    x2 = cx + 10 * math.cos((math.pi * 5/4) - angle)
    y2 = cy - 10 * math.sin((math.pi * 5/4) - angle)
  
    screen.drawLine(x, y, x2, y2)
  end