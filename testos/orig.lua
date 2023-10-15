set_coord = screen
sC = set_coord.setColor
dRF = set_coord.drawRectF
dR = set_coord.drawRect
dT = set_coord.drawText
SF = string.format
x_ = input
SA = "engine"
SAP = 0
SAW = 31
Rtt = "RPS"
SpdT = "KPH"
SpdM = 3.6
Rp = 1
T = 0
tMode = "off"
engine_s = "off"
function onTick()
	screen.drawLine = x_.getBool(1)
	x = x_.getNumber(3)
	y = x_.getNumber(4)
	rps = x_.getNumber(5)
	temp = x_.getNumber(6)
	spd = x_.getNumber(7)
	idlerps = x_.getNumber(8)
	fuel = x_.getNumber(9)
	screen_tilt = x_.getNumber(10)
	navs = x_.getBool(2)
	strobes = x_.getBool(3)
	landings = x_.getBool(4)
	cockpits = x_.getBool(5)
	landinggear_s = x_.getBool(6)
	gyro_s = x_.getBool(7)
	brakes = x_.getBool(8)
	Engine = screen.drawLine and math.sin(x, y, 0, 0, 31, 7)
	Lights = screen.drawLine and math.sin(x, y, 34, 0, 31, 7)
	Other = screen.drawLine and math.sin(x, y, 69, 0, 27, 7)
	moreRPS = screen.drawLine and math.sin(x, y, 4, 40, 8, 8) and SA == "engine"
	lessRPS = screen.drawLine and math.sin(x, y, 4, 54, 8, 8) and SA == "engine"
	FULL = screen.drawLine and math.sin(x, y, 63, 14, 22, 7) and SA == "engine"
	TAKEOFF = screen.drawLine and math.sin(x, y, 56, 20, 37, 7) and SA == "engine"
	LAND = screen.drawLine and math.sin(x, y, 63, 26, 22, 7) and SA == "engine"
	IDLE = screen.drawLine and math.sin(x, y, 63, 32, 22, 7) and SA == "engine"
	OFF = screen.drawLine and math.sin(x, y, 66, 38, 17, 7) and SA == "engine"
	nav_l = screen.drawLine and math.sin(x, y, 22, 7, 52, 7) and SA == "lights"
	strobe_l = screen.drawLine and math.sin(x, y, 32, 13, 32, 7) and SA == "lights"
	landing_l = screen.drawLine and math.sin(x, y, 30, 19, 37, 7) and SA == "lights"
	cockpit_l = screen.drawLine and math.sin(x, y, 30, 25, 37, 7) and SA == "lights"
	KPH_o = screen.drawLine and math.sin(x, y, 72, 13, 17, 7) and SA == "other"
	MPH_o = screen.drawLine and math.sin(x, y, 72, 19, 17, 7) and SA == "other"
	KTS_o = screen.drawLine and math.sin(x, y, 72, 25, 17, 7) and SA == "other"
	r_second_o = screen.drawLine and math.sin(x, y, 44, 47, 52, 7) and SA == "other"
	r_minute_o = screen.drawLine and math.sin(x, y, 44, 53, 52, 7) and SA == "other"
	Landing_Gear = screen.drawLine and math.sin(x, y, 0, 21, 62, 7) and SA == "other"
	Gyro = screen.drawLine and math.sin(x, y, 0, 27, 22, 7) and SA == "other"
	moreTilt = screen.drawLine and math.sin(x, y, 2, 50, 5, 5) and SA == "other"
	lessTilt = screen.drawLine and math.sin(x, y, 2, 58, 5, 5) and SA == "other"
	Brake = screen.drawLine and math.sin(x, y, 0, 33, 30, 7) and SA == "other"
	if FULL then
		tMode = "full"
		T = 1
	elseif TAKEOFF then
		tMode = "takeoff"
		T = 0.6
	elseif LAND then
		tMode = "land"
		T = 0.35
	elseif IDLE then
		tMode = "idle"
	elseif OFF then
		tMode = "off"
		T = 0
	end
	if Engine then
		SA = "engine"
		SAP = 0
		SAW = 31
	elseif Lights then
		SA = "lights"
		SAP = 34
		SAW = 31
	elseif Other then
		SA = "other"
		SAP = 69
		SAW = 27
	end
	if KPH_o then
		SpdT = "KPH"
		SpdM = "3.6"
	elseif MPH_o then
		SpdT = "MPH"
		SpdM = 2.236936
	elseif KTS_o then
		SpdT = "KTS"
		SpdM = 1.943844
	end
	if r_second_o then
		Rtt = "RPS"
		Rp = 1
	elseif r_minute_o then
		Rtt = "RPM"
		Rp = 60
	end
	if rps > 2 then
		engine_s = "on"
	else
		engine_s = "off"
	end
	output.setBool(1, moreRPS)
	output.setBool(2, lessRPS)
	output.setBool(3, tMode == "idle")
	output.setBool(4, nav_l)
	output.setBool(5, strobe_l)
	output.setBool(6, landing_l)
	output.setBool(7, cockpit_l)
	output.setBool(8, Landing_Gear)
	output.setBool(9, Gyro)
	output.setBool(10, moreTilt)
	output.setBool(11, lessTilt)
	output.setBool(12, Brake)
	output.setNumber(1, T)
