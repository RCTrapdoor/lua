require("_build._simulator_config")
require("LifeBoatAPI")

function ellipses(x, y, minor_radius, major_radius, segments)
	local cos, sin = math.cos, math.sin
    local step = (math.pi * 2) / segments
    for i = 0, math.pi*2, step do
		screen.drawLine(x + major_radius * cos(i), y + major_radius * sin(i), x + minor_radius * cos(i), y + minor_radius * sin(i))
    end
end

waypoints = {}
ticks = 0

tau = math.pi * 2
pi = tau / 2

zoom = 1

isPressed = 0

holdTimer = 30

touch = { x = 0, y = 0 }
touch2 = { x = 0, y = 0 }

buttons = {}
buttons["add"] = { x = 248, y = 150, w = 40, h = 10, state = false }
buttons["cancel"] = { x = 248, y = 140, w = 40, h = 10, state = false }

function vecSub(a, b) -- Vector from a to b
	return {x = b.x - a.x, y = b.y - a.y}
end

function vecLength(a)
	return (a.x^2+a.y^2)^0.5
end

function vecScale(a, b)
	return {x = b * (a.x / vecDist(a)), y =  b * (a.y / vecDist(a))}
end

function vecProduct(a, b)
	return a.x * b.x + a.y * b.y
end

function scalarProj(a, b)
	return vecProduct(a, b)/(vecDist(a))
end

function vecAdd(a, b)
	return {x = a.x + b.x, y = a.y + b.y}
end

function rotate2d(x, y, cx, cy, angle)
	local s = math.sin(angle)
	local c = math.cos(angle)
	local dx = x - cx
	local dy = y - cy
	return {
		x = dx * c - dy * s + cx,
		y = dx * s + dy * c + cy,
	}
end

function button(touch, btn)
	btn.state = touch.x > btn.x and touch.x < btn.x + btn.w and touch.y > btn.y and touch.y < btn.y + btn.h
end

function onTick()
	ticks = ticks + 1

	clicked = isPressed < holdTimer and not input.getBool(1)
	held = isPressed >= holdTimer and input.getBool(1)
	isPressed = input.getBool(1) and isPressed + 1 or 0
	GPS = { x = input.getNumber(7), y = input.getNumber(8) }
	compass = input.getNumber(9) * tau
	isPressed2 = input.getBool(2) and isPressed2 + 1 or 0

	width, height = input.getNumber(1), input.getNumber(2)

	for _, b in pairs(buttons) do
		button(touch, b)
	end

	if buttons.add.state and waypoint then
		table.insert(waypoints, waypoint)
		waypoint = nil
	elseif buttons.cancel.state and waypoint then
		waypoint = nil
	else
		if isPressed == 1 then
			touch = { x = input.getNumber(3), y = input.getNumber(4) }
			touchGPS = table.pack(map.screenToMap(GPS.x, GPS.y, zoom, width, height, touch.x, touch.y))
		end
		if isPressed2 == 1 then
			touch2 = { x = input.getNumber(5), y = input.getNumber(6) }
			touchGPS2 = table.pack(map.screenToMap(GPS.x, GPS.y, zoom, width, height, touch2.x, touch2.y))
		end
		if isPressed >= 1 and isPressed2 >= 1 then
			angle = math.atan(touch.y - touch2.y, touch.x - touch2.x)
			waypoint = {
				x = touch.x,
				y = touch.y,
				angle = angle,
				circle1 = {
					x = touch.x + math.cos(angle + pi/2) * 20,
					y = touch.y + math.sin(angle + pi/2) * 20,
					r = 20,
				},
				circle2 = {
					x = touch.x + math.cos(angle - pi/2) * 20,
					y = touch.y + math.sin(angle - pi/2) * 20,
					r = 20,
				},
			}
		end
	end
end

