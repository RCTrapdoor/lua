function onTick()
	touchX = input.getNumber(3)
	touchY = input.getNumber(4)
	isPressed = input.getBool(1) or input.getBool(2)

    pressed = nil
    if isPressed and touchX < 21 and touchY < 28 then
        pressed = 3 * (touchY // 7) + touchX // 7
    end

    if pressed then
	    output.setBool(pressed + 1, isPressed)
    end
end

function onDraw()
    screen.setColor(255, 255, 255)

    for i = 0, 11 do
        screen.drawRect(i % 3 * 7, i // 3 * 7, 7, 7)
    end

    screen.setColor(255, 0, 0)
    screen.drawRect(0, 21, 7, 7)
    screen.setColor(0, 255, 0)
    screen.drawRect(14, 21, 7, 7)

    screen.setColor(255, 255, 255)
    
    if pressed then
        screen.drawRectF(pressed % 3 * 7 + 1, pressed // 3 * 7 + 1, 6, 6)
    end
end