keypad = {}
toggleTimer = 0
function onTick()
	output.setBool(1, false)
	toggleTimer = toggleTimer - 1
	toggled = toggleTimer > 0 and toggled or nil
	isClick = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)
	pressed = input.getBool(1)
	X = input.getNumber(3)
	Y = input.getNumber(4)
	if isClick then
		if isPointInRectangle(X, Y, 2, 11, 8, 9) then
			table.insert(keypad, 1)
			toggled = 1
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 12, 11, 8, 9) then
			table.insert(keypad, 2)
			toggled = 2
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 22, 11, 8, 9) then
			table.insert(keypad, 3)
			toggled = 3
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 32, 11, 8, 9) then
			table.insert(keypad, 4)
			toggled = 4
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 42, 11, 8, 9) then
			table.insert(keypad, 5)
			toggled = 5
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 53, 11, 8, 9) then
			table.insert(keypad, 6)
			toggled = 6
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 64, 11, 8, 9) then
			table.insert(keypad, 7)
			toggled = 7
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 2, 22, 8, 8) then
			table.insert(keypad, 8)
			toggled = 8
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 12, 22, 8, 8) then
			table.insert(keypad, 9)
			toggled = 9
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 22, 22, 8, 8) then
			table.insert(keypad, 0)
			toggled = 10
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 32, 22, 28, 8) then
			toggled = 11
			keypadNumber = tonumber(table.concat(keypad))
			output.setBool(1, true)
			toggleTimer = 10
		elseif isPointInRectangle(X, Y, 62, 22, 10, 8) then
			toggled = 12
			table.remove(keypad)
			toggleTimer = 10
		end

		keypad[7] = nil
		keypadNumber = tonumber(table.concat(keypad))
		output.setNumber(1, keypadNumber)

	end

	function onDraw()
		screen.setColor(201, 157, 12)

		for i = 1, 10 do
			screen.drawText(2 + ((i-1)%8) * 10, 11*(i // 8 + 1), string.format("%d", i))
		end

		if toggled == 1 then
			screen.drawRectF(2, 11, 8, 9)
		elseif toggled == 2 then
			screen.drawRectF(12, 11, 8, 9)
		elseif toggled == 3 then
			screen.drawRectF(22, 11, 8, 9)
		elseif toggled == 4 then
			screen.drawRectF(32, 11, 8, 9)
		elseif toggled == 5 then
			screen.drawRectF(42, 11, 8, 9)
		elseif toggled == 6 then
			screen.drawRectF(53, 11, 8, 9)
		elseif toggled == 7 then
			screen.drawRectF(64, 11, 8, 9)
		elseif toggled == 8 then
			screen.drawRectF(2, 22, 8, 8)
		elseif toggled == 9 then
			screen.drawRectF(12, 22, 8, 8)
		elseif toggled == 10 then
			screen.drawRectF(22, 22, 8, 8)
		elseif toggled == 11 then
			screen.drawRectF(32, 22, 28, 8)
		elseif toggled == 12 then
			screen.drawRectF(62, 22, 10, 8)
		end
		screen.drawText(1, 2, table.concat(keypad))
	end

end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end