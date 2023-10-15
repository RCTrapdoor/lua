require("_build._simulator_config")

tau = math.pi * 2
pi = tau / 2

function vecSub(a, b) -- Vector from a to b
	return {x = b.x - a.x, y = b.y - a.y}
end

function vecLength(a)
	return (a.x^2+a.y^2)^0.5
end

function vecScale(a, b)
	return {x = b * (a.x / vecDist(a)), y =  b * (a.y / vecDist(a))}
end

function vecProduct(a, b)
	return a.x * b.x + a.y * b.y
end

function scalarProj(a, b)
	return vecProduct(a, b)/(vecDist(a))
end

function vecAdd(a, b)
	return {x = a.x + b.x, y = a.y + b.y}
end

waypoint = {x = 0, y = 0}

w,h = 288, 160

ticks = 0

zoom = 5

mpp = (zoom * 1000) / w

function onTick()
    ticks = ticks + 1
    gps = {x = input.getNumber(7), y = input.getNumber(8)}
    compass = input.getNumber(9) * tau

    click = input.getBool(1) and not isPressed
    isPressed = input.getBool(1)

    click2 = input.getBool(2) and not isPressed2
    isPressed2 = input.getBool(2)

    if click then
        touch = {x = input.getNumber(3), y = input.getNumber(4)}

        x, y = map.screenToMap(gps.x, gps.y, zoom, w, h, touch.x, touch.y)
        target = {x = x, y = y, r = 100, pX = touch.x, pY = touch.y}
        print(gps.x, gps.y)
        print(x, y)
    end

    if click2 then
        touch = {x = input.getNumber(5), y = input.getNumber(6)}
    end

    if target then
        -- calculate tangent points of circle
        vec = vecSub({x = target.x, y = target.y}, {x = gps.x, y = gps.y})
        distance = vecLength(vec)
        angle = math.atan(vec.y, vec.x) + math.acos(target.r / distance)
        angle2 = math.atan(vec.y, vec.x) - math.acos(target.r / distance)
        x,y = target.x + target.r * math.cos(angle), target.y + target.r * math.sin(angle)
        x2,y2 = target.x + target.r * math.cos(angle2), target.y + target.r * math.sin(angle2)

    end
end

function onDraw()
    screen.drawMap(gps.x, gps.y, zoom)
    screen.setColor(0, 0, 0)
    if target then
        screen.drawCircle(target.pX, target.pY, target.r * (1/mpp))
        x,y = map.mapToScreen(gps.x, gps.y, zoom, w, h, x, y)
        x2,y2 = map.mapToScreen(gps.x, gps.y, zoom, w, h, x2, y2)
        px,py = map.mapToScreen(gps.x, gps.y, zoom, w, h, gps.x, gps.y)
        screen.drawLine(px, py, x, y)
        screen.drawLine(px, py, x2, y2)
    end
end
