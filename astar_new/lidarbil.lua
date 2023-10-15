function vecSub(a, b) -- Vector from a to b
    return { x = b.x - a.x, y = b.y - a.y }
end

function vecDist(a)
    return (a.x ^ 2 + a.y ^ 2) ^ 0.5
end

function sgn(v)
    return v > 0 and 1 or -1
end

zoom = 0.5

tau = math.pi * 2
pi = tau / 2

binsize = 5

map = {}

function plotLineLow(x0, y0, x1, y1)
    local dx = x1 - x0
    local dy = y1 - y0
    local yi = 1
    if dy < 0 then
        yi = -1
        dy = -dy
    end
    local D = (2 * dy) - dx
    local y = y0

    for x = x0, x1-1 do
        if not map[x] then map[x] = {} end
        if not (x == x1 and y == y1) then
            map[x][y] = math.max(0, map[x][y] and map[x][y] - 10 or 0)
        end
        if D > 0 then
            y = y + yi
            D = D + (2 * (dy - dx))
        else
            D = D + 2*dy
        end
    end
end

function plotLineHigh(x0, y0, x1, y1)
    local dx = x1 - x0
    local dy = y1 - y0
    local xi = 1
    if dx < 0 then
        xi = -1
        dx = -dx
    end
    local D = (2 * dx) - dy
    local x = x0

    for y = y0, y1-1 do
        if not map[x] then map[x] = {} end
        if not (x == x1 and y == y1) then
            map[x][y] = math.max(0, map[x][y] and map[x][y] - 10 or 0)
        end
        if D > 0 then
            x = x + xi
            D = D + (2 * (dx - dy))
        else
            D = D + 2*dx
        end
    end
end

function plotLine(x0, y0, x1, y1)
    if math.abs(y1 - y0) < math.abs(x1 - x0) then
        if x0 > x1 then
            plotLineLow(x1, y1, x0, y0)
        else
            plotLineLow(x0, y0, x1, y1)
        end
    else
        if y0 > y1 then
            plotLineHigh(x1, y1, x0, y0)
        else
            plotLineHigh(x0, y0, x1, y1)
        end
    end
end

function onTick()
    factor = (zoom*1000)/2
    gps = {x = input.getNumber(5), y = input.getNumber(6)}
    g_gps = {x = gps.x - gps.x % binsize, y = gps.y - gps.y % binsize}
    compass = input.getNumber(7) * tau
    distance = input.getNumber(8)

    x = gps.x - distance * math.sin(compass)
    g_x = (x - x % binsize) / binsize
    y = gps.y + distance * math.cos(compass)
    g_y = (y - y % binsize) / binsize
    if not map[g_x] then
        map[g_x] = {}
    end
    plotLine(g_gps.x/binsize, g_gps.y/binsize, g_x, g_y)
    if distance > 2 and distance < 500 then
        map[g_x][g_y] = math.min(255, map[g_x][g_y] and map[g_x][g_y] + 255 or 255)
    end
end
function onDraw()
    w, h = screen.getWidth(), screen.getHeight()

    screen.drawMap(gps.x, gps.y, zoom)

    px, py = map.mapToScreen(gps.x, gps.y, zoom, w, h, x, y)
    screen.drawLine(w/2, h/2, px, py)

    for i = -factor-binsize, factor+binsize, binsize do
        for j = -140-binsize, 140+binsize, binsize do
            screen.setColor(0, 0, 0)
            if map[(g_gps.x+i)/binsize] and map[(g_gps.x+i)/binsize][(g_gps.y+j)/binsize] then
                screen.setColor(0, 0, 0, map[(g_gps.x+i)/binsize][(g_gps.y+j)/binsize])
            end
            px, py = map.mapToScreen(gps.x, gps.y, zoom, w, h, g_gps.x + i, g_gps.y + j)
            screen.drawRectF(px, py, (w/(zoom*1000)) * binsize, (w/(zoom*1000)) * binsize)
        end
    end
    screen.setColor(255, 255, 255)
    screen.drawText(2, 2, ("%5.f x %5.f"):format(x, y))
    screen.drawText(2, 10, ("%5.f x %5.f"):format(g_x, g_y))
    screen.drawText(2, 18, ("%5.2f"):format(distance))
end