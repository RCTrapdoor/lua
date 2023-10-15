sum = 0
last_sum = 0
function onTick()
    sum = (sum + (10 + math.random(0, 9)) / 60) % 1
    print(sum, last_sum)
    if sum < last_sum then
        print("blink")
    end
    last_sum = sum
end