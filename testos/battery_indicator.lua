simulator:setScreen(1, "1x1")

ticks = 0
function onTick()
    ticks = ticks + 1
    batt = math.sin(ticks / 30) / 2 + 0.5
end

function onDraw()
    screen.setColor(255, 255, 255)
    screen.drawText(1, 24, "Batt")

    screen.drawRect(21, 24, 9, 4)
    screen.setColor(0, 100, 0)
    for i = 0.1, math.floor(batt * 8 + 0.5), 3 do
        screen.setColor(255-255*i/8, 255*i/8, 0)
        screen.drawRectF(22 + i, 25, 2, 3)
    end
    -- screen.drawRectF(22, 25, batt * 8, 3)
end
