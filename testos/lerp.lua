simulator:setScreen(1, "9x5")
ticks = 0

function lerp(a, b, t)
    return a + (b - a) * t
end

function vec2(x, y)
    return {x = x, y = y}
end

function lerp_vec(a, b, t)
    return vec2(lerp(a.x, b.x, t), lerp(a.y, b.y, t))
end

function onTick()
    ticks = ticks + 1
end

screen = vec2(20, 20)
touchX = vec2(60, 100)
touchY = vec2(100, 20)
function onDraw()
    screen.drawCircle(screen.x, screen.y, 3)
    screen.drawCircle(touchX.x, touchX.y, 3)
    screen.drawCircle(touchY.x, touchY.y, 3)
    screen.drawLine(screen.x, screen.y, touchX.x, touchX.y)
    one = lerp_vec(screen, touchX, math.sin(ticks / 100)/2+0.5)
    screen.drawCircle(one.x, one.y, 3)
    two = lerp_vec(touchX, touchY, math.sin(ticks / 100)/2+0.5)
    screen.drawCircle(two.x, two.y, 3)
    screen.drawLine(touchX.x, touchX.y, touchY.x, touchY.y)
    screen.drawLine(one.x, one.y, two.x, two.y)
    three = lerp_vec(one, two, math.sin(ticks / 100)/2+0.5)
    screen.drawCircle(three.x, three.y, 3)
    for i = 0, 1, 0.1 do
        screen.drawLine(lerp(one, )
    end
end