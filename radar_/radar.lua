radarBuffer, targets = {}, {}

tau = math.pi * 2
pi = tau / 2

zoom = 1.75

function vecAdd(a, b)
    local c = {}
    for k,v in pairs(a) do
        c[k] = v + b[k]
    end
    return c
end

function vecSub(a, b)
    local c = {}
    for k,v in pairs(a) do
        c[k] = v - b[k]
    end
    return c
end

function matMul(vec, mat)
    local c = {}
    for k,v in pairs(mat) do
        c[k] = 0
        for k2,v2 in pairs(v) do
            c[k] = c[k] + v2 * vec[k2]
        end
    end
    return c
end

function vecRotate(vec, roll, pitch, yaw)
    local c = {vec[1], vec[2], vec[3]}
    local cp, sp = math.cos(pitch), math.sin(pitch)
    local cy, sy = math.cos(yaw), math.sin(yaw)
    local cr, sr = math.cos(roll), math.sin(roll)
    c = matMul(vec, {
        {cy*cp, cy*sp*sr-sy*cr, cy*sp*cr+sy*sr},
        {sy*cp, sy*sp*sr+cy*cr, sy*sp*cr-cy*sr},
        {-sp, cp*sr, cp*cr}
    })
    -- c = matMul(c, {
    --     {1, 0, 0},
    --     {0, math.cos(pitch), -math.sin(pitch)},
    --     {0, math.sin(pitch), math.cos(pitch)}
    -- })
    -- c = matMul(c, {
    --     {math.cos(yaw), 0, math.sin(yaw)},
    --     {0, 1, 0},
    --     {-math.sin(yaw), 0, math.cos(yaw)}
    -- })
    -- c = matMul(c, {
    --     {math.cos(roll), -math.sin(roll), 0},
    --     {math.sin(roll), math.cos(roll), 0},
    --     {0, 0, 1}
    -- })
    return c
end

-- A = {10, 0, 0}
-- B = vecRotate(A, 0, 0, math.pi/2)

-- print(B[1], B[2], B[3])

function calcPos(target)
    local adj = target.distance * math.cos(target.elevation)
    local x, y, z
    z = target.distance * math.sin(target.elevation)
    x = -adj * math.sin(compass - target.azimuth)
    y = adj * math.cos(compass - target.azimuth)
    return {x, y, z}
end

ticks = 0

function onTick()
    ticks = ticks + 1
    radarComp = input.getBool(32)
    -- radarComp = not radarComp
    if radarComp and gps then
        for i = 0, 24, 4 do
            radarBuffer[i//4 + 1] = {
                distance = input.getNumber(i + 1),
                azimuth = input.getNumber(i + 2) * tau,
                elevation = input.getNumber(i + 3) * tau,
                detected = input.getBool(i // 4 + 1)
            }
            targets[i//4 + 1] = vecAdd(vecRotate(calcPos(radarBuffer[i//4 + 1]), roll, pitch, compass), gps)
        end
    elseif not radarComp then
        isClick = input.getBool(1) and not isPressed
        isPressed = input.getBool(1)

        width, height = input.getNumber(1), input.getNumber(2)
        touch = {input.getNumber(3), input.getNumber(4)}

        gps = {input.getNumber(5), input.getNumber(6), input.getNumber(8)}
        compass = input.getNumber(7) * tau
        -- compass = 0
        -- compass = ticks / 60
        up = input.getNumber(11) * tau
        pitch = input.getNumber(9) * tau
        -- pitch = ticks / 120
        left = input.getNumber(10) * tau
        roll = math.atan(math.sin(left), math.sin(up))
        -- roll = ticks / 50
        -- up = math.sin(ticks / 60)
        -- if up < 0 then
        --     roll = -pi * 2 - roll
        --     pitch = -pi * 2 - pitch
        --     -- compass = pi/2 - compass
        -- end
    end
end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end

pointer_x = {30, 0, 0}
pointer_y = {0, 30, 0}
pointer_z = {0, 0, 30}

function table.merge(a, b)
    local c = {}
    for i = 1, #a do
        c[i] = a[i]
    end
    for i = 1, #b do
        c[i + #a] = b[i]
    end
    return c
end

function onDraw()
	screen.setColor(255, 0, 0)
    if gps then
        cx, cy = width / 2, height / 2
        screen.drawMap(gps[1], gps[2], zoom)
        screen.drawText(2, 2, ("w x h: %d x % d"):format(width, height))
        screen.drawText(2, 9, ("cx, cy: %d x % d"):format(cx, cy))
        screen.drawText(2, 16, ("touch: %d x %d"):format(touch[1], touch[2]))
        px = vecRotate(pointer_x, roll, pitch, compass)
        py = vecRotate(pointer_y, roll, pitch, compass)
        pz = vecRotate(pointer_z, roll, pitch, compass)
        p = {table.merge(px, {255, 0, 0, 'x'}), table.merge(py, {0, 255, 0, 'y'}), table.merge(pz, {0, 0, 255, 'z'})}
        table.sort(p, function(a, b) return a[3] > b[3] end)
        -- screen.setColor(255, 0, 0)
        -- screen.drawLine(cx, cy, cx + px[1], cy + px[2])
        -- screen.setColor(0, 255, 0)
        -- screen.drawLine(cx, cy, cx + py[1], cy + py[2])
        -- screen.setColor(0, 0, 255)
        -- screen.drawLine(cx, cy, cx + pz[1], cy + pz[2])
        for i = 1, 3 do
            screen.setColor(p[i][4], p[i][5], p[i][6])
            screen.drawText(cx + p[i][1]*1.2, cy + p[i][2]*1.2, p[i][7])
            screen.drawLine(cx, cy, cx + p[i][1], cy + p[i][2])
        end
        screen.setColor(0, 0, 0)
        screen.drawText(150, 113, "      roll   pitch     yaw")
        screen.drawText(150, 120, ("   (%6.2f, %6.2f, %6.2f)"):format(roll, pitch, compass))
        screen.drawText(150, 130, ("x: (%6.2f, %6.2f, %6.2f)"):format(px[1], px[2], px[3]))
        screen.drawText(150, 137, ("y: (%6.2f, %6.2f, %6.2f)"):format(py[1], py[2], py[3]))
        screen.drawText(150, 144, ("z: (%6.2f, %6.2f, %6.2f)"):format(pz[1], pz[2], pz[3]))
    end
    for i = 1, #radarBuffer do
        if radarBuffer[i].detected then
            screen.setColor(0, 255, 0)
        else
            screen.setColor(255, 0, 0)
        end
        screen.drawText(160, i * 6 - 5, ("Az %5.2f El %5.2f R %.2f"):format(radarBuffer[i].azimuth, radarBuffer[i].elevation, radarBuffer[i].distance))
    end
    for i = 1, #targets do
        px, py = map.mapToScreen(gps[1], gps[2], zoom, width, height, targets[i][1], targets[i][2])
        screen.drawCircle(px, py, 2)
    end
end