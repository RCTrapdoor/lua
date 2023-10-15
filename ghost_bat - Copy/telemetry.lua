tau = 2 * math.pi
function onTick()
	xpos = input.getNumber(1)
	ypos = input.getNumber(2)
	zpos = input.getNumber(3)
	erx = input.getNumber(4) --Euler rotation
	ery = input.getNumber(5)
	erz = input.getNumber(6)
	lvx = input.getNumber(7) --Linear velocity
	lvy = input.getNumber(8)
	lvz = input.getNumber(9)
	ax = input.getNumber(10) --Angular velocity
	ay = input.getNumber(11)
	az = input.getNumber(12)
	abslv = input.getNumber(13) --Absolute linear velocity
	absav = input.getNumber(14) --Absolute angular velocity

	ad = input.getNumber(15) --Pilot controls
	ws = input.getNumber(16)
	lr = input.getNumber(17)
	ud = input.getNumber(18)
	lookx = input.getNumber(19)
	looky = input.getNumber(20)

	dtg = input.getNumber(21) --Sensors
	compass = input.getNumber(22)
	bat = input.getNumber(23)
	fuel = input.getNumber(24)
	rps = input.getNumber(25) --Turbine rps
	gen = input.getNumber(26)
	tmp = input.getNumber(27)
	haz = input.getNumber(28) --radiation
	touch_x = input.getNumber(29)
	touch_y = input.getNumber(30)

	action1 = input.getBool(1)
	action2 = input.getBool(2)
	action3 = input.getBool(3)
	action4 = input.getBool(4)
	action5 = input.getBool(5)
	action6 = input.getBool(6)
	trigger = input.getBool(7)
	occupied = input.getBool(8)

	radar = input.getBool(9)
	trans = input.getBool(10)

	touch = input.getBool(11)

	--	LOGIC
	cx, sx = math.cos(erx), math.sin(erx)
	cy, sy = math.cos(ery), math.sin(ery)
	cz, sz = math.cos(erz), math.sin(erz)

	m00 = cy * cz
	m01 = -cx * sz + sx * sy * cz
	m02 = sx * sz + cx * sy * cz
	m10 = cy * sz
	m11 = cx * cz + sx * sy * sz
	m12 = -sx * cz + cx * sy * sz
	m20 = -sy
	m21 = sx * cy
	m22 = cx * cy

	-- roll = math.asin(m10) / tau
	-- yaw = math.asin(m11) / tau
	-- pitch = math.asin(m12) / tau

	roll = math.atan(m10, math.sqrt(m00 * m00 + m20 * m20)) / tau
	yaw = math.atan(m11, math.sqrt(m01 * m01 + m21 * m21)) / tau
	pitch = math.atan(m12, math.sqrt(m02 * m02 + m22 * m22)) / tau
	-- compass_x = math.atan(m00, m20) / -tau
	-- compass_y = math.atan(m01, m21) / -tau
	compass_z = math.atan(m02, m22) / -tau

	angular_x = m00 * ax + m10 * ay + m20 * az
	angular_y = m01 * ax + m11 * ay + m21 * az
	angular_z = m02 * ax + m12 * ay + m22 * az


	--	OUTPUT
	output.setNumber(1, xpos)
	output.setNumber(2, ypos)
	output.setNumber(3, zpos)
	output.setNumber(4, roll)
	output.setNumber(5, yaw)
	output.setNumber(6, pitch)
	output.setNumber(7, lvx)
	output.setNumber(8, lvy)
	output.setNumber(9, lvz)
	output.setNumber(10, angular_x)
	output.setNumber(11, angular_y)
	output.setNumber(12, angular_z)
	output.setNumber(13, touch_x)
	output.setNumber(14, touch_y)
	output.setNumber(15, ad)
	output.setNumber(16, ws)
	output.setNumber(17, lr)
	output.setNumber(18, ud)
	output.setNumber(19, lookx)
	output.setNumber(20, looky)
	output.setNumber(21, dtg)
	output.setNumber(22, compass_z)
	output.setNumber(23, bat)
	output.setNumber(24, fuel)
	output.setNumber(25, rps)
	output.setNumber(26, gen)
	output.setNumber(27, tmp)
	output.setNumber(28, haz)
	output.setNumber(29, windir)
	output.setNumber(30, winspeed)

	output.setBool(1, action1)
	output.setBool(2, action2)
	output.setBool(3, action3)
	output.setBool(4, action4)
	output.setBool(5, action5)
	output.setBool(6, action6)
	output.setBool(7, trigger)
	output.setBool(8, occupied)
	output.setBool(9, radar)
	output.setBool(10, trans)
	output.setBool(11, touch)
end
