-- Author: <Authorname> (Please change this in user settings, Ctrl+Comma)
-- GitHub: <GithubLink>
-- Workshop: <WorkshopLink>
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
	---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
	simulator = simulator
	simulator:setScreen(1, "3x3")
	simulator:setProperty("ExampleNumberProperty", 123)

	-- Runs every tick just before onTick; allows you to simulate the inputs changing
	---@param simulator Simulator Use simulator:<function>() to set inputs etc.
	---@param ticks     number Number of ticks since simulator started
	function onLBSimulatorTick(simulator, ticks)
		-- touchscreen defaults
		local screenConnection = simulator:getTouchScreen(1)
		simulator:setInputBool(1, screenConnection.isTouched)
		simulator:setInputNumber(1, screenConnection.width)
		simulator:setInputNumber(2, screenConnection.height)
		simulator:setInputNumber(3, screenConnection.touchX)
		simulator:setInputNumber(4, screenConnection.touchY)

		-- NEW! button/slider options from the UI
		simulator:setInputBool(31, simulator:getIsClicked(1)) -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
		simulator:setInputNumber(31, simulator:getSlider(1)) -- set input 31 to the value of slider 1

		simulator:setInputBool(32, simulator:getIsToggled(2)) -- make button 2 a toggle, for input.getBool(32)
		simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
	end

	;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

--vtol
targ = 14 -- property.getNumber("Target Height")

tau = 2 * math.pi

function PID(P, I, D, a, b, c)
	return {
		Kp = P,
		Ki = I,
		Kd = D,
		min = a,
		max = b,
		alpha = c or 1,
		integral = 0,
		last_error = 0,
		filtered_error = 0,
		run = function(self, sp, pv)
			local error = sp - pv
			self.integral = math.max(a, math.min(b, self.integral + error * self.Ki))
			self.filtered_error = self.alpha * error + (1 - self.alpha) * self.filtered_error
			local derivative = (self.filtered_error - self.last_error)
			self.last_error = self.filtered_error
			return self.Kp * error + self.integral + self.Kd * derivative
		end
	}
end

function clamp(a, b, c) -- min, max, value
	return math.max(a, math.min(b, c))
end

croll       = PID(0, 0.015, 0.05, -0.15, 0.15)
cpitch      = PID(0.01, 0.04, 0.2, -0.15, 0.15)
calt        = PID(0.04, 0.0025, 0.01, 0, 1)

ticks       = 0
vspeed_last = 0
vacc        = 0
roll_last   = 0
rollacc     = 0
pitch_last  = 0
pitchacc    = 0
alt = 0
alt_last = 0

function onTick()
	ticks           = ticks + 1
	roll            = input.getNumber(4)
	yaw             = input.getNumber(5)
	pitch           = -input.getNumber(6)
	--targ = input.getNumber(25)
	alt             = input.getNumber(2)
	-- vspeed          = input.getNumber(8)
	vspeed = (alt - alt_last) * 60
	angu            = { x = input.getNumber(10), y = input.getNumber(11), z = input.getNumber(12) }

	target_pitch    = input.getNumber(16) * 0.03
	target_roll     = -input.getNumber(15) * 0.03
	target_yaw      = input.getNumber(17) * 0.02
	target_alt_diff = input.getNumber(18) * 0.02
	targ            = targ + target_alt_diff

	toggle = input.getBool(5)

	vacc            = 10 * 1 * (vspeed - vspeed_last) + 0 * vacc
	pitchacc        = 60 * (angu.x - pitch_last) + 0 * pitchacc
	rollacc         = 60 * (angu.z - roll_last) + 0 * rollacc

	if alt ~= 0 and ticks > 60 and toggle then
		a = calt:run(clamp(-1, 1, (targ - alt) / 1 - vspeed), vacc)
		-- a = calt:run(clamp(-1, 1, (targ - alt) / 8), vspeed)
		r = croll:run(clamp(-0.1, 0.1, ((target_roll - roll) * 2 - angu.z)), rollacc)
		p = cpitch:run(clamp(-0.1, 0.1, ((target_pitch - pitch) * 2 - angu.x)), pitchacc)

		output.setNumber(1, clamp(-1, 1, -p - r + a + 0))
		output.setNumber(2, clamp(-1, 1, -p + r + a + 0))
		output.setNumber(3, clamp(-1, 1, p - r + a * 0.7 + 0))
		output.setNumber(4, clamp(-1, 1, p + r + a * 0.7 + 0))

		output.setNumber(5, targ - alt)
		output.setNumber(6, vspeed)
		output.setNumber(7, vacc)
		output.setNumber(8, a)

		-- output.setNumber(5, pitch)
		-- output.setNumber(6, angu.x)
		-- output.setNumber(7, pitchacc)
		-- output.setNumber(8, p)

		-- output.setNumber(5, roll)
		-- output.setNumber(6, angu.z)
		-- output.setNumber(7, rollacc)
		-- output.setNumber(8, r)
	end

	if not toggle then
		output.setNumber(1, 0)
		output.setNumber(2, 0)
		output.setNumber(3, 0)
		output.setNumber(4, 0)
	end

	vspeed_last = vspeed
	roll_last = angu.z
	pitch_last = angu.x
	alt_last = alt
end

function onDraw()
	screen.setColor(0, 0, 0)
	screen.drawClear()
	screen.setColor(255, 255, 255)
	screen.drawText(2, 2, string.format("%6s x %6s x %6s", "roll", "pitch", "yaw"))
	screen.drawText(2, 10, string.format("%6.2f x %6.2f x %6.2f", roll, pitch, yaw))
end
