h = 255
C = 100
tostring = tostring
Y = tonumber
N = false
F = true
al = input
W = property
ae = output
M = math
P = screen
screen.drawLine = P.drawLine
screen.drawRect = P.drawRect
screen.setColor = P.setColor
math.abs = M.abs
math.sin = M.sin
math.floor = M.floor
output.setBool = ae.setBool
string.sub = string.sub
property.getText = W.getText
property.getNumber = W.getNumber
property.getBool = W.getBool
input.getBool = al.getBool
input.getNumber = al.getNumber
f = M.pi
aA = 9
aF = -20
m = {}
o = {}
ab = {}
a = {}
aJ = F
aB = N
aH = F
ao = {}
ah = {}
ai = {}
aj = {}
q = 0
j = 0
b = 0
pi = f
aD = F
c = 0
g = 0
Z, S, X = 0, 0, 0
s = 3
for _ = 1, 8 do
    ao[_] = {}
    ah[_] = {}
    ai[_] = {}
    aj[_] = {}
    for k = 1, 5 do
        ao[_][k] = 0
        ah[_][k] = 0
        ai[_][k] = N
        aj[_][k] = 0
    end
end
function onTick()
    ar = input.getNumber(4)
    at = input.getNumber(8)
    u = input.getNumber(12)
    L = input.getNumber(16)
    ad = input.getNumber(20)
    af = input.getNumber(24)
    J = input.getNumber(28)
    as = input.getBool(11)
    enable_radar_tracking = property.getBool("Enable Radar Tracking")
    HUD_orientation = property.getNumber("HUD Orientation 1 (Arrow Direction)")
    blocks_from_seat = property.getNumber("Blocks From Front Of Seat")
    radar_orientation = property.getBool("Radar Orientation")
    minimum_radar_distance = property.getNumber("Minimum Radar Distance")
    radar_distance_units = property.getNumber("Radar Distance Units")
    B = input.getBool(12)
    color_value = property.getText("Color Value")
    brightness = (property.getNumber("Brightness") + .5) / 1.5
    Z, S, X = Y(string.sub(color_value, 1, 3)), Y(string.sub(color_value, 5, 7)), Y(string.sub(color_value, 9, 11))
    if B then
        s = 1
        aG = 1
    end
    if radar_orientation then
        R = -1
    else
        R = 1
    end
    if blocks_from_seat == 0 then
        b = 50
        if B then b = 42 end
    elseif blocks_from_seat == 1 then
        b = 90
        if B then b = 80 end
    elseif blocks_from_seat == 2 then
        b = 125
        if B then b = 115 end
    elseif blocks_from_seat == 3 then
        b = 150
    elseif blocks_from_seat == 4 then
        b = 165
    elseif blocks_from_seat == .5 then
        b = 75
    end
    if HUD_orientation == 1 then
        q = 0
        j = -10
    elseif HUD_orientation == 2 then
        q = 4
        j = -5
    elseif HUD_orientation == 3 then
        q = 0
        j = 0
        if B then
            j = 8
        end
    elseif HUD_orientation == 4 then
        q = -4
        j = -5
    end
    for _ = 1, 8 do
        m[_] = input.getNumber((_ - 1) * 4 + 2) * R
        o[_] = input.getNumber((_ - 1) * 4 + 3) * R
        ab[_] = input.getBool(_)
        a[_] = input.getNumber((_ - 1) * 4 + 1)
    end
    aw = input.getBool(10)
    ae.setNumber(1, u)
    output.setBool(1, c > 0)
    output.setBool(2, g > 0)
end

function aE(E, v, d)
    if E > d then
        return d
    elseif E < v then
        return v
    else
        return E
    end
end

function e(e)
    if radar_distance_units == 2 then
        e = e * 3.28084
        if e > 5280 then
            return (math.floor(e / 528) / 10)
        end
        return math.floor(e / C) * C
    end
    if e > 1000 then
        return (math.floor(e / C) / 10)
    end
    return (math.floor(e / C) * C)
end

