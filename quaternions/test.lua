simulator:setScreen(1, "9x5")

function Matrix(m)
    return {
        m = m or {
            {1, 0, 0, 0},
            {0, 1, 0, 0},
            {0, 0, 1, 0},
            {0, 0, 0, 1}
        }
    }
end

function Matrix_mul(m, v)
    return Vector(
        m.m[1][1] * v.x + m.m[1][2] * v.y + m.m[1][3] * v.z + m.m[1][4],
        m.m[2][1] * v.x + m.m[2][2] * v.y + m.m[2][3] * v.z + m.m[2][4],
        m.m[3][1] * v.x + m.m[3][2] * v.y + m.m[3][3] * v.z + m.m[3][4]
    )
end

function Vector(x, y, z)
    return {
        x = x or 0,
        y = y or 0,
        z = z or 0
    }
end

function Vector_add(a, b)
    return Vector(a.x + b.x, a.y + b.y, a.z + b.z)
end


function Vector_sub(a, b)
    return Vector(a.x - b.x, a.y - b.y, a.z - b.z)
end

function Vector_mul(a, b)
    return Vector(a.x * b, a.y * b, a.z * b)
end

function Vector_div(a, b)
    return Vector(a.x / b, a.y / b, a.z / b)
end

function Vector_dot(a, b)
    return a.x * b.x + a.y * b.y + a.z * b.z
end

function Vector_cross(a, b)
    return Vector(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
end

function Vector_length(a)
    return math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
end

function Vector_normalize(a)
    local l = Vector_length(a)
    return Vector(a.x / l, a.y / l, a.z / l)
end

function Vector_rotate(a, b)
    local m = Matrix()
    m.m[1][1] = math.cos(b.y) * math.cos(b.z)
    m.m[1][2] = math.cos(b.y) * math.sin(b.z)
    m.m[1][3] = -math.sin(b.y)
    m.m[2][1] = math.sin(b.x) * math.sin(b.y) * math.cos(b.z) + math.cos(b.x) * math.sin(b.z)
    m.m[2][2] = math.sin(b.x) * math.sin(b.y) * math.sin(b.z) - math.cos(b.x) * math.cos(b.z)
    m.m[2][3] = math.sin(b.x) * math.cos(b.y)
    m.m[3][1] = -math.cos(b.x) * math.sin(b.y) * math.cos(b.z) + math.sin(b.x) * math.sin(b.z)
    m.m[3][2] = -math.cos(b.x) * math.sin(b.y) * math.sin(b.z) - math.sin(b.x) * math.cos(b.z)
    m.m[3][3] = math.cos(b.x) * math.cos(b.y)
    return Matrix_mul(m, a)
end

function Quaternion(x, y, z, w)
    return {
        x = x,
        y = y,
        z = z,
        w = w
    }
end

function Quaternion_len(q)
    return math.sqrt(q.x * q.x + q.y * q.y + q.z * q.z + q.w * q.w)
end

function Quaternion_norm(q)
    local length = Quaternion_len(q)
    return Quaternion(q.x / length, q.y / length, q.z / length, q.w / length)
end

function Quaternion_conj(q)
    return Quaternion(-q.x, -q.y, -q.z, q.w)
end

function Quaternion_mul(q1, q2)
    return Quaternion(
        q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z,
        q1.x * q2.w + q1.w * q2.x + q1.y * q2.z - q1.z * q2.y,
        q1.y * q2.w + q1.w * q2.y + q1.z * q2.x - q1.x * q2.z,
        q1.z * q2.w + q1.w * q2.z + q1.x * q2.y - q1.y * q2.x
    )
end

function Quaternion_mulVec(q, v)
    local qv = Quaternion(v.x, v.y, v.z, 0)
    local qq = Quaternion_mul(q, qv)
    local qqq = Quaternion_mul(qq, Quaternion_conj(q))
    return Vector(qqq.x, qqq.y, qqq.z)
end

box_vertices = {
    Vector(-20, -20, -20),
    Vector(-20, -20, 20),
    Vector(-20, 20, -20),
    Vector(-20, 20, 20),
    Vector(20, -20, -20),
    Vector(20, -20, 20),
    Vector(20, 20, -20),
    Vector(20, 20, 20)
}

edges = {
    {1, 2},
    {1, 3},
    {1, 5},
    {2, 4},
    {2, 6},
    {3, 4},
    {3, 7},
    {4, 8},
    {5, 6},
    {5, 7},
    {6, 8},
    {7, 8}
}

ticks = 0

function onTick()
    ticks = ticks + 1

    angle = (ticks / 60) * math.pi * 2
    q = Quaternion(0, angle, 0, 1)
end


function onDraw()

    w, h = screen.getWidth(), screen.getHeight()
    cx, cy = w / 2, h / 2

    for e = 1, #edges do
        local v1 = box_vertices[edges[e][1]]
        local v2 = box_vertices[edges[e][2]]
        screen.drawLine(cx + v1.x, cy + v1.y, cx + v2.x, cy + v2.y)
    end
end