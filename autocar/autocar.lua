--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
--- Remember to set your Author name etc. in the settings: CTRL+COMMA

require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

-- buttons = { { text = "X", state = true }, { text = "P1", state = false }, { text = "P2", state = false } }

-- function wrap(x, min, max)
-- 	return (x - min) % (max - min) + min
-- end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end
-- 
--waypoints = {{4435, -6351}, {3648, -5564}, {3561, -5649}, {4349, -6438}}
waypoints = {{3973,-5880}, {3647,-5574}, {3571,-5651}, {3869,-5956}, {4105,-6019}, {4425,-6338}, {4341,-6429}, {4029,-6116}}
for k, wp in ipairs(waypoints) do
	waypoints[k] = LifeBoatAPI.LBVec:new(wp[1], wp[2])
end
curr = #waypoints-1
dist = 0
zoom = 2
history = {}
t = 0
dp = 0
dp2 = 0
p1, p2, p3 = waypoints[1], waypoints[2], waypoints[4]
lookahead_ = 100
lookahead = lookahead_
function myCircle(cx, cy, radius, start_angle, angle, value)
    local x, y, x2, y2
    for i = 0, 32*value, 1 do
        x = radius * math.cos(start_angle + angle / 32 * i)
        y = radius * math.sin(start_angle + angle / 32 * i)
        x2 = radius * math.cos(start_angle + angle / 32 * (i + 1))
        y2 = radius * math.sin(start_angle + angle / 32 * (i + 1))
        screen.drawLine(cx + x, cy - y, cx + x2, cy - y2)
    end
