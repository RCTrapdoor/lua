math.randomseed(1)
t = {}
for i = 1, 10000 do
t[i] = math.random()
end

-- find repeating patterns
for i = 1, #t do
    for j = i+1, #t do
        if t[i] == t[j] then
            print(i, j, t[i])
        end
    end
end