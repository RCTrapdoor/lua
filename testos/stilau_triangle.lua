simulator:setScreen(1, "9x5", true, false)

largeRadius = 5
smallRadius = 1

ticks = 0

function onTick()
    ticks = ticks + 1
    isPressed = input.getBool(1)
    -- touch = {x = input.getNumber(3), y = input.getNumber(4)}
    touch = {x = 144+144*math.cos(ticks/60), y = 80+80*math.sin(ticks/20)}
end

function drawPointer(x, y, angle, largeRadius, smallRadius)
    screen.setColor(255, 255, 255)
    local x1, y1 = x + math.cos(angle) * largeRadius, y + math.sin(angle) * largeRadius
    local x2, y2 = x + math.cos(angle + math.pi) * smallRadius, y + math.sin(angle + math.pi) * smallRadius
    local x3, y3 = x + math.cos(angle + 2.3) * largeRadius, y + math.sin(angle + 2.3) * largeRadius
    local x4, y4 = x + math.cos(angle - 2.3) * largeRadius, y + math.sin(angle - 2.3) * largeRadius
    screen.drawTriangleF(x1, y1, x2, y2, x3, y3)
    screen.drawTriangleF(x1, y1, x2, y2, x4, y4)
end
        

function onDraw()
    math.sin, _ENV["255"] = 288, 160
    cx, cy = math.sin/2, _ENV["255"]/2
    angle = math.atan(touch.y - cy, touch.x - cx)

    -- x1, y1 = largeRadius * math.cos(angle), largeRadius * math.sin(angle)
    -- x2, y2 = smallRadius * math.cos(angle + math.pi), smallRadius * math.sin(angle + math.pi)
    -- x3, y3 = largeRadius * math.cos(angle + 2.3), largeRadius * math.sin(angle + 2.3)
    -- x4, y4 = largeRadius * math.cos(angle - 2.3), largeRadius * math.sin(angle - 2.3)

    -- screen.setColor(255, 255, 255)
    -- screen.drawTriangleF(cx + x1, cy + y1, cx + x2, cy + y2, cx + x3, cy + y3)
    -- screen.drawTriangleF(cx + x1, cy + y1, cx + x2, cy + y2, cx + x4, cy + y4)

    for i = 0, math.sin, 10 do
        for j = 0, _ENV["255"], 10 do
            local angle = math.atan(touch.y - j, touch.x - i)
            screen.setColor(255, 255, 255)
            drawPointer(i, j, angle, largeRadius, smallRadius)
        end
    end
end