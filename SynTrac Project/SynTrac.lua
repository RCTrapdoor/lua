--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "3x1")
    simulator:setProperty("ExampleNumberProperty", 123)

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)

        -- NEW! button/slider options from the UI
        simulator:setInputBool(31, simulator:getIsClicked(1))                              -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(26, simulator:getSlider(1) + simulator:getSlider(2) * -1) -- set input 31 to the value of slider 1
        simulator:setInputNumber(7, m.sin(ticks))

        simulator:setInputBool(32, simulator:getIsToggled(2))     -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(3) * 50) -- set input 32 to the value from slider 2 * 50
    end

    ;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!
function onTick()
    VehLoc = { x = input.getNumber(1), y = input.getNumber(2), z = input.getNumber(3) }
    ex, ey, ez = input.getNumber(4), input.getNumber(5), input.getNumber(6)
    VVec = { x = input.getNumber(7), y = input.getNumber(8), z = input.getNumber(9) }
    AnVec = { x = input.getNumber(10), y = input.getNumber(11), z = input.getNumber(12) }
    AbsV = input.getNumber(13)
    AbsA = input.getNumber(14)
    RPS = m.sqrt(input.getNumber(15)) * 12.4722
    FLr = m.sqrt(input.getNumber(16)) * 12.4722
    RRr = m.sqrt(input.getNumber(17)) * 12.4722
    RLr = m.sqrt(input.getNumber(18)) * 12.4722
    SHd = input.getNumber(23)
    FRs = input.getNumber(19) - SHd
    FLs = input.getNumber(20) - SHd
    RRs = input.getNumber(21) - SHd
    RLs = input.getNumber(22) - SHd
    steer = input.getNumber(23)
    jumpDetected = input.getBool(1)
    charge = input.getNumber(25)
    drivemode = input.getNumber(32)
    throttle = input.getNumber(26) --clamp(input.getNumber(26)*1.1,-1,1)



    v1 = { 0, 0, 1 }
    v1 = rotZ(rotY(rotX(v1, ex), ey), ez)
    hdg = math.atan(v1[1], v1[3])
    elv = math.atan(v1[2], math.sqrt(v1[1] ^ 2 + v1[3] ^ 2))

    v2 = { 1, 0, 0 }
    v2 = rotZ(rotY(rotX(v2, ex), ey), ez)

    v3 = { 1, 0, 0 }
    v3 = rotY(rotX(v3, elv), hdg)

    crs = { v2[2] * v3[3] - v2[3] * v3[2], v2[3] * v3[1] - v2[1] * v3[3], v2[1] * v3[2] - v2[2] * v3[1] }
    sgn = (v1[1] * crs[1] + v1[2] * crs[2] + v1[3] * crs[3] >= 0) and 1 or -1
    crs = math.sqrt(crs[1] ^ 2 + crs[2] ^ 2 + crs[3] ^ 2) * sgn
    dot = v2[1] * v3[1] + v2[2] * v3[2] + v2[3] * v3[3]
    rol = math.atan(crs, dot)

    --output.setNumber(1,rol/pi2)
    --output.setNumber(2,elv/pi2)
    --output.setNumber(3,hdg/pi2)

    -- jump detection report

    if jumpDetected then
        jumpStatus = 'true!'
    else
        jumpStatus = 'false!'
    end

    -- torque vectoring!

    if throttle >= 0 then
        FRt = (clamp(throttle, 0, 1) ^ 2) * .5 * (0.825 / charge)
        FLt = (clamp(throttle, 0, 1) ^ 2) * .5 * (0.825 / charge)
        RRt = (clamp(throttle, 0, 1) ^ 2) * .5 * (0.825 / charge)
        RLt = (clamp(throttle, 0, 1) ^ 2) * .5 * (0.825 / charge)
    elseif throttle <= 0 then
        FRt = (clamp(throttle ^ 2, 0, 1)) * -.2 * (0.825 / charge)
        FLt = (clamp(throttle ^ 2, 0, 1)) * -.2 * (0.825 / charge)
        RRt = (clamp(throttle ^ 2, 0, 1)) * -.2 * (0.825 / charge)
        RLt = (clamp(throttle ^ 2, 0, 1)) * -.2 * (0.825 / charge)
    else
        FRt, FLt, RRt, RLt = 0, 0, 0, 0
    end
    output.setNumber(1, FRt)
    output.setNumber(2, FLt)
    output.setNumber(3, RRt)
    output.setNumber(4, RLt)
end

function onDraw()
    screen.setColor(255, 255, 255)
    screen.drawText(2, 2, "Hi")
    --delta = {x = 0,y = 0,z = 0}
    screen.drawText(52, 8, 'hello world')
    -- dStr(2, 2, 'Venture')
    -- dStr(2, 8, 'Sport')
    -- dStr(2, 14, 'Crawl')
    -- dStr(2, 20, 'Rally')
    -- dStr(30, 2, string.format("%.2f", FRs * 100))
    -- dStr(30, 8, string.format("%.2f", FLs * 100))
    -- dStr(30, 14, string.format("%.2f", RRs * 100))
    -- dStr(30, 20, string.format("%.2f", RLs * 100))
    -- --dStr(52,2,string.format("%.2f",deltaVVec.x))
    -- --dStr(52,8,string.format("%.2f",deltaVVec.y))
    -- dStr(52, 14, jumpStatus)
    -- dStr(52, 20, string.format("%.3f", 0))
