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
	simulator:setScreen(1, "5x3")
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
		simulator:setInputBool(31, simulator:getIsClicked(1))     -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
		simulator:setInputNumber(31, simulator:getSlider(1))      -- set input 31 to the value of slider 1

		simulator:setInputBool(32, simulator:getIsToggled(2))     -- make button 2 a toggle, for input.getBool(32)
		simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
	end

	;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!
function lerp(input_start, input_end, output_start, output_end, value)
	return output_start + ((output_end - output_start) / (input_end - input_start)) * (value - input_start)
end

data = {}
maxPoints = 160

ticks = 0

function onTick()
	ticks = ticks + 1
	-- tourqe = input.getNumber(1)
	tourqe = math.sin(ticks / 20)
	table.insert(data, tourqe)

	if #data > maxPoints then
		table.remove(data, 1)
	end

	maxValue = -math.huge
	minValue = math.huge
	for i = 1, #data do
		local value = data[i]
		maxValue = math.max(value, maxValue)
		minValue = math.min(value, minValue)
	end
end

function onDraw()
	width = screen.getWidth()
	height = screen.getHeight()
	
	screen.setColor(30, 30, 30)
	for i = 0, 4 do
		y = 10 + i * (height-20) / 4

		for j = 40, width do
			if j % 10 == 0 then
				screen.drawLine(j, y, j + 5, y)
			end
		end
	end

	screen.setColor(255, 255, 255)
	for k = 1, #data - 1 do
		local value = data[k]
		local value2 = data[k + 1]

		y1 = lerp(minValue, maxValue, height-10, 10, value)
		y2 = lerp(minValue, maxValue, height-10, 10, value2)

		screen.drawLine(k, y1, k + 1, y2)
	end
	screen.setColor(60, 30, 10)
	for i = 0, 4 do
		y = 10 + i * (height - 20) / 4
		y_value = lerp(height - 10, 10, minValue, maxValue, y)

		screen.drawText(0, y - 2, string.format("%6.2f", y_value))
	  end
end
