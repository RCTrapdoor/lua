simulator:setScreen(1, "9x5")

ticks = 0
barWidth = 60
barHeight = 10

function onTick()
    ticks = ticks + 1
    value = (math.sin(ticks / 120) + 1) / 2

end

function onDraw()
    for i = 0, value * barWidth, barWidth/10 do
        screen.setColor(255, 255 - 255 * i/barWidth, 0)
        screen.drawRectF(40 + i, 40, barWidth/10, barHeight)
    end
end