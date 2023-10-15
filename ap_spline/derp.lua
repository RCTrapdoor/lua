-- function hsv_to_rgb(h, s, v)
--     -- takes input in the range 0-2pi, 0-1, 0-1
--     -- returns r, g, b in the range 0-255

--     local r, g, b

--     local i = math.floor(h * 6)

--     local f = h * 6 - i
--     local p = v * (1 - s)
--     local q = v * (1 - f * s)
--     local t = v * (1 - (1 - f) * s)

--     i = i % 6

--     if i == 0 then r, g, b = v, t, p
--     elseif i == 1 then r, g, b = q, v, p
--     elseif i == 2 then r, g, b = p, v, t
--     elseif i == 3 then r, g, b = p, q, v
--     elseif i == 4 then r, g, b = t, p, v
--     elseif i == 5 then r, g, b = v, p, q
--     end

--     return r * 255, g * 255, b * 255
-- end

-- width = 32
-- height = 32

-- function onDraw()
--     screen.setColor(255, 255, 255)
--     screen.drawText(34, 4, "HSV to RGB")
--     screen.drawText(34, 14, "255-0 red, 0-255 green")
--     screen.drawText(34, 24, "red to yellow,")
--     screen.drawText(34, 30, "then yellow to green")
--     for i = 0, width - 1 do
--         r, g, b = hsv_to_rgb((1/3) * i / width, 1, 1)
--         screen.setColor(r, g, b)
--         screen.drawLine(i, 0, i, height/3)

--         screen.setColor(255 - 255 * i / width, 255 * i / width, 0)
--         screen.drawLine(i, height/3, i, 2*height/3)

--         -- red to yellow to green
--         if i < width / 2 then
--             screen.setColor(255, 255 * i / (width / 2), 0)
--         else
--             screen.setColor(255 - 255 * (i - width / 2) / (width / 2), 255, 0)
--         end
--         screen.drawLine(i, 2*height/3, i, height)
--     end
-- end

vertices_orig = {
    {-1,  1, -2},
    { 1,  1, -2},
    { 1, -1, -2},
    {-1, -1, -2},
    {-1,  1,  1},
    { 1,  1,  1},
    { 1, -1,  1},
    {-1, -1,  1}
  }

edges = {
{1, 2},
{2, 3},
{3, 4},
{4, 1},
{5, 6},
{6, 7},
{7, 8},
{8, 5},
{1, 5},
{2, 6},
{3, 7},
{4, 8}
}

camera = {0, 0, 0}
camera_rot = {0, 0, 0}

function rotateX(v, angle)
    local x, y, z = v[1], v[2], v[3]
    local cos, sin = math.cos(angle), math.sin(angle)
    return {x, y * cos - z * sin, y * sin + z * cos}
end

function rotateY(v, angle)
    local x, y, z = v[1], v[2], v[3]
    local cos, sin = math.cos(angle), math.sin(angle)
    return {x * cos + z * sin, y, -x * sin + z * cos}
end

function rotateZ(v, angle)
    local x, y, z = v[1], v[2], v[3]
    local cos, sin = math.cos(angle), math.sin(angle)
    return {x * cos - y * sin, x * sin + y * cos, z}
end

function rotate(v, x, y, z)
    v = rotateX(v, x)
    v = rotateY(v, y)
    v = rotateZ(v, z)
    return v
end

function project(v)
    local x, y, z = v[1], v[2], v[3]
    local fov = 40
    local aspect = 1
    local near = 0.1
    local far = 100
    local f = 1 / math.tan(fov / 2)
    local a = f / aspect
    local b = (near + far) / (near - far)
    local c = (2 * near * far) / (near - far)
    return {a * x, f * y, (b * z) - c}
end

ticks = 0

function onTick()
    ticks = ticks + 1

    vertices = {}
    for i, v in ipairs(vertices_orig) do
        v = rotate(v, ticks / 100, ticks / 100, ticks / 100)
        v = {v[1] + camera[1], v[2] + camera[2], v[3] + camera[3]}
        v = project(v)
        vertices[i] = v
    end
end

function onDraw()
    screen.setColor(255, 255, 255)
    for i, e in ipairs(edges) do
        local v1 = vertices[e[1]]
        local v2 = vertices[e[2]]
        screen.drawLine(v1[1] * 32 + 32, v1[2] * 32 + 32, v2[1] * 32 + 32, v2[2] * 32 + 32)
    end
end