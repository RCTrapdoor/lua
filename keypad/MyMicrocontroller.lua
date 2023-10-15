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
		simulator:setInputBool(31, simulator:getIsClicked(1))       -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
		simulator:setInputNumber(31, simulator:getSlider(1))        -- set input 31 to the value of slider 1

		simulator:setInputBool(32, simulator:getIsToggled(2))       -- make button 2 a toggle, for input.getBool(32)
		simulator:setInputNumber(32, simulator:getSlider(2) * 50)   -- set input 32 to the value from slider 2 * 50
	end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

function inRect(pos, rect)
	return pos[1] >= rect.x and pos[1] <= rect.x + rect.w and pos[2] >= rect.y and pos[2] <= rect.y + rect.h
end

function Keypad(pos, label)
	return {
		x = pos[1],
		y = pos[2],
		keys = "....-E1234567890",
		text = "",
		label = label,
		fade = 0,

		draw = function(self, pos)
			l = (pos[2] - self.y)//8*4 + (pos[1] - self.x)//8
			screen.setColor(0, 0, 0)
			screen.drawRectF(self.x, self.y, 32 + 1, 32)
			screen.setColor(0, 255, 0)
			screen.drawRect(self.x - 1, self.y - 1, 32 + 2, 32 + 1)
			if #self.text > 6 then
				screen.setColor(0, 0, 0, 150)
				screen.drawRectF(self.x + 1, self.y, -(#self.text - 6) * 5, 7)
			end
			screen.setColor(5, 5, 5)
			screen.drawTextBox(self.x + 1, self.y + 1, 30, 6, self.label, 0, 0)
			screen.setColor(0, 255, 0)
			if t % 30 < 20 then
				local x = self.x + 1 + 5 * math.min(#self.text, 5)
				screen.drawLine(x, self.y + 6, x + 4, self.y + 6)
			end
			screen.drawText(self.x + 1 + 5 * math.min(6 - #self.text, 0), self.y + 1, self.text)
			for i = 0, 11 do
				screen.setColor(20, 20, 20)
				local x = self.x + (i % 4) * 8
				local y = self.y + 8 + math.floor(i / 4) * 8
				screen.drawRect(x, y - 1, 8, 8)
				screen.setColor(100, 200, 200)
				screen.drawText(x + 2, y + 1, self.keys:sub(i + 5, i + 5))
				if l == i + 4 then
					screen.setColor(255, 255, 255, 125 * self.fade / 10)
					screen.drawRectF(x, y - 1, 8, 8)
				end
			end
			self.fade = math.max(0, self.fade - 1)
		end,

		update = function(self, pos)
			if not inRect(pos, {x = self.x, y = self.y, w = 32, h = 32}) then
				return false
			end
			self.fade = 10
			l = (pos[2] - self.y)//8*4 + (pos[1] - self.x)//8 + 1
			if l == 6 then
				val = tonumber(self.text)
				self.text = ""
				return true, val or 0
			elseif l < 5 then
				if not self.text:find("%.") then
					self.text = self.text .. "."
				end
			elseif l == 5 then
				if #self.text == 0 then
					self.text = "-"
				else
					self.text = self.text:sub(1, #self.text - 1)
				end
			else
				self.text = self.text .. self.keys:sub(l, l)
			end
		end
	}
end

test = Keypad({10, 5}, "red")
test2 = Keypad({50, 5}, "green")
test3 = Keypad({10, 45}, "blue")
test4 = Keypad({50, 45}, "alpha")

r,g,b,a = 0,0,0,255

t = 0

function onTick()
	t = t + 1
	isClick = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)

	touch = {input.getNumber(3), input.getNumber(4)}
	if isClick then
		_, val = test:update(touch)
		if _ then
			r = val
		end
	end
	if isClick then
		_, val = test2:update(touch)
		if _ then
			g = val
		end
	end
	if isClick then
		_, val = test3:update(touch)
		if _ then
			b = val
		end
	end
	if isClick then
		_, val = test4:update(touch)
		if _ then
			a = val
		end
	end
end

function onDraw()
	screen.setColor(r, g, b, a)
	screen.drawRectF(0, 0, 320, 240)
	test:draw(touch)
	test2:draw(touch)
	test3:draw(touch)
	test4:draw(touch)
	screen.setColor(255, 255, 255)
	screen.drawText(2, 85, string.format("r: %d g: %d b: %d a: %d", r, g, b, a))
end
