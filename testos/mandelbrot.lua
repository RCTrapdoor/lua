require('_build._simulator_config')

function screen.drawPixel(x, y, r, g, b)
    if x < 0 or x >= res.x or y < 0 or y >= res.y then
        return
    end
    screen.setColor(r, g, b)
    screen.drawLine(x, y, x+1, y)
end

function mapRange(value, low1, high1, low2, high2)
    return low2 + (high2 - low2) * (value - low1) / (high1 - low1)
end

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

function mandelbrot(x, y, max_iterations)
    local real = 0
    local imaginary = 0
    local iteration = 0
    while (real * real + imaginary * imaginary < 4 and iteration < max_iterations) do
        local temp = real * real - imaginary * imaginary + x
        imaginary = 2 * real * imaginary + y
        real = temp
        iteration = iteration + 1
    end
    return iteration
end

zoom = 100

max_iterations = 50

isPressed = false
res = {x=288,y=80}
center = {x=0,y=0}

mandelbrot_set = {}
function onTick()
    click = input.getBool(1) and not isPressed
    isPressed = input.getBool(1)
    if click then
        center.x = input.getNumber(3)
        center.y = input.getNumber(4)
    end
end

function onDraw()
    for x = 0, res.x-1 do
        for y = 0, res.y-1 do
            local c = {x=x/res.x*zoom-center.x,y=y/res.y*zoom-center.y}
            local iterations = mandelbrot(c.x, c.y, max_iterations)
            local color = hsvtorgb(mapRange(iterations, 0, max_iterations, 0, 1), 1, 1)
            screen.drawPixel(x, y, color[1], color[2], color[3])
        end
    end
end