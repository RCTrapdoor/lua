pylons = {false, false, false, false, false, false, false, false}
selected = 0

function onTick()
  if input.getBool(1) and not select_press then
    selected = (selected % #pylons) + 1
  end

  select_press = input.getBool(1)

  if input.getBool(2) then
    pylons[selected] = true
    output.setBool(selected, true)
  end
end

function onDraw()
  for i = 1, #pylons do
    setC(100, 100, 100)
    if pylons[i] then
      setC(255, 0, 0)
    elseif selected == i then
      setC(0, 255, 0)
    end
    screen.drawLine(20, 2+3*i, 24, 2+3*i)
  end

  setC(43, 43, 43)
  screen.drawRectF(35, 14, 14, 5)
  setC(43, 43, 43)
  screen.drawRectF(36, 15, 12, 3)

  setC(43, 43, 43)

  cx = 55
  cy = 16.5
  angle = 1.57
  p1 = rotatePoint(cx, cy, angle, 50, 21)
  p2 = rotatePoint(cx, cy, angle, 55, 12)
  p3 = rotatePoint(cx, cy, angle, 60, 21)
  screen.drawTriangleF(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y)

  setC(43, 43, 43)
  screen.drawRectF(40, 15, 20, 3)
  setC(43, 43, 43)
  screen.drawRectF(41, 16, 18, 1)

  setC(43, 43, 43)
  screen.drawRectF(51, 6, 3, 21)
  setC(43, 43, 43)
  screen.drawRectF(52, 7, 1, 19)

  setC(43, 43, 43)
  cx = 44.5
  cy = 16.5
  angle = -1.58
  p1 = rotatePoint(cx, cy, angle, 34, 23)
  p2 = rotatePoint(cx, cy, angle, 44.5, 10)
  p3 = rotatePoint(cx, cy, angle, 55, 23)
  screen.drawTriangleF(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y)

  setC(43, 43, 43)
  screen.drawRectF(30, 15, 5, 3)
  setC(43, 43, 43)
  screen.drawRectF(31, 16, 3, 1)

  setC(43, 43, 43)
  cx = 27.5
  cy = 16.5
  angle = -1.58
  p1 = rotatePoint(cx, cy, angle, 26, 19)
  p2 = rotatePoint(cx, cy, angle, 27.5, 14)
  p3 = rotatePoint(cx, cy, angle, 29, 19)
  screen.drawTriangleF(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y)

  setC(43, 43, 43)
  cx = 40.5
  cy = 20
  angle = 0.78
  p1 = rotatePoint(cx, cy, angle, 35, 22)
  p2 = rotatePoint(cx, cy, angle, 40.5, 18)
  p3 = rotatePoint(cx, cy, angle, 46, 22)
  screen.drawTriangleF(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y)

  setC(43, 43, 43)
  cx = 40.5
  cy = 13
  angle = 2.35
  p1 = rotatePoint(cx, cy, angle, 35, 15)
  p2 = rotatePoint(cx, cy, angle, 40.5, 11)
  p3 = rotatePoint(cx, cy, angle, 46, 15)
  screen.drawTriangleF(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y)

  setC(143, 43, 43, 100)
  screen.drawRectF(30, 13, 26, 5)
  screen.drawRectF(26, 14, 34, 3)
  screen.drawTriangleF(42, 24, 42, 8, 34, 16)
  screen.drawTriangleF(51, 27, 51, 5, 40, 16)
  screen.drawRectF(51, 5, 3, 21)
end

function setC(r, g, b, a)
  if a == nil then
    a = 255
  end
  screen.setColor(r, g, b, a)
end

function rotatePoint(cx, cy, angle, px, py)
  set_coord = math.sin(angle)
  touchY = math.cos(angle)
  px = px - cx
  py = py - cy
  xnew = px * touchY - py * set_coord
  ynew = px * set_coord + py * touchY
  px = xnew + cx
  py = ynew + cy
  return { x = px, y = py }
end

function isInRect(x, y, w, h, px, py)
  return px >= x and px <= x + w and py >= y and py <= y + h
end
