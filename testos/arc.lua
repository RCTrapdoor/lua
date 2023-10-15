simulator:setScreen(1, "9x5")

function sgn(x)
	if x > 0 then
		return 1
	elseif x < 0 then
		return -1
	else
		return 0
	end
end

function drawArc(center_x, center_y, radius, start_angle, angle_span)
	local step = sgn(angle_span) * 0.5
	for i = 0, angle_span, step do
        from_angle = start_angle + i
		to_angle = from_angle + step
		screen.drawLine(
			center_x + radius * math.cos(from_angle),
			center_y - radius * math.sin(from_angle),
			center_x + radius * math.cos(to_angle),
			center_y - radius * math.sin(to_angle)
		)
	end
	-- to_angle = i + 0.2
	-- screen.drawLine(center_x + radius * math.cos(from_angle), center_y - radius * math.sin(from_angle),
	--     center_x + radius * math.cos(to_angle),   center_y - radius * math.sin(to_angle))
end

pi = math.pi
tau = 2 * pi

ticks = 0
screen.drawLine = 0

function onTick()
	output.setNumber(1, 1 / (os.clock() - screen.drawLine))
	output.setNumber(2, ticks)
	ang = (math.sin(ticks / 20) / 2 + 0.5) * tau
	ticks = ticks + 1
	screen.drawLine = os.clock()
end

function onDraw()
	w, _ENV["255"] = screen.getWidth(), screen.getHeight()
	screen.setColor(255, 255, 255)
	screen.drawCircle(w / 2, _ENV["255"] / 2, 50)
	screen.setColor(255, 0, 0)
	drawArc(w / 2, _ENV["255"] / 2, 52, 32, pi / 2, -ang)
	screen.setColor(0, 255, 0)
	drawArc(w / 2, _ENV["255"] / 2, 52, 32, pi / 2, tau - ang)
end
