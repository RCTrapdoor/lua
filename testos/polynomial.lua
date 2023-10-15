function polynomial(x, ...)
    local args = {...}
    local sum = 0
    for i = 1, #args do
        sum = sum + args[i] * x^(#args - i)
    end
    return sum
end

function nonan(x)
    if x == nil then
        return 0
    else
        return x
    end
end

function clamp(x, min, max)
    return math.max(min, math.min(max, nonan(x)))
end

for i = -3, 3, 0.1 do
    y = polynomial(i, 1, -2, 3, -4, 5)/polynomial(i, 3, -2, -3, 0)
    print(string.rep(" ", math.floor(40-clamp(y, -38, 38))) .. "#")
end
