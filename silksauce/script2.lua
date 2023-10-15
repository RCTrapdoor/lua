function wrap(num, min, max) return (num - min) % (max - min) + min end

function onTick()
    val = input.getNumber(1)
    dir_wrap =  wrap(val+45, 0, 360) // 90 + 1
    dir_string = ("NESW"):sub(dir_wrap, dir_wrap)
    wrapped = wrap(val, -45, 45) / 45
end

function onDraw()
    screen.drawText(25-wrapped*20, 40, string.format("%s", dir_string))
    for i = 1, 3 do
        screen.drawText(wrap(25 - (wrapped + i/2) * 20, 5, 45), 40, string.format("%s", "i"))
    end
end