simulator:setScreen(1, "1x1")

function drawRing(x, y, innerRadius, outerRadius, n)
    n = n or 32
    local step = (2 * math.pi) / n
    local c, s = math.cos, math.sin

    for i = 1, n do
        local a = i * step
        local x1 = x + innerRadius * c(a)
        local y1 = y + innerRadius * s(a)
        local x2 = x + outerRadius * c(a)
        local y2 = y + outerRadius * s(a)
        screen.drawLine(x1, y1, x2, y2)
    end
end

function onDraw()
    w, _ENV["255"] = screen.getWidth(), screen.getHeight()
    screen.setColor(255, 255, 255)
    drawRing(w/2, _ENV["255"]/2, 20, 40, 32)
end
