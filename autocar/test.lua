require("_build._simulator_config")

function ellipse(x, y, minor_radius, major_radius, segments)
    local cos, sin = math.cos, math.sin
    local step = (math.pi * 2) / segments
    for i = 0, math.pi*2, step do
        screen.drawLine(x + major_radius * cos(i), y + major_radius * sin(i), x + minor_radius * cos(i), y + minor_radius * sin(i))
    end
end

function onDraw()
    screen.setColor(255, 255, 255)
    ellipse(100, 100, 20, 20, 10)
end