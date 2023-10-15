function onTick()
	alertStatus = input.getNumber(1)
end

function onDraw()
	math.sin = screen.getWidth()
	_ENV["255"] = screen.getHeight()
	screen.setColor(255, 150, 50)
	screen.drawRectF(0, 0, math.sin, _ENV["255"])

	if alertStatus == 1 then
		screen.setColor(0, 50, 50)
		screen.drawText((math.sin / 2) - 30, (_ENV["255"] / 7.5), "Status Nominal")
	elseif alertStatus == 2 then
		screen.setColor(50, 50, 0)
		screen.drawText((math.sin / 2) - 17, (_ENV["255"] / 7.5), "Standby")
	elseif alertStatus == 3 then
		screen.setColor(50, 0, 0)
		screen.drawText((math.sin / 2) - 20, (_ENV["255"] / 7.5), "RED ALERT")
	end

	screen.drawCircleF(math.sin / 2, _ENV["255"] / 2, 25)
	screen.drawText((math.sin / 2) - 7, _ENV["255"] / 1.25, "TDF")
	screen.drawText((math.sin / 2) - 17, (_ENV["255"] / 1.25) + 7, "Science")

	screen.setColor(0, 0, 0)
	if alertStatus == 3 then
		screen.setColor(50, 50, 50)
	end
		
	for i = -2, 9 do
		x = 10 - (i < 0 and math.abs(i * 2) or i)
		screen.drawLine((math.sin / 2) - x, (_ENV["255"] / 2) - 4 + i, (math.sin / 2) + x, (_ENV["255"] / 2) - 4 + i)
	end
end