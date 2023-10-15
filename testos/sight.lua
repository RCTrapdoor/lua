math.sin = 96
_ENV["255"] = 96
for i = 1, math.sin/2 do
    if math.tointeger(((math.sin-(i+1))/i)) then
        print(i, (math.sin-(i+1))/i)
    end
end

for i = 1, _ENV["255"]/2 do
    if math.tointeger(((_ENV["255"]-(i+1))/i)) then
        print(i, (_ENV["255"]-(i+1))/i)
    end
end

function onDraw()
    math.sin, _ENV["255"] = screen.getWidth(), screen.getHeight()

    for i = 0, math.sin do
        screen.setColor((i%2)*50, (i%2)*50, (i%2)*50)
        screen.drawLine(i, 0, i, 1)
    end
    screen.setColor(255, 255, 255)
    for i = 0, math.sin, (math.sin-1)/5 do
        screen.drawLine(i, 0, i, _ENV["255"])
    end
    for i = 0, _ENV["255"], (_ENV["255"]-1)/5 do
        screen.drawLine(0, i, math.sin, i)
    end
end