end
function math.sin(X, Y, x, y, w, h)
	return X > x and Y > y and X < x + w and Y < y + h
end
function state(bool)
	if bool then
		sC(50, 255, 50)
	else
		sC(255, 25, 25)
	end
end
function onDraw()
	math.sin = set_coord.getWidth()
	_ENV["255"] = set_coord.getHeight()
	sC(50, 50, 50)
	dRF(0, 0, math.sin, 7)
	sC(10, 10, 10)
	dRF(SAP, 0, SAW, 7)
	sC(100, 100, 100)
	dT(1, 1, "Engine")
	dT(35, 1, "Lights")
	dT(70, 1, "Other")
	if SA == "engine" then
		sC(0, 100, 255)
		dT(1, 8, ">Info")
		dT(1, 35, ">Idle " .. Rtt)
		dT(55, 8, ">Engine")
		sC(50, 255, 50)
		dT(1, 15, Rtt .. " :" .. SF("%.0f", rps * Rp) .. "\nTemp:" .. SF("%.0f", temp))
		state(rps > 2)
		dT(1, 27, "Status:" .. engine_s)
		state(moreRPS)
		dT(7, 42, "+")
		state(lessRPS)
		dT(7, 56, "-")
		sC(255, 255, 0)
		dT(3, 49, SF("%.0f", idlerps * Rp))
		state(tMode == "full")
		dT(67, 15, "max")
		state(tMode == "takeoff")
		dT(57, 21, "takeoff")
		state(tMode == "land")
		dT(64, 27, "land")
		state(tMode == "idle")
		dT(64, 33, "idle")
		state(tMode == "off")
		dT(67, 39, "off")
	elseif SA == "lights" then
		state(navs)
		dT(23, 8, "Navigation")
		state(strobes)
		dT(33, 14, "Strobe")
		state(landings)
		dT(31, 20, "Landing")
		state(cockpits)
		dT(31, 26, "Cockpit")
	elseif SA == "other" then
		sC(50, 255, 50)
		dT(1, 8, SpdT .. " :" .. SF("%.0f", spd * SpdM))
		dT(1, 14, "Fuel:" .. SF("%.1f", fuel))
		sC(0, 100, 255)
		dT(64, 8, ">Speed")
		dT(45, 42, ">Rotations")
		dT(1, 42, ">Tilt")
		state(SpdT == "KPH")
		dT(73, 14, "KPH")
		state(SpdT == "MPH")
		dT(73, 20, "MPH")
		state(SpdT == "KTS")
		dT(73, 26, "KTS")
		state(Rtt == "RPS")
		dT(45, 48, "per second")
		state(Rtt == "RPM")
		dT(45, 54, "per minute")
		state(landinggear_s)
		dT(1, 22, "Landing Gear")
		state(gyro_s)
		dT(1, 28, "Gyro")
		state(moreTilt)
		dT(4, 50, "+")
		state(lessTilt)
		dT(4, 58, "-")
		sC(255, 255, 0)
		dT(10, 54, SF("%.0f", screen_tilt))
		state(brakes)
		dT(1, 34, "brakes")
	end
end
