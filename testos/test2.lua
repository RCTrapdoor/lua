ticks = 0

obstacles = {}
-- add 20 obstacles
for i = 1, 20 do
    obstacles[i] = {x = math.random(0, 320), y = math.random(0, 240)}
end

function onTick()
    ticks = ticks + 1
    val = math.cos(ticks / 60) * 10
end

function onDraw()
    offset = math.fmod(val, 1)

    screen.setColor(255, 255, 255)

    for i = -1, 2 do
        screen.drawText(4, 10 + i * 8 - offset * 8, string.format('%3.f', math.floor(val-offset) + i))
    end

    screen.setColor(20, 20, 20, 150)
    screen.drawRectF(0, 0, 50, 10)
    screen.drawRectF(0, 20, 50, 15)
end