function onDraw()
	screen.drawMap(GPS.x, GPS.y, zoom)

	if isPressed > 0 then
		screen.setColor(0, 180, 0)
		screen.drawCircle(touch.x, touch.y, 6)
	end

	screen.setColor(255, 0, 0)
	x, y = map.screenToMap(GPS.x, GPS.y, zoom, width, height, touch.x, touch.y)
	screen.drawTextBox(touch.x - 30, touch.y - 7, 60, 5, string.format("%5.0f %5.0f", x, y))

	if isPressed2 > 0 then
		screen.setColor(0, 180, 0)
		screen.drawCircle(touch2.x, touch2.y, 6)
		screen.drawLine(touch.x, touch.y, touch2.x, touch2.y)
	end

	if waypoint then
		screen.setColor(100, 0, 0)
		-- draw an arrow pointing from the waypoint
		screen.drawLine(
			waypoint.x + math.cos(waypoint.angle + pi / 4) * 10,
			waypoint.y + math.sin(waypoint.angle + pi / 4) * 10,
			waypoint.x,
			waypoint.y
		)
		screen.drawLine(
			waypoint.x + math.cos(waypoint.angle - pi / 4) * 10,
			waypoint.y + math.sin(waypoint.angle - pi / 4) * 10,
			waypoint.x,
			waypoint.y
		)
		for i = 0, 30, 6 do
			x, y = waypoint.x + i * math.cos(waypoint.angle), waypoint.y + i * math.sin(waypoint.angle)
			x2, y2 = waypoint.x + (i + 2) * math.cos(waypoint.angle), waypoint.y + (i + 3) * math.sin(waypoint.angle)
			screen.drawLine(x, y, x2, y2)
		end
		-- draw two circles at a radius of 10, orthogonal to the waypoint
		screen.setColor(0, 0, 255)
		screen.drawCircle(
			waypoint.x + math.cos(waypoint.angle + pi / 2) * 20,
			waypoint.y + math.sin(waypoint.angle + pi / 2) * 20,
			20
		)
		screen.drawCircle(
			waypoint.x + math.cos(waypoint.angle - pi / 2) * 20,
			waypoint.y + math.sin(waypoint.angle - pi / 2) * 20,
			20
		)
	end

	for i = 1, #waypoints do
		local waypoint = waypoints[i]
		screen.setColor(100, 0, 0)
		screen.drawLine(
			waypoint.x + math.cos(waypoint.angle + pi / 4) * 10,
			waypoint.y + math.sin(waypoint.angle + pi / 4) * 10,
			waypoint.x,
			waypoint.y
		)
		screen.drawLine(
			waypoint.x + math.cos(waypoint.angle - pi / 4) * 10,
			waypoint.y + math.sin(waypoint.angle - pi / 4) * 10,
			waypoint.x,
			waypoint.y
		)
		for a = 0, 30, 6 do
			x, y = waypoint.x + a * math.cos(waypoint.angle), waypoint.y + a * math.sin(waypoint.angle)
			x2, y2 = waypoint.x + (a + 2) * math.cos(waypoint.angle), waypoint.y + (a + 3) * math.sin(waypoint.angle)
			screen.drawLine(x, y, x2, y2)
		end
		-- draw two circles at a radius of 10, orthogonal to the waypoint
		screen.setColor(0, 0, 255)
        screen.drawCircle(waypoint.circle1.x, waypoint.circle1.y, waypoint.circle1.r)
        screen.drawCircle(waypoint.circle2.x, waypoint.circle2.y, waypoint.circle2.r)

		if i < #waypoints then
			-- draw lines between the tangents of the circles
			screen.setColor(0, 255, 0)
			screen.drawLine(
				waypoint.circle1.x + math.cos(waypoint.angle + pi / 2) * waypoint.circle1.r,
				waypoint.circle1.y + math.sin(waypoint.angle + pi / 2) * waypoint.circle1.r,
				waypoints[i + 1].circle1.x + math.cos(waypoints[i + 1].angle + pi / 2) * waypoints[i + 1].circle1.r,
				waypoints[i + 1].circle1.y + math.sin(waypoints[i + 1].angle + pi / 2) * waypoints[i + 1].circle1.r
			)
		end
	end

	-- draw the buttons
	for k, v in pairs(buttons) do
		screen.setColor(20, 20, 20)
		screen.drawRect(v.x, v.y, v.w, v.h)
		screen.setColor(40, 40, 40)
		if v.state then
			screen.setColor(30, 30, 30)
		end
		screen.drawRectF(v.x + 1, v.y + 1, v.w - 1, v.h - 1)
		screen.setColor(200, 200, 200)
		screen.drawTextBox(v.x, v.y, v.w, v.h, k, 0, 0)
	end

	circle1 = {x = 40, y = 40, r = 20}
	circle2 = {x = 200, y = 120, r = 20}
	vec = {x = circle2.x - circle1.x, y = circle2.y - circle1.y}
	-- draw the circles
	screen.setColor(0, 0, 255)
	screen.drawCircle(circle1.x, circle1.y, circle1.r)
	screen.drawCircle(circle2.x, circle2.y, circle2.r)
	-- draw the tangents
	screen.setColor(0, 255, 0)
	-- calculate the tangents of the circles
	tangent1 = {x = circle1.x + vec.x / vec.x * circle1.r, y = circle1.y + vec.y / vec.y * circle1.r}
	tangent2 = {x = circle2.x + vec.x / vec.x * circle2.r, y = circle2.y + vec.y / vec.y * circle2.r}
	-- draw the tangents
	screen.drawLine(circle1.x, circle1.y, tangent1.x, tangent1.y)
	screen.drawLine(circle2.x, circle2.y, tangent2.x, tangent2.y)
	-- draw the intersection
	screen.setColor(255, 0, 0)
	intersection = {x = (tangent1.x + tangent2.x) / 2, y = (tangent1.y + tangent2.y) / 2}
	screen.drawCircle(intersection.x, intersection.y, 5)
	
end
