---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "5x3")
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
        simulator:setInputBool(31, simulator:getIsClicked(1))       -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))        -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))       -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50)   -- set input 32 to the value from slider 2 * 50
    end;
end
---@endsection

function clamp(x, min, max)
    return math.min(math.max(x, min), max)
end

function vecLen(a)
    return math.sqrt(a.x^2 + a.y^2)
end

function vecSub(a, b)
    return {x = a.x - b.x, y = a.y - b.y}
end

function vecNormalize(a)
    local len = vecLen(a)
    return {x = a.x / len, y = a.y / len}
end

function rotate(v, angle)
    local s = math.sin(angle)
    local c = math.cos(angle)
    return {x = v.x * c - v.y * s, y = v.x * s + v.y * c}
end

function vecScale(v, scale)
    return {x = v.x * scale, y = v.y * scale}
end

ipos = {x = 0, y = 0}

function onTick()
    gps = {x=input.getNumber(6), y=input.getNumber(7)}
    alt = input.getNumber(8)
    compass = -input.getNumber(9) * math.pi * 2
    vs = input.getNumber(10)
    rs = input.getNumber(11)
    ys = input.getNumber(12)
    ps = input.getNumber(13)

    lau = input.getBool(6)

    if not ipos and lau then
        ipos = {x=gps.x, y=gps.y}
    end

    if ipos then
        if lau then
            ipos = {x=gps.x, y=gps.y}
        end

        local v = vecSub(ipos, gps) -- fra ipos til gps
        local len = vecLen(v) -- lengden på vektoren
        local v2 = rotate(v, compass) -- roter v med kompasset
        local norm = vecNormalize(v2) -- normaliser v2 (lengde 1)
        local target_speed = vecScale(norm, clamp(len/10, 0, 10))
        output.setNumber(1, target_speed.x)
        output.setNumber(2, target_speed.y)
    end
end

function onDraw()
    w, h = screen.getWidth(), screen.getHeight()
    screen.setColor(255, 0, 0)
    screen.drawText(1, 1, string.format("ipos: %6.f x %6.f - gps: %6.f x %6.f", ipos.x, ipos.y, gps.x, gps.y))
    screen.drawText(1, 10, string.format("alt: %6.f - compass: %6.f", alt, compass))
    screen.drawText(1, 20, string.format("vs: %6.f - rs: %6.f - ys: %6.f - ps: %6.f", vs, rs, ys, ps))
    screen.drawText(1, 30, string.format("lau: %s - len: %6.f", tostring(lau), vecLen(vecSub(ipos, gps))))
end