end
function onTick()

	click = not pressed and input.getBool(1)
	pressed = input.getBool(1)
	w, h = input.getNumber(1), input.getNumber(2)
	touch = {x = input.getNumber(3), y = input.getNumber(4)}
	compass = input.getNumber(5)

	gps = LifeBoatAPI.LBVec:new(input.getNumber(6), input.getNumber(7))
	---@section simulator
	gps = LifeBoatAPI.LBVec:new(4106, -5920)
	---@endsection
	spd = lgps and gps:lbvec_distance(lgps) * 60 or 0
	
	if click then
		if isPointInRectangle(touch.x, touch.y, w-10, h-10, 10, 10) then
			tb = ""
			for k, v in ipairs(waypoints) do
				tb = tb .. ("%.f=%.f,%.f&"):format(k, v.x, v.y)
			end
			async.httpGet(80, "/log?"..tb)
			transmit = true
		else
			maptouch = LifeBoatAPI.LBVec:new(table.unpack({map.screenToMap(gps.x, gps.y, zoom, w, h, touch.x, touch.y)}))
			for k, v in ipairs(waypoints) do
				if v:lbvec_distance(maptouch) < 50 then
					table.remove(waypoints, k)
					goto skipadd
				end
			end
			table.insert(waypoints, maptouch)
			::skipadd::
		end			
	end
	if #waypoints > 1 then
		t = t + 1
		if math.abs(dp2 - p2:lbvec_distance(p1)) < 0.1 then --dist < 35 then
			curr = (curr % #waypoints) + 1
			p1 = waypoints[curr]
			p2 = waypoints[curr % #waypoints + 1]
			p3 = waypoints[(curr + 1) % #waypoints + 1]
		end

		if t % 60 == 0 then
			--t = 1
			table.insert(history, gps)
		end
		while #history > 120 do
			table.remove(history, 1)
		end
		dist = p2:lbvec_distance(gps)
		wp_lb = p2:lbvec_sub(p1)
		dp = math.max(0, wp_lb:lbvec_dot(gps:lbvec_sub(p1)) / wp_lb:lbvec_length())
		dp2_ = math.min(p2:lbvec_distance(p1), dp)
		wpnormal = wp_lb:lbvec_normalize():lbvec_scale(dp2_):lbvec_add(p1)
		lookahead = math.max(0, math.min(lookahead_, lookahead_ - gps:lbvec_distance(wpnormal)))
		dp2 = math.min(p2:lbvec_distance(p1), dp + lookahead)
		wpnormal2 = wp_lb:lbvec_normalize():lbvec_scale(dp2)
		targetHeading = wpnormal2:lbvec_add(p1):lbvec_angleAround2D(gps) / (math.pi * 2)
		nextang = p2:lbvec_add(gps):lbvec_anglebetween(p3:lbvec_sub(gps))
		output.setNumber(1, -targetHeading)
		output.setNumber(2, math.max(20, (100 *  nextang)))
		--p1:lbvec_anglebetween(rhs: LBVec)
		output.setNumber(3, spd ~= spd and 0 or spd)
		lgps = gps
	end
end

function httpReply(port, request, reply)
	transmit = false
end

function myMapToScreen(coord)
	return { map.mapToScreen(gps.x, gps.y, zoom, w, h, coord.x, coord.y) }
end

function onDraw()
	screen.drawMap(gps.x, gps.y, zoom)
	if t > 0 and #waypoints > 1 then
		screen.drawTextBox(0, 0, w, 10, curr .. " to " ..  (curr % #waypoints + 1), 0, 0)
		screen.drawTextBox(0, 10, w, 10, p1.x .. " " .. p1.y, 0, 0)
		screen.drawTextBox(0, 20, w, 10, p2.x .. " " .. p2.y, 0, 0)
		screen.drawTextBox(0, 30, w, 10, nextang .. " " .. (100 * nextang), 0, 0)


		for k, v in ipairs(waypoints) do
			--screen.drawText(4, k*6, ("#%.f - %.f x %.f"):format(k, v.x, v.y))
		end
		x_ = myMapToScreen(gps)
		p1_ = myMapToScreen(p1)
		p2_ = myMapToScreen(p2)
		p3_ = myMapToScreen(p3)
		--wpnormal_ = {map.mapToScreen(x.x, x.y, zoom, w, h, wpnormal[1]+p1[1], wpnormal[2]+p1[2])}
		wpnormal2_ = myMapToScreen(wpnormal2:lbvec_add(p1))

		screen.setColor(255, 0, 0)
		screen.drawCircleF(x_[1], x_[2], 2)
		screen.drawCircle(wpnormal2_[1], wpnormal2_[2], 2)

		-- Menu overlay
		screen.setColor(20, 20, 255)
		screen.drawCircleF(w-6, h-6, 5)
		if transmit then
			screen.setColor(0, 0, 0)
			myCircle(w-6, h-6, 3, t / 10, 1, 1)
		end
		for k, v in ipairs(waypoints) do
			foo = myMapToScreen(v)
			if k == (curr % #waypoints + 1) then
				screen.setColor(0, 255, 255)
			else
				screen.setColor(10, 10, 100)
			end
			screen.drawCircle(foo[1]//1, foo[2]//1, 6.5)

			--screen.setColor(0, 0, 0)
			screen.drawTextBox(foo[1]//1 - 5, foo[2]//1 - 4, 12, 10, k, 0, 0)
			-- screen.drawCircle(foo[1], foo[2], 6)
		end

		-- screen.setColor(255, 255, 0)
		-- screen.drawLine(p1_[1], p1_[2], x_[1], x_[2])
		-- screen.drawText(p1_[1], p1_[2], "p1")
		-- screen.setColor(180, 70, 0)
		-- screen.drawLine(p2_[1], p2_[2], x_[1], x_[2])
		-- screen.drawText(p2_[1], p2_[2], "p2")

		-- screen.setColor(180, 70, 0)
		-- screen.drawLine(p3_[1], p3_[2], x_[1], x_[2])
		-- screen.drawText(p3_[1], p3_[2], "p3")

		screen.setColor(20, 20, 20)
		for k = 1, #history - 1 do
			f, to =
				myMapToScreen(history[k]),
				myMapToScreen(history[k + 1])
			screen.drawLine(f[1], f[2], to[1], to[2])
		end
	end
end

-- function printTable(tab, depth)

--     depth = depth or 0
--     screen.setColor(255, 255, 255)

--     for k,v in pairs(tab) do
--         if i_ == 24 then
--             screen.setColor(0, 0, 0)
--             screen.drawRectF(144, 0, 144, 160)
--         end
--         if type(v) == "number" then
--             screen.drawText((i_//25)*144+2+depth*6*2, i_%25*6, k..": "..v)
--             i_ = i_ + 1
--         elseif type(v) == "table" and depth <= 1 then
-- 			screen.drawText((i_//25)*144+2+depth*6*2, i_%25*6, "[" .. k .. "]")
-- 			i_ = i_ + 1
-- 			printTable(v, depth + 1)
--         end
--     end
-- end

-- function onDraw()
--     i_ = 0
--     printTable(_ENV)
-- end