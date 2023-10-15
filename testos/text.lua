largeRadius = 74

function onTick()
    value = input.getNumber(1) * (math.pi / 2)
    needle_x = 80 - largeRadius * math.cos(value)
    needle_y = 80 - largeRadius * math.sin(value)
end

function onDraw()
    screen.setColor(120, 120, 100)
    screen.drawClear()
    screen.setColor(10, 10, 10)

    for i = 0, 20 do
        r1 = 74 - 7
        val = (math.pi / 40) * i

        if i % 5 == 0 then
            r1 = 74 - 10
            lx1, ly1 = 80 - 60 * math.cos(val), 80 - 60 * math.sin(val)
            screen.drawText(lx1-6, ly1, ("%3.f"):format(i*5))
        end

        r1 = 74 - (i % 5 == 0 and 10 or 5)
        r2 = 74
        x1, y1 = 80 - r1 * math.cos(val), 80 - r1 * math.sin(val)
        x2, y2 = 80 - r2 * math.cos(val), 80 - r2 * math.sin(val)

            
        screen.drawLine(x1, y1, x2, y2)
    end

    screen.drawLine(80, 80, needle_x, needle_y)
    -- screen.drawLine(79, 80, needle_x, needle_y)
    -- screen.drawLine(80, 79, needle_x, needle_y)
end