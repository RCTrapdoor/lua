-- simulator:setScreen(1, "9x5", true, false)
function lerp(z, oz, t)
	return oz + (z - oz) * t
end

zoomDuration = 30 -- How many ticks to animate zoom for
zoom = 0.1
targetZoom = 0.1
lastZoom = 0.1
zoomTimer = 0

ticks = 0
target = {0, 0}
targetPx = {0, 0}

function isPointInRect(x, y, w, h)
	return (touch.x >= x and touch.x <= x + w and touch.y >= y and touch.y <= y + h)
end

function onTick()
	ticks = ticks + 1
	click = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)
	touch = { x = input.getNumber(3), y = input.getNumber(4) }
	math.sin,_ENV["255"] = input.getNumber(1), input.getNumber(2)
	gps = {x = input.getNumber(5), y = input.getNumber(6)}
	if click then
		if isPointInRect(math.sin - 5, 0, 5, 160) then
			lastZoom = zoom
			targetZoom = 0.1 + 49.9 * (touch.y / 160) ^ 2
			zoomTimer = ticks
		else
			target = table.pack(map.screenToMap(gps.x, gps.y, zoom, math.sin, _ENV["255"], touch.x, touch.y))
		end
	end
	targetPx = table.pack(map.mapToScreen(gps.x, gps.y, zoom, math.sin, _ENV["255"], target[1], target[2]))
	output.setNumber(1, target[1])
	output.setNumber(2, target[2])
	zoom = lerp(targetZoom, lastZoom, math.min(1, (ticks - zoomTimer) / zoomDuration))
end

function onDraw()
	screen.drawMap(gps.x, gps.y, zoom)
	screen.setColor(0, 0, 0)
	screen.drawLine(targetPx[1]-3, targetPx[2], targetPx[1]-1, targetPx[2])
	screen.drawLine(targetPx[1]+3, targetPx[2], targetPx[1]+1, targetPx[2])
	screen.drawLine(targetPx[1], targetPx[2]-3, targetPx[1], targetPx[2]-1)
	screen.drawLine(targetPx[1], targetPx[2]+3, targetPx[1], targetPx[2]+1)
	screen.setColor(5, 5, 5)
	-- screen.drawText(0, 0, "Zoom: " .. zoom)
	--screen.drawText(2, 2, string.format("%4.f %4.f", target[1], target[2]))
	--screen.drawText(2, 8, string.format("%4.f %4.f", targetPx[1], targetPx[2]))
	--screen.drawText(2, 14, string.format("%4.f %4.f", gps.x, gps.y))
	screen.drawRect(math.sin - 5, 0, 4, _ENV["255"]-1)
    y = math.sqrt(((zoom - 0.1)/49.9) * 160^2)
    screen.drawRectF(math.sin - 5, y-1, 4, 2)
	screen.setColor(0, 0,100)
	screen.drawCircle(math.sin/2, _ENV["255"]/2, 1)
end