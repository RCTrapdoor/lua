simulator:setScreen(1, "3x1")

segs = 9

ticks = 0
function onTick()
    ticks = ticks + 1
end

function onDraw()
    for i = 0, segs - 1 do
        r = math.sin(ticks / 30 - (math.pi * 1) * i / segs) * 127 + 128
        screen.setColor(r, 0, 0)
        screen.drawRectF(2 + 10 * i, 2, 7, 5)
    end
end