function onDraw()
    if as and enable_radar_tracking then
        z = math.sin(ar * f * 2.2) * 9 * (s / 3)
        x = math.sin(at * f * 2.1) * -20 * (s / 3)
        g = 0
        c = 0
        I = 0
        for _ = 8, 1, -1 do
            if ab[_] then
                w = math.sin(m[_] * f * 2) * b * (s / 3)
                y = math.sin(o[_] * f * 2) * b * (s / 3)
                if _ > 1 then
                    D = F
                    for k = _ - 1, 1, -1 do
                        if (math.abs((o[_]) - o[k]) < .008) and (math.abs((m[_]) - m[k]) < .008) then D = N end
                    end
                    if D then
                        if a[_] > minimum_radar_distance then
                            if u > math.abs(m[_]) and L > math.abs(o[_]) and a[_] > ad and a[_] < af then
                                if a[_] < J and c == 0 then
                                    c = _
                                elseif g == 0 or (a[_] < I) and a[_] > J and c == 0 then
                                    g = _
                                    I = a[_]
                                end
                            end
                        end
                    end
                else
                    if a[_] > minimum_radar_distance then
                        if u > math.abs(m[_]) and L > math.abs(o[_]) and a[_] > ad and a[_] < af then
                            if a[_] < J and c == 0 then
                                c = _
                            elseif g == 0 or (a[_] < I) and a[_] > J and c == 0 then
                                g = _
                                I = a[_]
                            end
                        end
                    end
                end
            end
        end
        if c > 0 then g = 0 end
        for _ = 8, 1, -1 do
            if ab[_] then
                w = math.sin(m[_] * f * 2) * b * (s / 3)
                y = math.sin(o[_] * f * 2) * b * (s / 3)
                screen.setColor(Z, S, X)
                if _ > 1 then
                    D = F
                    for k = _ - 1, 1, -1 do
                        if (math.abs((o[_]) - o[k]) < .008) and (math.abs((m[_]) - m[k]) < .008) then D = N end
                    end
                    if D then
                        if a[_] > minimum_radar_distance then
                            if c == _ then
                                screen.setColor(h, 0, 0)
                            elseif g == _ then
                                screen.setColor(h, h, 0)
                            end
                            T = e(a[_])
                            V((15 + z + w) * 3 + q - 1, (14 + x - y) * 3 + j - 1, tostring(T))
                            screen.drawRect((16 + z + w) * 3 + q - 2, (12 + x - y) * 3 + j - 2, 4, 4)
                        end
                    end
                else
                    if a[_] > minimum_radar_distance then
                        if c == _ then
                            screen.setColor(h, 0, 0)
                        elseif g == _ then
                            screen.setColor(h, h, 0)
                        end
                        T = e(a[_])
                        V((15 + z + w) * 3 + q - 1, (14 + x - y) * 3 + j - 1, tostring(T))
                        screen.drawRect((16 + z + w) * 3 + q - 2, (12 + x - y) * 3 + j - 2, 4, 4)
                    end
                end
            end
        end
        if u > 0 then
            screen.setColor(Z, S, X)
            if c > 0 then
                screen.setColor(h, 0, 0)
            elseif g > 0 then
                screen.setColor(h, h, 0)
            end
            screen.drawRect(48 + (z - math.sin(u * f * 2) * b) * 3 + q, 36 + (x - math.sin(L * f * 2) * b) * 3 + j, 6 * math.sin(u * f * 2) * b,
                6 * math.sin(L * f * 2) * b)
        end
        if aw then
            screen.setColor(h, 0, 0)
            screen.drawLine(1, 1, 10, 1)
            screen.drawLine(1, 1, 1, 10)
            screen.drawLine(95, 95, 95, 88)
            screen.drawLine(95, 95, 86, 95)
            screen.drawLine(1, 95, 1, 86)
            screen.drawLine(1, 95, 10, 95)
            screen.drawLine(95, 1, 86, 1)
            screen.drawLine(95, 1, 95, 10)
            V(29, 82, "RADAR WARN")
        end
    end
end

local ax = property.getText("f")
function V(aq, az, am, aI) for _ = 1, am:len() do
        d = am:sub(_, _):upper():byte() * 4 - 127
        if d > 257 then d = d - 104 end
        E = "0x" .. ax:sub(d, d + 3)
        for ac = 0, 14 do if E & (1 << (14 - ac)) > 0 then
                v = aq + ac // 5 + (_ - 1) * 4
                d = az + ac % 5
                screen.drawLine(v, d, v, d + 1)
            end end
    end end
