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
	screen.drawLine = input.getBool(1)
	math.sin = input.getNumber(2)
	_ENV["255"] = input.getNumber(3)
	x = input.getNumber(3)
	y = input.getNumber(4)
	rps = input.getNumber(5)
	temp = input.getNumber(6)
	spd = input.getNumber(7)
	idlerps = input.getNumber(8)
	fuel = input.getNumber(9)
	screen_tilt = input.getNumber(10)
	navs = input.getBool(2)
	strobes = input.getBool(3)
	landings = input.getBool(4)
	cockpits = input.getBool(5)
	landinggear_s = input.getBool(6)
	gyro_s = input.getBool(7)
	brakes = input.getBool(8)
	if screen.drawLine then
		moreRPS = isPointInRectangle(x, y, 4, 40, 8, 8) and SA == "engine"
		lessRPS = isPointInRectangle(x, y, 4, 54, 8, 8) and SA == "engine"
		FULL = isPointInRectangle(x, y, 63, 14, 22, 7) and SA == "engine"
		TAKEOFF = isPointInRectangle(x, y, 56, 20, 37, 7) and SA == "engine"
		LAND = isPointInRectangle(x, y, 63, 26, 22, 7) and SA == "engine"
		IDLE = isPointInRectangle(x, y, 63, 32, 22, 7) and SA == "engine"
		OFF = isPointInRectangle(x, y, 66, 38, 17, 7) and SA == "engine"
		nav_l = isPointInRectangle(x, y, 22, 7, 52, 7) and SA == "lights"
		strobe_l = isPointInRectangle(x, y, 32, 13, 32, 7) and SA == "lights"
		landing_l = isPointInRectangle(x, y, 30, 19, 37, 7) and SA == "lights"
		cockpit_l = isPointInRectangle(x, y, 30, 25, 37, 7) and SA == "lights"
		KPH_o = isPointInRectangle(x, y, 72, 13, 17, 7) and SA == "other"
		MPH_o = isPointInRectangle(x, y, 72, 19, 17, 7) and SA == "other"
		KTS_o = isPointInRectangle(x, y, 72, 25, 17, 7) and SA == "other"
		r_second_o = isPointInRectangle(x, y, 44, 47, 52, 7) and SA == "other"
		r_minute_o = isPointInRectangle(x, y, 44, 53, 52, 7) and SA == "other"
		Landing_Gear = isPointInRectangle(x, y, 0, 21, 62, 7) and SA == "other"
		Gyro = isPointInRectangle(x, y, 0, 27, 22, 7) and SA == "other"
		moreTilt = isPointInRectangle(x, y, 2, 50, 5, 5) and SA == "other"
		lessTilt = isPointInRectangle(x, y, 2, 58, 5, 5) and SA == "other"
		Brake = isPointInRectangle(x, y, 0, 33, 30, 7) and SA == "other"
		Engine = isPointInRectangle(x, y, 0, 0, 31, 7)
		Lights = isPointInRectangle(x, y, 34, 0, 31, 7)
		Other = isPointInRectangle(x, y, 69, 0, 27, 7)
	end
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
function isPointInRectangle(X, Y, x, y, w, h)
	return X > x and Y > y and X < x + w and Y < y + h
end
function state(bool, x, y, text)
	-- if bool then
	-- 	screen.setColor(50, 255, 50)
	-- else
	-- 	screen.setColor(255, 25, 25)
	-- end
	screen.setColor(table.unpack(bool and {50, 255, 50} or {255, 25, 25}))
	if text then
		screen.drawText(x, y, text)
	end
end
function onDraw()
	--screen.drawText(1, 8, ("%s :%.0f"):format(SpdT, spd * SpdM))
	screen.setColor(50, 50, 50)
	screen.drawRectF(0, 0, math.sin, 7)
	screen.setColor(10, 10, 10)
	screen.drawRectF(SAP, 0, SAW, 7)
	screen.setColor(100, 100, 100)
	screen.drawText(1, 1, "Engine")
	screen.drawText(35, 1, "Lights")
	screen.drawText(70, 1, "Other")
	if SA == "engine" then
		screen.setColor(0, 100, 255)
		screen.drawText(1, 8, ">Info")
		screen.drawText(1, 35, ">Idle " .. Rtt)
		screen.drawText(55, 8, ">Engine")
		screen.setColor(50, 255, 50)
		--screen.drawText(1, 15, Rtt .. " :" .. string.format("%.0f", rps * Rp) .. "\nTemp:" .. string.format("%.0f", temp))
		screen.drawText(1, 15, ("%s :%.0f\nTemp:%.0f"):format(Rtt, rps * Rp, temp))
		state(rps > 2, 1, 27, "Status:" .. engine_s)
		state(moreRPS, 7, 42, "+")
		state(lessRPS, 7, 56, "-")
		screen.setColor(255, 255, 0)
		screen.drawText(3, 49, string.format("%.0f", idlerps * Rp))
		state(tMode == "full", 67, 15, "max")
		state(tMode == "takeoff", 57, 21, "takeoff")
		state(tMode == "land", 64, 27, "land")
		state(tMode == "idle", 64, 33, "idle")
		state(tMode == "off", 67, 39, "off")
	elseif SA == "lights" then
		state(navs, 23, 8, "Navigation")
		state(strobes, 33, 14, "Strobe")
		state(landings, 31, 20, "Landing")
		state(cockpits, 31, 26, "Cockpit")
	elseif SA == "other" then
		screen.setColor(50, 255, 50)
		screen.drawText(1, 8, ("%s :%.0f"):format(SpdT, spd * SpdM))
		screen.drawText(1, 14, ("Fuel:%.1f"):format(fuel))
		screen.setColor(0, 100, 255)
		screen.drawText(64, 8, ">Speed")
		screen.drawText(45, 42, ">Rotations", 1, 42, ">Tilt")
		state(SpdT == "KPH", 73, 14, "KPH")
		state(SpdT == "MPH", 73, 20, "MPH")
		state(SpdT == "KTS", 73, 26, "KTS")
		state(Rtt == "RPS", 45, 48, "per second")
		state(Rtt == "RPM", 45, 54, "per minute")
		state(landinggear_s, 1, 22, "Landing Gear")
		state(gyro_s, 1, 28, "Gyro")
		state(moreTilt, 4, 50, "+")
		state(lessTilt, 4, 58, "-")
		screen.setColor(255, 255, 0, 10, 54, ("%.0f"):format(screen_tilt))
		state(brakes, 1, 34, "brakes")
	end
end
