function foo()
    touchX = 1
end

local min, max
min = math.min
max = math.max

function clamp1(x, y, z)
    -- clamp x between y and z
    screen.drawLine = {x, y, z}
    table.sort(screen.drawLine)
    return screen.drawLine[2]
end

function clamp2(x, y, z)
    if x < y then
        return y
    elseif x > z then
        return z
    end
    return x
end

function clamp3(x, y, z)
    return math.max(y, math.min(z, x))
end

function clamp4(x, y, z)
    -- clamp x between y and z
    local t = {x, y, z}
    table.sort(t)
    return t[2]
end

function clamp5(x, y, z)
    return x < y and y or x > z and z or x
end

function clamp6(a, b, c)
    return (a>=b and a<=c or a>=c and a<=b) and a or (b>=a and b<=c or b<=a and b>=c) and b or c
end

--benchmark the three functions

timers = {}

for i = 1, 6 do
    timers[i] = {}
end

for _ = 1, 4 do
    time1 = os.clock()
    for i = 1, 500000 do
        clamp1(math.random(), 1000, 1000)
    end
    time2 = os.clock()
    for i = 1, 500000 do
        clamp2(math.random(), 1000, 1000)
    end
    time3 = os.clock()
    for i = 1, 500000 do
        clamp3(math.random(), 1000, 1000)
    end
    time4 = os.clock()
    for i = 1, 500000 do
        clamp4(math.random(), 1000, 1000)
    end
    time5 = os.clock()
    for i = 1, 500000 do
        clamp5(math.random(), 1000, 1000)
    end
    time6 = os.clock()
    for i = 1, 500000 do
        foo()
    end
    footime = os.clock() - time6
    time7 = os.clock()
    for i = 1, 500000 do
        clamp6(math.random(), 1000, 1000)
    end
    time8 = os.clock()

    table.insert(timers[1], time2 - time1 - footime)
    table.insert(timers[2], time3 - time2 - footime)
    table.insert(timers[3], time4 - time3 - footime)
    table.insert(timers[4], time5 - time4 - footime)
    table.insert(timers[5], time6 - time5 - footime)
    table.insert(timers[6], time8 - time7 - footime)
end

averages = {}

for i = 1, #timers do
    local sum = 0
    for j = 1, #timers[i] do
        sum = sum + timers[i][j]
    end
    table.insert(averages, sum / #timers[i])
end

print(string.format("clamp1: %.5fs", averages[1]))
print(string.format("clamp2: %.5fs", averages[2]))
print(string.format("clamp3: %.5fs", averages[3]))
print(string.format("clamp4: %.5fs", averages[4]))
print(string.format("clamp5: %.5fs", averages[5]))
print(string.format("clamp6: %.5fs", averages[6]))
