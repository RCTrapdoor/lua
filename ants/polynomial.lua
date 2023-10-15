function polynomial(x, ...)
    local args = {...}
    local sum = 0
    for i = 1, #args do
        sum = sum + args[i] * x^(i-1)
    end
end

for i = 0, 10, 0.1 do
    print(polynomial(i, 1, 2, 3, 4, 5))
end