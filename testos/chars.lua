function onDraw()
    for i = 1, 255 do
        screen.drawText(((i - 1) // 30) * 35, ((i - 1) % 30) * 7, string.format('%03.f: %s', i, string.char(i)))
    end
end