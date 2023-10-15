require("_build._simulator_config")

-- function hsv to rgb
function hsvtorgb(h, s, v)
    local r, g, b
    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    return {r * 255, g * 255, b * 255}
end


width, height = 288, 160

function onDraw()
    for i = 0, height do
        -- red, yellow, green gradient
        color = hsvtorgb((i / height)*0.325, 1, 1)
        screen.setColor(color[1], color[2], color[3])
        screen.drawLine(0, height-i, width/2, height-i)
    end
    for i = 0, height do
        screen.setColor(255-255*i/height, 255-255*(1-(i/height)), 0)
        screen.drawLine(width/2, height-i, width, height-i)
    end
end