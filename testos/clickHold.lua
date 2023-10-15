simulator:setScreen(1, "3x1")
function onTick()
	isPressing = input.getBool(1) and (isPressing + 1) or 0

	if isPressing == 1 then
		hold = false
		isClick = true
	else
		isClick = false
	end

	if isPressing >= 120 then
		hold = true
	end

	-- etc
end

function onDraw()
	if isPressing > 0 then
		screen.setColor(0, 255, 0)
	else
		screen.setColor(255, 0, 0)
	end
	screen.drawText(2, 2, "isPressing: " .. isPressing)

	if isClick then
		screen.setColor(0, 255, 0)
	else
		screen.setColor(255, 0, 0)
	end
	screen.drawText(2, 12, "isClick: " .. tostring(isClick))

	if hold then
		screen.setColor(0, 255, 0)
	else
		screen.setColor(255, 0, 0)
	end
	screen.drawText(2, 22, "hold: " .. (hold and "true" or "false"))
end
