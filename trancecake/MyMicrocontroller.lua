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

function rotPoints(points, angle)
	local rotated_points = {}
	for k = 1, #points do
		rotated_points[k] = rot2d(points[k], angle)
	end
	return rotated_points
end

function rot2d(point, angle)
	local c, s = math.cos(angle), math.sin(angle)
	local x, y = point.x, point.y
	return { x = x * c - y * s, y = x * s + y * c }
end

bars_template = {
	{
		{ x = -4, y = 16 },
		{ x = 4,  y = 16 },
		{ x = 4,  y = 0 },
		{ x = -4, y = 0 }
	},
	{
		{ x = -4, y = 0 },
		{ x = 4,  y = 0 },
		{ x = 4,  y = -16 },
		{ x = -4, y = -16 }
	},
	{
		{ x = -4, y = 2 },
		{ x = 4,  y = 2 },
		{ x = 4,  y = -2 },
		{ x = -4, y = -2 }
	}
}

colors = {
	{ 255, 0, 0 },
	{ 0, 255, 0 },
	{ 0, 0, 0 }
}

ticks = 0
function onTick()
	bars = {}
	ticks = ticks + 1
	value = math.sin(ticks / 60)
	for i = 1, 4 do
		bars_template[3][i].y = (i < 3 and -2 or 2) + value * 14
	end

	for i = 1, 3 do
		bars[i] = rotPoints(bars_template[i], ticks / 100)
	end
end

function onDraw()
	screen.setColor(70, 70, 70)
	screen.drawClear()

	x_offset = 32
	y_offset = 32
	for k = 1, #bars do
		screen.setColor(colors[k][1], colors[k][2], colors[k][3])
		for i = 0,1 do
			screen.drawTriangle(bars[k][1].x + x_offset, bars[k][1].y + y_offset, bars[k][2 + i].x + x_offset,
				bars[k][2 + i].y + y_offset, bars[k][3 + i].x + x_offset, bars[k][3 + i].y + y_offset)
		end
	end
end
