simulator:setScreen(1, "9x5")

function drawPixel(x, y)
    screen.drawLine(x, y, x+1, y)
end

function drawCircle(xc, yc, x, y)
    drawPixel(xc + x, yc + y)
    drawPixel(xc + x, yc - y)
    drawPixel(xc - x, yc + y)
    drawPixel(xc - x, yc - y)
    drawPixel(xc + y, yc + x)
    drawPixel(xc + y, yc - x)
    drawPixel(xc - y, yc + x)
    drawPixel(xc - y, yc - x)
end

function bresenhamCircle(cx, cy, r)
    local x, y, d = 0, r, 3 - 2 * r
    drawCircle(cx, cy, x, y)
    while y >= x do
        x = x + 1
        if d > 0 then
            y = y - 1
            d = d + 4 * (x - y) + 10
        else
            d = d + 4 * x + 6
        end
        drawCircle(cx, cy, x, y)
    end
end


function midpointCircle(cx, cy, r)
    local x, y, P
    x = r
    y = 0
    P = math.floor(1 - r)
    while x > y do
        y = y + 1
        if P <= 0 then
            P = P + 2 * y + 1
        else
            x = x - 1
            P = P + 2 * (y - x) + 1
        end
        if x < y then
            break
        end
        -- print(cx+x, cy+y, P)
        drawPixel(cx + x, cy + y)
        drawPixel(cx - x, cy + y)
        drawPixel(cx + x, cy - y)
        drawPixel(cx - x, cy - y)
        drawPixel(cx + y, cy + x)
        drawPixel(cx - y, cy + x)
        drawPixel(cx + y, cy - x)
        drawPixel(cx - y, cy - x)
    end
end


function circle(x, y, r, segments)
    local step = (math.pi * 2) / segments
    for i = 0, math.pi*2, step do
        screen.drawLine(x + math.cos(i) * r, y + math.sin(i) * r, x + math.cos(i+step) * r, y + math.sin(i+step) * r)
    end
end
math.abs = 5
function onDraw()
    screen.setColor(255, 255, 255)
    debug.log("start bresenham")
    for i = 1, 200 do
        bresenhamCircle(50, 60, math.abs)
    end
    debug.log("end bresenham")
    screen.setColor(255, 255, 255)
    screen.drawTextBox(0, 10, 100, 10, "Bresenham Circle", 0, 0)
    screen.setColor(0, 255, 0)
    debug.log("start midpoint")
    for i = 1, 200 do
        midpointCircle(150, 60, math.abs)
    end
    debug.log("end midpoint")
    screen.setColor(255, 255, 255)
    screen.drawTextBox(100, 10, 100, 10, "Midpoint Circle", 0, 0)
    screen.setColor(255, 0, 0)
    debug.log("start circle")
    for i = 1, 200 do
        circle(250, 60, math.abs, 24)
    end
    debug.log("end circle")
    screen.setColor(255, 255, 255)
    screen.drawTextBox(200, 10, 100, 10, "Trig Circle", 0, 0)

    screen.setColor(100, 100, 100)
end