letters = "QWERTYUIOPASDFGHJKLZXCVBNM"

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
    return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end

text = ""

function onTick()
    pressedLetter = 0
    click = input.getBool(1) and not isPressed
    isPressed = input.getBool(1)
    inputX = input.getNumber(3)
    inputY = input.getNumber(4)
    
    if click then
        if isPointInRectangle(inputX, inputY, 13, 0, 80, 9) then -- first row
            pressedLetter = math.ceil((inputX-13)/8)
        elseif isPointInRectangle(inputX, inputY, 15, 9, 71, 9) then -- second row
            pressedLetter = math.ceil(10+(inputX-15)/8)
        elseif isPointInRectangle(inputX, inputY, 19, 18, 56, 9) then -- third row
            pressedLetter = math.ceil(19+(inputX-19)/8)
        end
        print(pressedLetter, string.sub(letters, pressedLetter, pressedLetter))
        text = text .. string.sub(letters, pressedLetter, pressedLetter)
    end
    
end

function onDraw()
    for i = 1, 10 do -- First row
        if i == pressedLetter then
            screen.setColor(255, 255, 255)
        else
            screen.setColor(100,100,100)
        end
        screen.drawRect(13+(i-1)*8, 0, 8, 9)
        screen.drawText(13+(i-1)*8+2, 2, string.sub(letters, i, i))
    end
    for i = 11, 19 do -- Second row
        if i == pressedLetter then
            screen.setColor(255, 255, 255)
        else
            screen.setColor(100,100,100)
        end
        screen.drawRect(15+(i-11)*8, 9, 8, 9)
        screen.drawText(15+(i-11)*8+2, 10, string.sub(letters, i, i))
    end
    for i = 20, 26 do -- Third row
        if i == pressedLetter then
            screen.setColor(255, 255, 255)
        else
            screen.setColor(100,100,100)
        end
        screen.drawRect(19+(i-20)*8, 18, 8, 9)
        screen.drawText(19+(i-20)*8+2, 20, string.sub(letters, i, i))
    end

    screen.setColor(255, 255, 255)
    screen.drawText(2, 40, text)
end