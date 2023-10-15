function ipir(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end

sc = screen.setColor
dr = screen.drawRect
drf = screen.drawRectF
dt = screen.drawText
dl = screen.drawLine
zoom = 1.5
time = 0
mapX = gpsX
mapY = gpsY
length = 0
wplist = {}
function onTick()
	isClick = time < 30 and time > 0 and not input.getBool(1) and not (type == "wait")
	print(string.format("time: %d, isClick: %s, input.getBool(1) = %s, type = %s", time, tostring(isClick), tostring(input.getBool(1)), type))
	isHold = time >= 60
	time = input.getBool(1) and (time + 1) or 0
	if isHold then type = "wait" end
	if input.getBool(1) == false then type = "" end
	if #wplist == 0 then gpsOn = false end
	c = input.getNumber(13)
	w = input.getNumber(1)
	h = input.getNumber(2)
	tX = input.getNumber(3)
	tY = input.getNumber(4)
	gpsX = input.getNumber(17)
	gpsY = input.getNumber(18)
	rudderIn = input.getNumber(16)
	onScreen = true
	settings = isClick and ipir(tX, tY, 0, 0, 15, 7)
	setMenu = input.getBool(4)
	output.setBool(1, settings)
	if setMenu and onScreen then -- settings controls
		zoomUp = isClick and ipir(tX, tY, 23, 6, 6, 6)
		zoomDown = isClick and ipir(tX, tY, 33, 6, 6, 6)
		if zoomUp then zoom = zoom + .01 * zoom end
		if zoomDown then zoom = zoom - 0.01 * zoom end
		if gpsOn then -- gps color set controls
			gps = 1
		else
			gps = 0
		end -- end gps color set controls, 1
		if not isClick then gpsFlag = true end
		if ipir(tX, tY, 0, 19, 15, 7) and isClick then
			if gpsOn then
				if gpsFlag then
					gpsOn = false
					gpsFlag = false
				end
			else
				if gpsFlag then
					gpsOn = true
					gpsFlag = false
				end
			end
		end

	end
	if zoom > 60 then zoom = 60 end
	if zoom < 0.01 then zoom = 0.1 end -- 0
	if onScreen and not setMenu then -- map screen check
		if isClick then
			if ipir(tX, tY, 0, 0, 15, 7) then
				-- clicking on "gps" button
			elseif ipir(tX, tY, 0, h - 7, 16, 8) then
				-- clicking on the "set" button
			else
				-- clicking on the map
				wpaX, wpaY = map.screenToMap(mapX, mapY, zoom, w, h, tX, tY)
				type = "wait"
				table.insert(wplist, {wpaX, wpaY})
			end
		else -- not clicked
			type = ""
		end
	end -- end map screen check
	if gpsOn and #wplist > 0 then
		output.setNumber(1, gpsFunc(wplist[1][1], wplist[1][2]))
	end
	if not gpsOn then output.setNumber(1, rudderIn) end
	output.setNumber(32, time)
end

function onDraw()
	if not setMenu then

		if isHold then
			time = 0
			if mapX == gpsX and mapY == gpsY then
				mapX, mapY = map.screenToMap(gpsX, gpsY, zoom, w, h, tX, tY)
			end
			mapX, mapY = map.screenToMap(mapX, mapY, zoom, w, h, tX, tY)
		end
		screen.drawMap(mapX, mapY, zoom)
		pixelX, pixelY = map.mapToScreen(mapX, mapY, zoom, w, h, gpsX, gpsY) -- draws red dot on boat location

		if #wplist > 0 then
			local x, y = wplist[1][1], wplist[1][2]
			local sx, sy = 0, 0
			sc(50, 0, 0, 75)
			if #wplist > 1 then
				for k, v in ipairs(wplist) do
					local px, py = map.mapToScreen(mapX, mapY, zoom, w, h, v[1],
												   v[2])
					if k > 1 then
						screen.drawLine(px, py, lx, ly)
					end
					lx, ly = px, py
				end
			end
			sx, sy = map.mapToScreen(mapX, mapY, zoom, w, h, x, y)
			dl(pixelX - 1, pixelY, sx, sy) -- draws line from boat to wp
		end
		sc(200, 0, 0)
		dl(pixelX - 1, pixelY, pixelX - 1, pixelY - 1)
	end
	sc(50, 50, 240)
	drf(0, 0, 15, 7) -- draws settings box
	sc(150, 150, 150)
	dt(1, 1, "set")
	sc(50, 50, 240)
	drf(0, h - 7, 16, 8)
	sc(150, 150, 150)
	dt(1, h - 6, "gps")
	if setMenu then -- if in settings menu
		dt(0, 7, "zoom + -")
		dr(23, 6, 6, 6)
		dr(33, 6, 6, 6)
		sc(255 * (1 - gps), 255 * gps, 0)
		dt(0, 19, "gps")
		sc(150, 150, 150)
		if zoomUp then -- zoom up controls
			drf(23, 6, 6, 6)
		end
		if zoomDown then drf(33, 6, 6, 6) end
		dt(0, 13, "zoom:" .. string.format("%0.2f", zoom))
	end -- end settings menu

	screen.drawText(6, 6, type)

end
function gpsFunc(wpX, wpY)
	if (gpsX < wplist[1][1] + 20 and gpsX > wplist[1][1] - 20 and gpsY < wplist[1][2] + 20 and gpsY > wplist[1][2] - 20) then
		table.remove(wplist, 1)
	end
	dx = wpX - gpsX
	dy = wpY - gpsY
	angle = math.atan(dx, dy) / (math.pi * 2)
	turn = ((angle + c) % 1 + 1.5) % 1 - 0.5
	return (turn * 3)
end
