-- By Hendrik, please contact me if you need the non-minified source code
function Distance(c, d, e, f) return math.sqrt((e - c) ^ 2 + (f - d) ^ 2) end
function lerp(h, i, j) return h + ((i - h) * math.sin((j * math.pi) / 2)) end
function getNumbers(...)
    local h = {}
    for i, l in ipairs({...}) do h[i] = input.getNumber(l) end
    return table.unpack(h)
end
function getBools(...)
    local h = {}
    for i, l in ipairs({...}) do h[i] = input.getBool(l) end
    return table.unpack(h)
end
function pointInRect(o, p, h, i, q, r)
    return o >= h and p >= i and o < h + q and p < i + r
end
function srgb(t, u, i, h)
    h = h or 255
    return {
        255 * (.8 * t / 255) ^ 2.6, 255 * (.8 * u / 255) ^ 2.6,
        255 * (.8 * i / 255) ^ 2.6, h
    }
end
colors = {
    {{240, 240, 240}, {200, 200, 200}},
    {srgb(120, 120, 153), srgb(120, 120, 153)},
    {srgb(106, 106, 181), srgb(106, 106, 181)},
    {srgb(219, 30, 30), srgb(183, 25, 25)},
    {srgb(183, 25, 25), srgb(142, 19, 19)}
}
function setC(x) screen.setColor(table.unpack(colors[x][buttons[1][6] and 2 or 1])) end
z = 0
A = 30
B = 0
C = 0
D = 0
E = 0
waypoint_x = 0
waypoint_y = 0
H = 1
isPressed = false
waypoint_list = {}
K = 0
L = 0
buttons = {
    {"DRK", 1, 1, 16, 2, false}, {"FLW", 1, 9, 16, 2, true},
    {"+", 1, 17, 7, 0, false}, {"-", 10, 17, 7, 0, false},
    {"ADD", -17, 9, 16, 1, false}, {"DEL", -17, 17, 16, 1, false},
    {"AP", -17, 25, 16, 2, false}, {"<", -17, 1, 7, 1, false},
    {">", -8, 1, 7, 1, false}
}
function onTick()
    z = math.min(z + 1, A)
    width, height, touchX, touchY, gpsX, gpsY, heading, targetX, targetY = getNumbers(1, 2, 3, 4, 7, 8, 9, 10, 11)
    heading = heading * -1
    B = lerp(D, waypoint_x, z / A)
    C = lerp(E, waypoint_y, z / A)
    touch1, delete, keypad_pulse = getBools(1, 3, 4)
    isClick = touch1 and not isPressed
    isPressed = touch1
    output.setBool(1, buttons[7][6])
    if buttons[7][6] then
        if #waypoint_list == 0 then
            buttons[7][6] = false
        else
            output.setNumber(1, waypoint_list[1][1])
            output.setNumber(2, waypoint_list[1][2])
            if Distance(gpsX, gpsY, waypoint_list[1][1], waypoint_list[1][2]) < 100 then delete = true end
        end
    end
    for Z, i in ipairs(buttons) do
        if i[5] ~= 2 then i[6] = false end
        bb = i[2] > 0 and i[2] or (width + i[2])
        if touch1 and pointInRect(touchX, touchY, bb, i[3], i[4], 7) then
            if i[5] == 2 then
                if isClick then i[6] = not i[6] end
            elseif i[5] == 1 then
                i[6] = isClick
            else
                i[6] = touch1
            end
        end
    end
    if buttons[2][6] then
        D = B
        E = C
        waypoint_x = gpsX
        waypoint_y = gpsY
        z = 0
    end
    if buttons[3][6] then H = H - H / 50 end
    if buttons[4][6] then H = H + H / 50 end
    if buttons[8][6] or buttons[9][6] then
        if buttons[8][6] and L > 1 then L = L - 1 end
        if buttons[9][6] and L < #waypoint_list then L = L + 1 end
        if L > 0 then
            buttons[2][6] = false
            D = B
            E = C
            waypoint_x = waypoint_list[L][1]
            waypoint_y = waypoint_list[L][2]
            z = 0
        end
    end
    bc = nil
    if buttons[5][6] then
        o, p = map.screenToMap(B, C, H, width, height, width / 2, height / 2)
        bc = {o, p}
    end
    if keypad_pulse then bc = {targetX, targetY} end
    if bc then
        Z = L or 0
        if Z == 0 or waypoint_list[Z][1] ~= bc[1] or waypoint_list[Z][2] ~= bc[2] then -- this will crash if you try to add a waypoint at the same position as the last one
            table.insert(waypoint_list, Z + 1, bc)
            L = Z + 1
        end
    end
    if delete and #waypoint_list > 0 then
        table.remove(waypoint_list, 1)
        L = math.min(L - 1, #waypoint_list)
    end
    if buttons[6][6] and #waypoint_list > 0 and L > 0 then
        table.remove(waypoint_list, L)
        L = math.min(L - 1, #waypoint_list)
    end
    bd = 0
    be = gpsX
    bf = gpsY
    for Z, bg in ipairs(waypoint_list) do
        o, p = table.unpack(bg)
        bd = bd + Distance(be, bf, bg[1], p)
        be = o
        bf = p
    end
    K = math.floor(bd)
    output.setNumber(3, K)
    if isClick and touchX >= 18 and touchX < q - 18 and touchY < r - 7 then
        bh = touchX
        bi = touchY
        buttons[2][6] = false
        for Z, bg in ipairs(waypoint_list) do
            bj, bk = map.mapToScreen(B, C, H, q, r, bg[1], bg[2])
            bd = Distance(touchX, touchY, bj, bk)
            if bd < 6 then
                bh = bj
                bi = bk
                L = Z
            end
        end
        bl, bg = map.screenToMap(B, C, H, width, height, bh, bi)
        D = B
        E = C
        waypoint_x = bl
        waypoint_y = bg
        z = 0
    end
end
function onDraw()
    if touch1 == nil then return true end
    q = screen.getWidth()
    r = screen.getHeight()
    if buttons[1][6] then
        screen.setMapColorGrass(3, 6, 3)
        screen.setMapColorLand(8, 8, 4)
        screen.setMapColorOcean(2, 2, 5)
        screen.setMapColorSand(12, 12, 7)
        screen.setMapColorShallows(4, 4, 7)
        screen.setMapColorSnow(15, 15, 15)
    else
        screen.setMapColorOcean(14, 46, 48)
        screen.setMapColorShallows(24, 68, 72)
        screen.setMapColorLand(90, 90, 90)
        screen.setMapColorGrass(64, 85, 48)
        screen.setMapColorSand(100, 93, 41)
        screen.setMapColorSnow(200, 200, 200)
    end
    screen.drawMap(B, C, H)
    bj, bk = map.mapToScreen(B, C, H, q, r, gpsX, gpsY)
    bm = bj
    bn = bk
    setC(4)
    for Z, bo in ipairs(waypoint_list) do
        o, p = map.mapToScreen(B, C, H, q, r, bo[1], bo[2])
        screen.drawLine(bm, bn, o, p)
        screen.drawCircleF(o + .5, p + .5, 2)
        bm = o
        bn = p
    end
    if waypoint_list[L] ~= nil then
        setC(5)
        o, p = map.mapToScreen(B, C, H, q, r, waypoint_list[L][1], waypoint_list[L][2])
        screen.drawCircleF(o + .5, p + .5, 3)
    end
    bp = math.pi * 2
    bq = 6
    setC(4)
    screen.drawTriangleF(bj + math.cos((heading - .25) * bp) * bq,
                         bk + math.sin((heading - .25) * bp) * bq,
                         bj + math.cos((heading + .35) * bp) * bq,
                         bk + math.sin((heading + .35) * bp) * bq,
                         bj + math.cos((heading + 1.15) * bp) * bq,
                         bk + math.sin((heading + 1.15) * bp) * bq)
    if not buttons[2][6] then
        screen.setColor(20, 20, 20)
        br = q / 2
        bs = r / 2
        screen.drawLine(br - 3, bs, br + 4, bs)
        screen.drawLine(br, bs - 3, br, bs + 4)
    end
    screen.setColor(10, 10, 10, 200)
    screen.drawRectF(0, 0, 18, r - 7)
    screen.drawRectF(q - 18, 0, 18, r - 7)
    screen.drawRectF(0, r - 7, q, 7)
    for Z, i in ipairs(buttons) do
        bb = i[2] > 0 and i[2] or (q + i[2])
        setC(i[6] and 3 or 2)
        screen.drawRectF(bb, i[3], i[4], 7)
        setC(1)
        screen.drawText(bb + (i[4] == 7 and 2 or 1), i[3] + 1, i[1])
    end
    setC(1)
    if K > 0 and q >= 96 then
        bt = tostring(K) .. "m"
        screen.drawText(q - (string.len(bt) * 5) - 1, r - 6, bt)
    end
    if q >= 96 then
        screen.drawText(2, r - 6,
                        tostring(math.ceil(B)) .. " " .. tostring(math.ceil(C)))
    end
end