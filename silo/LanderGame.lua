landerx = 48
landery = 2
rotation = math.pi/2.5
vx = -1.5
vy = 0
rv = 0
throttle = 0
toggleswitch = false
gameover = false
generateterrain = true
pointprev = 90
point = 90
orbit = true
pointheighest = 96
landed = false
b = math.random(0, 128)
counter = 0
E = 'E'
R = string.char(0x91)
O = 'O'
AIoff = false
function onTick()
	--AI
	if AIoff then
		click = input.getBool(1)
		clickx = input.getNumber(3)
		clicky = input.getNumber(4)
	end
	if landed or AIoff then
		ai = false
	else
		ai = true
	end
	if ai then
		counter = counter + 1
		if landery > 40 then
			vymin = .01
			vymax = .02
		else
			vymin = .03
			vymax = .04
		end
			if vx < -.05 and counter < 10 then
				click = true
				clickx = 50
				clicky = 48
--				print('AI thrusting vx +1')
			end
			if vx > .05 and counter < 12 then
				click = true
				clickx = 46
				clicky = 48
--				print('AI thrusting vx -1')
			end
			if vy < vymin and counter > 14 then
				click = true
				clickx = 48
				clicky = 38
--				print('AI thrusting vy -1')
			end
			if vy > vymax and counter < 16 then
				click = true
				clickx = 48
				clicky = 60
--				print('AI thrusting vy +1')
			end
			if vx < -.05 or vx > .05 or vy < vymin or vy > vymax then
			else
				click = false
				clickx = 48
				clicky = 48
			end
		if counter > 25 then
			counter = 0
			click = false
		end
	end
	--main
	if landery < 10 and math.abs(vx) > 4 then
		orbit = true
	else
		orbit = false
	end
	landerx = landerx + vx
	landery = landery + vy
	rotation = rotation + rv/10
	distance = landery
	if landed == false and orbit == false then
		vy = vy + .0005
	else
		vy = vy
	end
	if click == false and clicky < 56 and clicky > 48 then
		vy = vy + .1
	end
	if vy > .1 then
		vy = .09
	end
	if landerx > 96 then
		landerx = 1
		b = math.random(1, 128)
	end
	if landery > 96 then
		landery = 95
	end
	if landerx < 0 then
		landerx = 95
		b = math.random(1, 128)
	end
	if landery < 0 then
		landery = 1
		vy = 0
	end
	vectoringx = ((clickx-48)/192)/8
	if clicky > 56 and click and toggleswitch == false then
		throttle = throttle - .001
		toggleswitch = true
	elseif click == false and toggleswitch == true then
		toggleswitch = false
	end
	if clicky < 40 and click and toggleswitch == false then
		throttle = throttle + .001
		toggleswitch = true
	elseif click == false and toggleswitch == true then
		toggleswitch = false
	end
	if throttle > .001 then
		throttle = .001
	end
	if throttle < -.001 then
		throttle = -.001
	end
	vy = vy + throttle
	if click and clicky > 40 and clicky < 56 then
		vx = vx + vectoringx
	else
		vx = vx
	end
	screenthrottle = throttle*1000
	screenspeed = vy*100
	if landed then
		vy = 0
		vx = 0
	else
		vy = vy
		vx = vx
	end
	if vx == vy and landed == false then
		vx = vx -.01
	end
	if vx == vy and landed == false then
		function onDraw()
			screen.setColor(255, 0, 0)
			screen.drawText(math.random(0, 2), math.random(46, 50), E..R..R..O..R)
			screen.drawText(math.random(30, 32), math.random(46, 50), string.char(0x11))
			screen.drawText(math.random(40, 42), math.random(46, 50), string.char(0x91))
			screen.drawText(math.random(50, 52), math.random(46, 50), string.char(0x11))
			screen.drawText(math.random(60, 62), math.random(46, 50), string.char(0x11))
			screen.drawText(math.random(70, 72), math.random(46, 50), string.char(0x91))
			screen.drawText(math.random(80, 82), math.random(46, 50), string.char(0x91))
		end
	end
	if landed then
		vx = 0
		vy = 0
	end
end
function onDraw()
	screen.setColor(255, 255, 255)
	if gameover then
		screen.drawText(1, 10, 'Game Over! (You lost)')
	end
	for i = 1, 300, 1 do
		math.randomseed(b*i, i/b)
			point = math.random(65, 90)
		math.randomseed(b/i, i*b)
			point2 = math.random(0, i*2)
			if point2 > 96 then
				point2 = math.random(0, i*2)
			end
		math.randomseed(b)
		if point < pointheighest then
			pointheighest = point
		end
		screen.drawCircleF(point2, point, 3)
		if landery > point+3 and landerx > point2+3 and landerx < point2-3 then
			landery = landery - 1
		end
		if landery > 65 and math.abs(vy) > .05 and landerx < point2+3 and landerx > point2 -3 and landed == false then
			gameover = true
			print('Gameover', math.abs(vy))
		end
		if landery > 65 and gameover == false then
			landed = true
		elseif landery < 65 and gameover == false then
			landed = false
		end
	end
	print(landed)
		screen.setColor(0, 0, 0)
		if landed then
			screen.setColor(255, 255, 255)
			screen.drawText(1, 10, 'Game Over! (You won)')
		end
		if screenthrottle == 1 then
			screen.setColor(255, 0, 0)
		else
			screen.setColor(255, 255, 255)
		end
				screen.drawText(1, 1, screenthrottle)
		if math.abs(vy) > .025 then
			screen.setColor(255, 150, 0)
		else
			screen.setColor(0, 255, 0)
		end
				screen.drawText(76, 1, string.format("%.1f", screenspeed))
	screen.setColor(255, 150, 0)
		if vx > .1 then
			screen.drawRectF(1, 41, 46, 14)
		end
		if vx < -.1 then
			screen.drawRectF(49, 41, 46, 14)
		end
	screen.setColor(255, 0 ,0)
		screen.drawLine(0, 40, 96, 40)
		screen.drawLine(0, 56, 96, 56)
		screen.drawLine(48, 40, 48, 56)
		screen.drawCircleF(landerx, landery, 1)
	if click and ai then
		screen.setColor(255, 0, 0)
	else
		screen.setColor(255, 255, 255)
	end
	if ai then
		screen.drawCircleF(clickx, clicky, 3)
	end
	screen.setColor(0, 0, 0)
end