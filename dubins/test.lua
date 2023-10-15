simulator:setScreen(1, "9x5")

local ms = os.clock()
for i = 1, 10000000 do
    x = 156 / 2
end
print(os.clock() - ms)

local ms = os.clock()
for i = 1, 10000000 do
    x = 156 * 0.5
end
print(os.clock() - ms)