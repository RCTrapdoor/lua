h = {
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
    "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3",
    "4", "5", "6", "7", "8", "9", "_", "."
}
b = screen.drawText
n = screen.drawRect
H = {
    {
        14, 36, 3, 33, 11, 18, 24, 30, 23, 5, 34, 38, 35, 8, 19, 28, 9, 22, 12,
        1, 37, 16, 10, 32, 20, 21, 2, 15, 7, 31, 26, 6, 25, 27, 4, 17, 13, 29
    }, {
        30, 12, 9, 2, 25, 26, 5, 31, 16, 17, 20, 37, 4, 33, 10, 34, 8, 24, 28,
        36, 15, 6, 21, 7, 23, 18, 29, 11, 27, 32, 22, 3, 19, 35, 13, 38, 14, 1
    }, {
        34, 12, 5, 17, 10, 21, 32, 11, 28, 9, 18, 19, 24, 13, 15, 4, 29, 38, 20,
        35, 6, 14, 27, 36, 7, 22, 26, 31, 37, 25, 33, 23, 8, 16, 2, 3, 1, 30
    }, {
        22, 34, 2, 8, 4, 1, 19, 14, 24, 17, 31, 33, 29, 6, 26, 35, 30, 9, 21,
        25, 12, 10, 27, 3, 28, 36, 38, 13, 11, 16, 20, 23, 7, 18, 32, 37, 15, 5
    }, {
        8, 33, 27, 26, 11, 32, 17, 4, 20, 7, 22, 2, 31, 24, 23, 29, 21, 30, 12,
        16, 18, 5, 38, 13, 9, 10, 25, 35, 36, 15, 6, 37, 34, 1, 14, 19, 3, 28
    }, {
        4, 38, 33, 11, 17, 22, 3, 24, 28, 34, 8, 7, 16, 6, 19, 10, 20, 25, 29,
        18, 14, 5, 13, 9, 23, 32, 15, 21, 31, 30, 37, 36, 26, 35, 1, 27, 12, 2
    }, {
        12, 35, 33, 15, 10, 23, 28, 27, 19, 3, 22, 7, 37, 2, 14, 21, 38, 11, 36,
        5, 16, 25, 13, 31, 18, 20, 30, 17, 9, 34, 32, 26, 1, 4, 8, 6, 29, 24
    }, {
        9, 17, 13, 18, 21, 8, 28, 3, 14, 34, 33, 12, 25, 35, 16, 10, 22, 6, 31,
        19, 26, 15, 27, 7, 5, 38, 20, 23, 29, 37, 1, 36, 4, 30, 2, 24, 11, 32
    }, {
        3, 9, 36, 12, 30, 34, 5, 22, 35, 27, 6, 14, 8, 32, 21, 11, 28, 33, 2,
        31, 4, 19, 18, 16, 26, 24, 23, 15, 10, 25, 17, 20, 13, 29, 7, 37, 38, 1
    }, {
        15, 32, 25, 28, 8, 2, 38, 37, 12, 17, 29, 6, 31, 34, 36, 24, 20, 30, 5,
        26, 22, 7, 18, 11, 27, 4, 10, 16, 19, 1, 9, 35, 13, 3, 33, 21, 14, 23
    }, {
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38
    }
}
j = {1, 2, 3}
f = {0, 0, 0}
y = ""
o = ""
z = ""
p = 1
A = ""
set_coord = ""
B = ""
q = 0
C = true
e = ""
function onTick()
    J = input.getBool(8)
    if C and p > 0 and p <= #z then
        Q(z:sub(p, p))
        p = p + 1
    elseif D and q > 0 and q <= #B then
        R(B:sub(q, q))
        q = q + 1
    end
    K = input.getBool(1)
    if K and not I then
        c = input.getNumber(3)
        i = input.getNumber(4)
        if i > 40 and i < 50 then
            for a = 0, 15 do
                m = a * 10
                if c > m and c < m + 9 then e = e .. h[a + 1] end
            end
        elseif i > 50 and i < 60 then
            for a = 0, 9 do
                m = a * 10
                if c > m and c < m + 9 then e = e .. h[a + 17] end
            end
        elseif i > 60 and i < 70 then
            for a = 0, 11 do
                m = a * 10
                if c > m and c < m + 9 then e = e .. h[a + 27] end
            end
            if c > 141 and c < 160 then e = "" end
            if c > 121 and c < 139 then e = e:sub(1, #e - 1) end
        elseif i > 75 and i < 85 then
            if c < 80 then
                y = ""
                o = ""
                z = e
                p = 1
                D = false
                C = true
                e = ""
            else
                A = ""
                set_coord = ""
                B = e
                q = 1
                C = false
                D = true
                e = ""
            end
        else
            for a = 1, 3 do
                k = (a - 1) * 20
                if c > 1 + k and c < 8 + k then
                    j[a] = L(j[a] - 1)
                elseif c > 16 + k and c < 21 + k then
                    j[a] = L(j[a] + 1)
                end
            end
            for a = 1, 3 do
                k = (a - 1) * 20 + 80
                if c > 1 + k and c < 8 + k then
                    f[a] = (f[a] - 1) % 38
                elseif c > 16 + k and c < 21 + k then
                    f[a] = (f[a] + 1) % 38
                end
            end
        end
    elseif input.getBool(9) then
        e = ""
        for a = 1, 32 do
            M = input.getNumber(a)
            if M == 0 then
                a = 33
            else
                e = e .. h[M]
            end
        end
    end
    for a = 1, math.min(#o, 32) do
        output.setNumber(a, F(o:sub(a, a)))
    end
    I = K
end
function L(a, V)
    if a > 11 then a = a - 11 end
    if a < 1 then a = a + 11 end
    return a
end
function onDraw()
    if J then
        b(1, 1, o)
    else
        if C then
            b(0, 4, y)
            b(0, 14, o)
        elseif D then
            b(0, 4, A)
            b(0, 14, set_coord)
        else
            b(0, 4, z)
            b(0, 14, B)
        end
        b(0, 32, e)
        for a = 0, 15 do
            c = a * 10
            n(c, 40, 9, 9)
            b(c + 2, 42, h[a + 1])
        end
        for a = 0, 9 do
            c = a * 10
            n(c, 50, 9, 9)
            b(c + 2, 52, h[a + 17])
        end
        for a = 0, 11 do
            c = a * 10
            n(c, 60, 9, 9)
            b(c + 2, 62, h[a + 27])
        end
        n(121, 60, 19, 9)
        b(121 + 4, 62, "<-")
        n(141, 60, 19, 9)
        b(141 + 4, 62, "Cl")
        n(1, 75, 79, 9)
        b(30, 77, "Enc")
        n(81, 75, 79, 9)
        b(110, 77, "Dec")
        b(2, 87, "<")
        t(6, 87, j[1])
        b(16, 87, ">")
        b(22, 87, "<")
        t(26, 87, j[2])
        b(36, 87, ">")
        b(42, 87, "<")
        t(46, 87, j[3])
        b(56, 87, ">")
        b(62, 87, "Whl")
        b(82, 87, "<")
        t(86, 87, f[1])
        b(96, 87, ">")
        b(102, 87, "<")
        t(106, 87, f[2])
        b(116, 87, ">")
        b(122, 87, "<")
        t(126, 87, f[3])
        b(136, 87, ">")
        b(142, 87, "Pos")
    end
end
function t(c, i, E)
    if #E == 1 then E = "0" .. E end
    b(c, i, E)
end
function N(g, G)
    r = g + G
    if r > 38 then return r - 38 end
    return r
end
function W(g, G)
    r = g - G
    if r < 1 then return r + 38 end
    return r
end
function v(g, w) return H[j[w]][N(g, f[w])] end
function x(g, w)
    S = H[j[w]]
    for a = 1, 38 do if S[N(a, f[w])] == g then return a end end
end
function F(g)
    if g == " " then return 37 end
    for a = 1, 38 do if g == h[a] then return a end end
    return 38
end
function O()
    f[1] = (f[1] + 1) % 38
    if f[1] % 3 == 0 then
        f[2] = (f[2] + 1) % 38
        if f[2] % 3 == 0 then f[3] = (f[3] + 1) % 38 end
    end
end
function Q(g)
    y = y .. g
    distance = F(g)
    distance = v(distance, 1)
    distance = v(distance, 2)
    distance = v(distance, 3)
    distance = v(distance, 2)
    distance = v(distance, 1)
    O()
    o = o .. h[distance]
    return distance
end
function R(g)
    A = A .. g
    distance = F(g)
    distance = x(distance, 1)
    distance = x(distance, 2)
    distance = x(distance, 3)
    distance = x(distance, 2)
    distance = x(distance, 1)
    O()
    if distance == 37 then
        set_coord = set_coord .. " "
    else
        set_coord = set_coord .. h[distance]
    end
    return distance
end
