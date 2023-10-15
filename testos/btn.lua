function button(P, PX, PY, x, y, w, h)
    return (P and PX >= x and PX < x + w and PY >= y and PY < y + h)
end

function onTick()
  x = input.getNumber(3)
  y = input.getNumber(4)
  touch = input.getBool(1)

  myButton =  button(touch, x, y, 5, 5, 20, 10)
end

function onDraw()
  if myButton then
    screen.drawRectF(5, 5, 20, 10)
  else
    screen.drawRect(5, 5, 20, 10)
  end
end