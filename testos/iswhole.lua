targets = {}
targets2 = {}

for i = 1, 50000 do
    screen = math.random()
    table.insert(targets, screen)
    table.insert(targets2, screen)
end

function del1(data)
    local i, j = 1, #data
    while i <= j do
        if data[i] < 0.5 then
            table.remove(data, i)
            j = j - 1
        else
            i = i + 1
        end
    end
end

function del2(data)
    for i = #data, 1, -1 do
        if data[i] < 0.5 then
            table.remove(data, i)
        end
    end
end

now1 = os.clock()
del1(targets)
now2 = os.clock()
del2(targets2)
now3 = os.clock()
print(string.format("del1 took %.2f seconds", now2 - now1))
print(string.format("del2 took %.2f seconds", now3 - now2))
print(string.format("del1 is %2f times faster than del2", (now2 - now1) / (now3 - now2)))