end

-- vector library!
m = math
function vec(x, y, z) --defines a vector
    return { x = x or 0, y = y or 0, z = z or 0 }
end

function add(a, b) --adds 2 vectors
    return vec(a.x + b.x, a.y + b.y, a.z + b.z)
end

function mult(a, b) --multiplies 2 vectors
    return vec(a.x * b.x, a.y * b.y, a.z * b.z)
end

function multf(a, n) --multiplies a vector by a factor
    return vec(a.x * n, a.y * n, a.z * n)
end

function invert(a) --inverts a vector
    return multf(a, -1)
end

function subt(a, b) --subtracts a vector from another
    return add(a, invert(b))
end

function length(a) --gets length of a vector
    return m.sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
end

function divf(a, n) --divides vector by a factor
    return multf(a, 1 / n)
end

function norm(a) --normalizes a vector
    return divf(a, length(a))
end

function dot(a, b) --dot product between 2 vectors
    return a.x * b.x + a.y * b.y + a.z * b.z
end

function cross(a, b) --cross product between 2 vectors
    return vec(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
end

function project(a, b) --projects a vector by another
    return multf(norm(b), dot(a, norm(b)))
end

function reject(a, b) --rejects a vector by another
    return subt(a, multf(norm(b), dot(a, norm(b))))
end

function reflect(a, b, factor) --reflects a vector across another
    return subt(a, multf(reject(a, b), factor or 2))
end

function stoc(hor, ver, d) --spherical to cartesian conversion
    local d = d or 1
    return vec(m.sin(hor) * m.cos(ver) * d, m.cos(hor) * m.cos(ver) * d, m.sin(ver) * d)
end

function vecDelta(a, spot) --gets delta of a vector
    if not vecDeltaTable then
        vecDeltaTable = {}
        vecDeltaTable[spot] = { oldVec = vec(), deltaVec = vec() }
    elseif not vecDeltaTable[spot] then
        vecDeltaTable[spot] = { oldVec = vec(), deltaVec = vec() }
    end
    vecDeltaTable[spot].deltaVec = subt(a, vecDeltaTable[spot].oldVec)
    vecDeltaTable[spot].oldVec = a
    return vecDeltaTable[spot].deltaVec
end

font34 = {
    0x0D0, 0xC0C, 0xFAF, 0x2F4, 0xB2D, 0x6F5, 0x0C0, 0x690, 0x096, 0xAEA, 0x4E4, 0x560, 0x444, 0x010, 0x168, 0x79E,
    0x5F1,
    0x9B5, 0x9DA, 0x6F2, 0xDDA, 0x6DA, 0x9AC, 0x3FC, 0x4A7, 0x050, 0x1A0, 0x44A, 0xAAA, 0xA44, 0xA41, 0x69D, 0x7A7,
    0xFD6,
    0x699, 0xF96, 0xFD9, 0xFA8, 0x69B, 0xF2F, 0x9F9, 0x19E, 0xF4B, 0xF11, 0xF4F, 0xF6F, 0x696, 0xFA4, 0x6B7, 0xFA5,
    0x5BA,
    0x8F8, 0xE1E, 0xC3C, 0xF5F, 0x969, 0xC7C, 0xBD9, 0xF90, 0x861, 0x09F, 0x484, 0x111, 0x084, 0x2F9, 0x0F0, 0x9F4, 0x462 }

function dDot(x, y)
    screen.drawLine(x, y, x, y + 1)
end

function dChar(x, y, char)
    c = string.byte(string.upper(char)) - 32
    if c > 64 then c = c - 26 end
    if c > 0 and c < 69 then
        for i = 0, 11 do
            if font34[c] & (1 << (11 - i)) > 0 then dDot(x + i // 4, y + i % 4) end
        end
    end
end

function dStr(x, y, str)
    cs = string.len(str)
    for i = 0, cs - 1 do
        dChar(x + 4 * i, y, string.sub(str, i + 1, i + 1))
    end
end

pi = m.pi
pi2 = pi * 2
co = m.cos
si = m.sin

function rotX(x, r)
    return { x[1], co(r) * x[2] - si(r) * x[3], si(r) * x[2] + co(r) * x[3] }
end

function rotY(x, r)
    return { co(r) * x[1] + si(r) * x[3], x[2], -si(r) * x[1] + co(r) * x[3] }
end

function rotZ(x, r)
    return { co(r) * x[1] - si(r) * x[2], si(r) * x[1] + co(r) * x[2], x[3] }
end

function clamp(value, min, max)
    return math.min(max, math.max(min, value))
end
