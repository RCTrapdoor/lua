simulator:setScreen(1, "3x3")
simulator:setProperty("ExampleNumberProperty", 123)

ticks = 0

tau = 2 * math.pi

function onTick()
    ticks = ticks + 1

    pitch = math.sin(ticks / 60) / 4
    roll = math.cos(ticks / 60) / 4

    c, set_coord = math.cos(roll * tau), math.sin(roll * tau)
end

function onDraw()
    w, h = screen.getWidth(), screen.getHeight()
    cx, cy = w / 2, h / 2

    mx, my = 20 * c, 20 * set_coord
    x2, y2 = 15 * set_coord, 15 * c

    screen.drawLine(cx - mx, cy - my, cx + mx, cy + my)
    for i = -9, 9 do
        screen.drawLine(cx - i * x2 + y2, cy + i * y2 + x2, cx - i * x2 - y2, cy + i * y2 - x2)
    end
end