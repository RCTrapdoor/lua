simulator:setScreen(1, "9x5")
print("\n\n")
local U = {x = 50, z = 70}

local A = {x = 10, z = 135}

local B = {x = 210, z = 30}

function vecSub(a, b) return {x = a.x - b.x, z = a.z - b.z} end

function vecLen(a) return math.sqrt(a.x * a.x + a.z * a.z) end

function vecMul(a, b) return {x = a.x * b, z = a.z * b} end

function vecDot(a, b) return a.x * b.x + a.z * b.z end

function vecAdd(a, b) return {x = a.x + b.x, z = a.z + b.z} end

function onTick()
    if input.getBool(1) then
        U = {x = input.getNumber(3), z = input.getNumber(4)}
    end

    local a = vecSub(U, A)
    local b = vecSub(B, A)
    local projection = vecDot(a, b) / vecLen(b)
    local b_norm = vecMul(b, 1 / vecLen(b))

    N = vecAdd(A, vecMul(b_norm, projection + 20))

    C = vecAdd(A, vecMul(b_norm, projection))
end

function onDraw()
    -- A
    local alpha = 200
    screen.setColor(255, 0, 0, alpha)
    screen.drawLine(A.x, A.z, B.x, B.z)
    screen.drawCircle(A.x, A.z, 6)
    screen.setColor(255, 0, 0, 255)
    screen.drawText(A.x - 2, A.z - 2, "A")

    -- B
    screen.setColor(0, 255, 0, alpha)
    screen.drawCircle(B.x, B.z, 6)
    screen.setColor(0, 255, 0, 255)
    screen.drawText(B.x - 2, B.z - 2, "B")

    -- C
    screen.setColor(0, 0, 255, alpha)
    screen.drawLine(C.x, C.z, U.x, U.z)
    screen.drawCircle(C.x, C.z, 6)
    screen.setColor(0, 0, 255, 255)
    screen.drawText(C.x - 2, C.z - 2, "C")

    -- N
    screen.setColor(255, 255, 0, alpha)
    screen.drawLine(N.x, N.z, U.x, U.z)
    screen.drawCircle(N.x, N.z, 6)
    screen.setColor(255, 255, 0, 255)
    screen.drawText(N.x - 2, N.z - 2, "N")

    -- U
    screen.setColor(0, 255, 255, alpha)
    screen.drawCircle(U.x, U.z, 6)
    screen.setColor(0, 255, 255, 255)
    screen.drawText(U.x - 2, U.z - 2, "U")

    -- white lines
    screen.setColor(255, 255, 255, alpha)
    screen.drawLine(A.x, A.z, U.x, U.z)
    screen.drawLine(A.x, A.z, C.x, C.z)
end
