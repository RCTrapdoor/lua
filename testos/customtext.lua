function onTick()
    RPS = input.getNumber(1)
end

function onDraw()
    screen.setColor(5, 5, 5)
    screen.drawRectF(6, 3, 20, 5)
    screen.drawRectF(6, 23, 20, 5)
    
    screen.setColor(30, 30, 30)
    screen.drawRectF(9, 2, 14, 27)

    screen.setColor(255, 255, 255)
    screen.drawText(9, 18, string.format("%d", RPS))
end