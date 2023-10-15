--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
--[====[ HOTKEYS ]====] -- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA
--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====] ---@section __LB_SIMULATOR_ONLY__
do
	---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
	simulator = simulator
	simulator:setScreen(1, "30x30")
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
end
---@endsection

--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

-- simulating occupancy grid
-- user touches the screen to move the observer
-- the observes updates the occupancy grid
-- the occupancy grid is displayed on the screen
-- the line of sight rotates automatically
-- the line of sight is displayed on the screen
-- raycast is used to determine if the line of sight is blocked, and the location of the blockage
-- functions needed
-- 1. bresenham's line algorithm
-- 2. raycast
-- 3. occupancy grid
-- 4. line of sight

math.randomseed(2)

width, height = 1000, 1000 -- screen size
cx, cy = width / 2, height / 2 -- center of screen

obstacles = {}

grid = {}
for x = 1, width do
	grid[x] = {}
	for y = 1, height do grid[x][y] = 0 end
end

function pointInRect(x, y, rx, ry, rw, rh)
	return x >= rx and x <= rx + rw and y >= ry and y <= ry + rh
end

function dist(x1, y1, x2, y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

-- add 10 rectangular obstacles, with random sizes and positions, at least 20 pixels away from the center of the screen
for i = 1, 10 do
	local x, y, w, h = math.random(0, width - 20), math.random(0, height - 20),
					   math.random(10, 50), math.random(10, 50)
	while pointInRect(cx, cy, x, y, w, h) or dist(cx, cy, x, y) < 20 do
		x, y, w, h = math.random(20, width - 20), math.random(20, height - 20),
					 math.random(10, 50), math.random(10, 50)
	end
	obstacles[i] = {x, y, w, h}
end

table.insert(obstacles, {0, 0, width, 1}) -- top
table.insert(obstacles, {0, 0, 1, height}) -- left
table.insert(obstacles, {width - 1, 0, 1, height}) -- right
table.insert(obstacles, {0, height - 1, width, 1}) -- bottom

function raycast(x1, y1, x2, y2)
	local dx, dy = x2 - x1, y2 - y1
	local steps = math.max(math.abs(dx), math.abs(dy))
	local sx, sy = dx / steps, dy / steps
	local x, y = x1, y1
	for i = 1, steps do
		x, y = x + sx, y + sy
		for _, rect in ipairs(obstacles) do
			if pointInRect(x, y, rect[1], rect[2], rect[3], rect[4]) then
				return {x, y}
			end
		end
	end
	return false
end

function bresenham(x1, y1, x2, y2)
	local dx, dy = math.abs(x2 - x1), math.abs(y2 - y1)
	local sx, sy = x1 < x2 and 1 or -1, y1 < y2 and 1 or -1
	local err = dx - dy
	local points = {}
	while true do
		points[#points + 1] = {x1, y1}
		if x1 == x2 and y1 == y2 then break end
		local e2 = 2 * err
		if e2 > -dy then err, x1 = err - dy, x1 + sx end
		if e2 < dx then err, y1 = err + dx, y1 + sy end
	end
	return points
end

ticks = 0
pos = {x = cx, y = cy}
angle = 0.0
ltime = os.clock()
function onTick()
	ticks = ticks + 1

	isClick = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)

	touch = {x = input.getNumber(3), y = input.getNumber(4)}

	if isPressed then
		pos = {x = touch.x, y = touch.y}
	end

	angle = angle + 0.005
	intersect = raycast(pos.x, pos.y, pos.x + math.cos(angle) * 2000, pos.y + math.sin(angle) * 2000)

	if intersect then
		intersect[1] = math.min(math.max(intersect[1], 1), width)
		intersect[2] = math.min(math.max(intersect[2], 1), height)
		line = bresenham(pos.x, pos.y, intersect[1]//1, intersect[2]//1)
		for _, point in ipairs(line) do
			grid[point[1]//1][point[2]//1] = 1 -- math.min(1, grid[point[1]//1][point[2]//1] + 0.5)
		end
		grid[intersect[1]//1][intersect[2]//1] = 0 -- math.max(0, grid[intersect[1]//1][intersect[2]//1] - 0.5)
	end
	fps = 1 / (os.clock() - ltime)
	ltime = os.clock()
end

lastc = 0
function setC(c)
	if c ~= lastc then
		screen.setColor(c, c, c)
		lastc = c
	end
end

function onDraw()
	screen.setColor(5, 5, 5)
	for i, obstacle in ipairs(obstacles) do
		local x, y, w, h = table.unpack(obstacle)
		screen.drawRectF(x, y, w, h)
	end

	screen.setColor(255, 255, 255)
	for i = 1, width, 10 do
		for j = 1, height, 10 do
			if grid[i][j] > 0 then
				screen.drawRectF(i-5, j-5, 10, 10)
			end
		end
	end


	screen.setColor(255, 128, 0)
	screen.drawCircle(pos.x, pos.y, 3.5)

	screen.setColor(255, 128, 0, 128)
	screen.drawLine(pos.x, pos.y, pos.x + math.cos(angle) * 1000, pos.y + math.sin(angle) * 1000)
	if intersect then
		screen.setColor(255, 0, 0)
		-- for i, point in ipairs(intersect) do
			screen.drawCircle(intersect[1], intersect[2], 3.5)
			screen.drawText(2, 2, string.format("x: %3.f, y: %3.f", intersect[1], intersect[2]))
			screen.drawText(2, 10, string.format("%3.f x %3.f", #grid, #grid[1]))
		-- end
	end
	screen.drawText(2, 18, string.format("FPS: %3.f", fps))
end
