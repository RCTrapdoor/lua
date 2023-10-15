b = {}
c = {}
distance = {}
e = {}

val = 0

function onTick()
    val = val + 1
    a = {
        val - 80, val - 60, val - 40, val - 20, val + 20, val + 40, val + 60,
        val + 80
    }
    -- station 1
    if a[1] >= 0 and a[1] < 20 then
        b[1] = true
    elseif a[1] > 340 and a[1] >= 360 then
        b[1] = true
    else
        b[1] = false
    end
    if a[1] > 80 and a[1] < 100 then
        b[2] = true
    else
        b[2] = false
    end
    if a[1] > 170 and a[1] < 190 then
        b[3] = true
    else
        b[3] = false
    end
    if a[1] > 260 and a[1] < 280 then
        b[4] = true
    else
        b[4] = false
    end

    -- station 2
    if a[2] >= 0 and a[2] < 20 then
        c[1] = true
    elseif a[2] > 340 and a[2] >= 360 then
        c[1] = true
    else
        c[1] = false
    end
    if a[2] > 80 and a[2] < 100 then
        c[2] = true
    else
        c[2] = false
    end
    if a[2] > 170 and a[2] < 190 then
        c[3] = true
    else
        c[3] = false
    end
    if a[2] > 260 and a[2] < 280 then
        c[4] = true
    else
        c[4] = false
    end

    -- station 3
    if a[3] >= 0 and a[3] < 20 then
        distance[1] = true
    elseif a[3] > 340 and a[3] >= 360 then
        distance[1] = true
    else
        distance[1] = false
    end
    if a[3] > 80 and a[3] < 100 then
        distance[2] = true
    else
        distance[2] = false
    end
    if a[3] > 170 and a[3] < 190 then
        distance[3] = true
    else
        distance[3] = false
    end
    if a[3] > 260 and a[3] < 280 then
        distance[4] = true
    else
        distance[4] = false
    end

    -- station 4
    if a[4] >= 0 and a[4] < 20 then
        e[1] = true
    elseif a[4] > 340 and a[4] >= 360 then
        e[1] = true
    else
        e[1] = false
    end
    if a[4] > 80 and a[4] < 100 then
        e[2] = true
    else
        e[2] = false
    end
    if a[4] > 170 and a[4] < 190 then
        e[3] = true
    else
        e[3] = false
    end
    if a[4] > 260 and a[4] < 280 then
        e[4] = true
    else
        e[4] = false
    end

end

function onDraw()
    screen.setColor(138, 161, 175)
    -- section 1
    if b[1] then screen.drawText(7, 57, "N") end
    if b[2] then screen.drawText(7, 57, "E") end
    if b[3] then screen.drawText(7, 57, "S") end
    if b[4] then screen.drawText(7, 57, "W") end
    if b[1] == false and b[2] == false and b[3] == false and b[4] == false then
        screen.drawLine(9, 57, 9, 62)
    end
    -- section 2
    if c[1] then screen.drawText(15, 57, "N") end
    if c[2] then screen.drawText(15, 57, "E") end
    if c[3] then screen.drawText(15, 57, "S") end
    if c[4] then screen.drawText(15, 57, "W") end
    if c[1] == false and c[2] == false and c[3] == false and c[4] == false then
        screen.drawLine(17, 57, 17, 62)
    end
    -- section 3
    if distance[1] then screen.drawText(23, 57, "N") end
    if distance[2] then screen.drawText(23, 57, "E") end
    if distance[3] then screen.drawText(23, 57, "S") end
    if distance[4] then screen.drawText(23, 57, "W") end
    if distance[1] == false and distance[2] == false and distance[3] == false and distance[4] == false then
        screen.drawLine(25, 57, 25, 62)
    end
    -- section 4
    if e[1] then screen.drawText(31, 57, "N") end
    if e[2] then screen.drawText(31, 57, "E") end
    if e[3] then screen.drawText(31, 57, "S") end
    if e[4] then screen.drawText(31, 57, "W") end
    if e[1] == false and e[2] == false and e[3] == false and e[4] == false then
        screen.drawLine(33, 57, 33, 62)
    end
end