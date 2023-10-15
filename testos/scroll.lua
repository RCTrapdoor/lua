text = "This is a test "

function onTick()
    ticks = ticks and ticks + 1 or 0
end

function onDraw()
    screen.setColor(100,100,100)
    screen.drawText(0-ticks%(#text*5), 5, string.rep(text, 5))
    screen.drawText(13, 20, string.format("%d", (0-ticks%(#text*5))))
end