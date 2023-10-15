simulator:setScreen(1, "9x5")

function ellipse(x, y, minor_radius, major_radius, segments)
    local cos, sin = math.cos, math.sin
    local step = (math.pi * 2) / segments
    for i = 0, math.pi * 2, step do
        screen.drawLine(x + minor_radius * cos(i), y + major_radius * sin(i), x + minor_radius * cos(i + step), y + major_radius * sin(i + step))
    end
end

function drawEllipse(cx, cy, rx, ry, segments)
    local cos, sin = math.cos, math.sin
    local step = (math.pi * 2) / segments
    for i = 0, math.pi * 2, step do
        screen.drawLine(cx + rx * cos(i), cy + ry * sin(i), cx + rx * cos(i), cy + ry * sin(i))
    end
end

ticks = 0
function onTick()
    ticks = ticks + 1
end

function onDraw()
    ellipse(100, 100, 20, 40, 32)
end
