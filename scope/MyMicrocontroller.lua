---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "20x3")
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
        simulator:setInputBool(31, simulator:getIsClicked(1))     -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))      -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))     -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
    end

    ;
end
---@endsection

colors = {
    yellow = { 255, 255, 0 },
    green = { 0, 255, 0 },
    red = { 255, 0, 0 },
    blue = { 0, 0, 255 },
    white = { 255, 255, 255 },
    black = { 0, 0, 0 }
}

numPlots = 3

lanczos = {}
for i = 0, 15 do
    local x = i / 1000
    if x == 0 then
        lanczos[i] = 1
    else
        lanczos[i] = math.sin(math.pi * x) / (math.pi * x) * math.sin(math.pi * x / 3) / (math.pi * x / 3)
    end
end

function lanczos1d(points, width)
    local inSamples = #points
    local ratio = inSamples / width
    local out = {}
    for i = 1, width do
        local sum = 0
        local center = (i - 0.5) * ratio
        for j = 0, ratio do
            local x = center - j
            local xInt = math.floor(x)
            local xFrac = x - xInt
            if xInt >= 0 and xInt < inSamples then
                sum = sum + points[xInt + 1] * lanczos[math.floor(xFrac + 0.5) * 15]
            end
        end
        out[i] = sum
    end
    return out
end

a = 5.3
b = 4

print(math.type(a))
print(math.type(b))

function lerp(iS, iE, oS, oE, v)
    return oS + ((oE - oS) / (iE - iS)) * (v - iS)
end

function sgn(x)
    return x >= 0 and 1 or -1
end

function real_root(x, n)
    return sgn(x) * math.abs(x) ^ n
end

function setColor(color)
    screen.setColor(table.unpack(color))
end

newdata = {}
function plot(data, x, y, w, h, yspan, yoffset, color) -- draw continuous line graph
    local fitted_data = lanczos1d(data, w)
    local min, max, min_fit, max_fit = math.huge, -math.huge, math.huge, -math.huge

    for i = 1, #data do
        min = math.min(data[i], min)
        max = math.max(data[i], max)
    end

    for i = 1, #fitted_data do
        min_fit = math.min(fitted_data[i], min_fit)
        max_fit = math.max(fitted_data[i], max_fit)
    end

    setColor(colors.white)
    screen.drawLine(x, y + h / 2, x + w, y + h / 2)
    setColor(color)
    for i = 2, #fitted_data - 1 do
        local y1 = lerp(min_fit, max_fit, y+h, y, fitted_data[i])
        local y2 = lerp(min_fit, max_fit, y+h, y, fitted_data[i + 1])
        -- screen.drawLine(x + i - 1, y + h - (data[i] * h * yspan + yoffset), x + i, y + h - (data[i + 1] * h * yspan + yoffset))
        screen.drawLine(x + i, y1, x + i + 1, y2)
            
    end
    screen.drawText(x + w, 0, max)
    screen.drawText(x + w, y + h / 2, (max + min) / 2)
    screen.drawText(x + w, y + h, min)
end

data = {}
num = 1000

ticks = num

for ticks = 1, num do
    data[ticks] = real_root((-500 + ticks) / 100, 0.2)
    -- print(data[ticks])
end

function onTick()
    ticks = ticks + 1
    output.setNumber(1, #newdata)
    -- add a new data point to the end of the data table
    -- table.insert(data, (math.cos(ticks / 10) + math.sin(ticks / 13)) * 2)

    -- remove the oldest data point if we have too many
    if #data > num then
        table.remove(data, 1)
    end

    -- resample the data to the width of the screen
    width = math.max(10, input.getNumber(3))
    height = input.getNumber(4)
end

function onDraw()
    plot(data, 10, 10, 300, 76, 1, 0, colors.blue)
    plot(data, 10, 10, width, 76, 1, 0, colors.green)
end
