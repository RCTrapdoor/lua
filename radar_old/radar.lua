f = "1/11^2cos(11x)"
f2 = "+1/12^2*cos(12x)"
f3 = "-1/13^2*cos(13x)"
f4 = "+1/14^2*cos(14x)"
f5 = "-1/15^2*cos(15x)"
f6 = "+1/16^2*cos(16x)"
f7 = "-1/17^2*cos(17x)"
f8 = "+1/18^2*cos(18x)"
f9 = "-1/19^2*cos(19x)"
f10 = "+1/20^2*cos(20x)"

print(f..f2..f3..f4..f5..f6..f7..f8..f9..f10)

function onTick()
	inputX = input.getNumber(3)
	inputY = input.getNumber(4)
    isClick = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)

    if isClick then
        if isPointInRectangle(inputX, inputY, 1, 1, 15, 15) then
          isPressingRectangle = not isPressingRectangle
        elseif isPointInRectangle(inputX, inputY, 1, 25, 15, 15) then
          isPressingRectangle2 = not isPressingRectangle2
        end
      end

	output.setBool(1, isPressingRectangle)
end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end


function onDraw()
	screen.setColor(255, 0, 0)
	w = screen.getWidth()
	h = screen.getHeight()

    if isPressingRectangle then
        screen.setColor(0, 255, 0)
        screen.drawRectF(1, 1, 15, 15)
    else
        screen.setColor(255, 0, 0)
        screen.drawRectF(1, 1, 15, 15)
    end

    if isPressingRectangle2 then
        screen.setColor(0, 255, 0)
        screen.drawRectF(1, 25, 15, 15)
    else
        screen.setColor(255, 0, 0)
        screen.drawRectF(1, 25, 15, 15)
    end
end


