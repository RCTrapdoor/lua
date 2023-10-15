require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library
width, height = 288, 160

ants = {}

math.randomseed(6)

sampleRange = 10
sampleAngle = math.pi / 4
sampleArea = 4

coneAngle = math.atan(sampleArea / sampleRange)

home = { x = 144, y = 80, radius = 5 }

boolToInt = { [true] = 1, [false] = 0 }

for i = 1, 200 do
	ants[i] = {
		-- x = math.random(0, 288),
		-- y = math.random(0, 160),
		x = 144,
		y = 80,
		speed = 1,
		direction = math.random() * math.pi * 2,
		radius = 1,
		has_food = false,
		c = { 0, 0, 0 },
	}
end

food = {}
while #food < 10 do -- 40 pixels from home
	local x = math.random(0, width)
	local y = math.random(0, height)
	if x ^ 2 + y ^ 2 > (home.radius + 60 ^ 2) then
		table.insert(food, { x = x, y = y, hasfood = 5 })
	end
end

pheromones = {}
for i = 0, width - 1 do
	pheromones[i] = {}
	for j = 0, height - 1 do
		pheromones[i][j] = {}
		pheromones[i][j][0] = 0
		pheromones[i][j][1] = 0
	end
end

obstacles = {}
while #obstacles < 100 do -- add 50 obstacles that do not overlap home or food
	local obstacle = {
		x = math.random(0, 288),
		y = math.random(0, 160),
		radius = math.random(10, 20),
	}
	local overlaps = false
	if math.sqrt((obstacle.x - home.x) ^ 2 + (obstacle.y - home.y) ^ 2) < home.radius + obstacle.radius + 30 then
		overlaps = true
	end
	for i = 1, #food do
		if
			math.sqrt((obstacle.x - food[i].x) ^ 2 + (obstacle.y - food[i].y) ^ 2)
			< obstacle.radius + food[i].hasfood + 5
		then
			overlaps = true
		end
	end
	if not overlaps then
		obstacles[#obstacles + 1] = obstacle
	end
end

newGrid = {}
function boxBlur(grid) -- box blur 5x5 each pixel is a 2x1 list, edges are padded with 0
	for i = 0, width - 1 do
		newGrid[i] = {}
		for j = 0, height - 1 do
			newGrid[i][j] = { [0] = 0, [1] = 0 }
		end
	end
	-- local s = (285/19)*(ticks % 19) + 1
	-- for i = s, s + (285/19) do
	for i = 1, width - 2 do
		for j = 1, height - 2 do
			for k = -1, 1 do
				for l = -1, 1 do
					newGrid[i][j][0] = newGrid[i][j][0] + grid[i + k][j + l][0]
					newGrid[i][j][1] = newGrid[i][j][1] + grid[i + k][j + l][1]
					-- if newGrid[i][j][0] < 0.1 then
					-- 	newGrid[i][j][0] = 0
					-- end
					-- if newGrid[i][j][1] < 0.1 then
					-- 	newGrid[i][j][1] = 0
					-- end
				end
			end
		end
	end
	return newGrid
end
-- The box blur function is slow, and could be improved by only blurring one set of rows at a time, and then blurring the columns
-- This would be a lot faster, but would require a lot more memory, and would be a lot more complicated to implement
-- Implementation below
-- function boxBlur(grid)
-- 	local newGrid = {}
-- 	for i = 0, width - 1 do
-- 		newGrid[i] = {}
-- 		for j = 0, height - 1 do
-- 			newGrid[i][j] = { [0] = 0, [1] = 0 }
-- 		end
-- 	end
-- 	for i = 1, width - 2 do
-- 		for j = 1, height - 2 do
-- 			for k = -1, 1 do
-- 				newGrid[i][j][0] = newGrid[i][j][0] + grid[i + k][j][0] / 6
-- 				newGrid[i][j][1] = newGrid[i][j][1] + grid[i + k][j][1] / 6
-- 			end
-- 		end
-- 	end
-- 	for i = 1, width - 2 do
-- 		for j = 1, height - 2 do
-- 			for k = -1, 1 do
-- 				newGrid[i][j][0] = newGrid[i][j][0] + newGrid[i][j + k][0] / 6
-- 				newGrid[i][j][1] = newGrid[i][j][1] + newGrid[i][j + k][1] / 6
-- 			end
-- 		end
-- 	end
-- 	return newGrid
-- end


function wrap(v, min, max)
	return (v - min) / (max - min) % 1 * (max - min) + min
end

function clamp(v, min, max)
	return math.max(min, math.min(max, v))
end

function round(a)
	return math.floor(a + 0.5)
end

function vecAdd(a, b)
	return { x = a.x + b.x, y = a.y + b.y }
end
function vecSub(a, b)
	return { x = a.x - b.x, y = a.y - b.y }
end
function vecMul(a, b)
	return { x = a.x * b, y = a.y * b }
end
function dotProduct(a, b)
	return a.x * b.x + a.y * b.y
end
function vecLength(a)
	return math.sqrt(dotProduct(a, a))
end
function vecNormalize(a)
	local length = vecLength(a)
	return { x = a.x / length, y = a.y / length }
end
function vecRotate(a, angle)
	return { x = a.x * math.cos(angle) - a.y * math.sin(angle), y = a.x * math.sin(angle) + a.y * math.cos(angle) }
end

function samplePheromones(ant)
	-- t_now = os.clock()
	ant.c = { 0, 0, 0 }
	for i = -1, 1, 1 do
		local angle = ant.direction - sampleAngle * i
		local x = ant.x + math.cos(angle) * sampleRange
		local y = ant.y + math.sin(angle) * sampleRange
		local radius = sampleArea + sampleRange + home.radius
		local homeAngleDelta = wrap(math.atan(home.y - ant.y, home.x - ant.x) - angle, -math.pi, math.pi)
		if
			ant.has_food
			and (home.x - ant.x) ^ 2 + (home.y - ant.y) ^ 2 < radius ^ 2
			and homeAngleDelta < coneAngle
			and homeAngleDelta > -coneAngle
		then
			ant.c = { 0, 0, 0 }
			ant.c[i + 2] = 10
			goto continue
		end
		-- t0 = os.clock()
		if not ant.has_food then
			for f = 1, #food do
				local foodAngle = wrap(math.atan(food[f].y - ant.y, food[f].x - ant.x) - angle, -math.pi, math.pi)
				local foodRadius = food[f].hasfood + radius - home.radius
				if
					(food[f].x - ant.x) ^ 2 + (food[f].y - ant.y) ^ 2 < foodRadius ^ 2
					and foodAngle < coneAngle
					and foodAngle > -coneAngle
				then
					ant.c = { 0, 0, 0 }
					ant.c[i + 2] = 10
					goto continue
				end
			end
		end
		-- t.food = t.food + os.clock() - t0

		-- t0 = os.clock()
		for j = math.max(0, round(x - sampleArea)), math.min(287, round(x + sampleArea)) do
			for k = math.max(0, round(y - sampleArea)), math.min(159, round(y + sampleArea)) do
				if pheromones[j][k][boolToInt[not ant.has_food]] > 0.1 then
					if (j - x) ^ 2 + (k - y) ^ 2 < sampleArea then
						ant.c[i + 2] = pheromones[j][k][boolToInt[not ant.has_food]] + ant.c[i + 2]
					end
				end
			end
		end
		-- t.sample = t.sample + os.clock() - t0
	end
	::continue::
	if ant.c[1] > ant.c[2] and ant.c[1] > ant.c[3] then
		ant.direction = ant.direction + 0.5
	elseif ant.c[3] > ant.c[1] and ant.c[3] > ant.c[2] then
		ant.direction = ant.direction - 0.5
	else
		ant.direction = ant.direction
	end
	-- t.all = t.all + os.clock() - t_now
end

ticks = 0

lastTime = os.clock()
lastTicks = 0
-- fps = 0
-- t = { food = 0, sample = 0, all = 0 }
function onTick()
	isClick = isPressed and not input.getBool(1)
	isPressed = input.getBool(1)

	if isClick then
		toggle = not toggle
	end
	--updatePheromones()
	if ticks % 30 == 0 then
		pheromones = boxBlur(pheromones)
	end

	for i = 1, #ants do
		local ant = ants[i]
		samplePheromones(ant)
		-- samplePheromones(ants[i])
		ant.direction = (ant.direction + (math.random() - 0.5) / 15) % (math.pi * 2)
		ant.x = ant.x + math.cos(ant.direction) * ant.speed
		ant.y = ant.y + math.sin(ant.direction) * ant.speed

		-- reflect off obstacles, use the vector functions
		for j = 1, #obstacles do
			local obstacle = obstacles[j]
			local distance = math.sqrt((ant.x - obstacle.x) ^ 2 + (ant.y - obstacle.y) ^ 2)
			if distance < obstacle.radius + ant.radius then
				local normal = { x = (ant.x - obstacle.x) / distance, y = (ant.y - obstacle.y) / distance }
				ant.x = ant.x - 2 * normal.x * (distance - obstacle.radius - ant.radius)
				ant.y = ant.y - 2 * normal.y * (distance - obstacle.radius - ant.radius)
				-- calculate new direction based on the normal
				ant.direction = math.random() * math.pi * 2 --ant.direction + math.atan(normal.y, normal.x)
			end
		end

		local directionVector = { x = math.cos(ant.direction), y = math.sin(ant.direction) }

		if ant.x < 0 then
			ant.x = 0
			ant.direction = math.random() * math.pi * 2 --
			-- ant.direction = math.atan(directionVector.y, -directionVector.x)
		elseif ant.x > 287 then
			ant.x = 287
			ant.direction = math.random() * math.pi * 2 --
			-- ant.direction = math.atan(directionVector.y, -directionVector.x)
		end
		if ant.y < 0 then
			ant.y = 0
			ant.direction = math.random() * math.pi * 2 --
			-- ant.direction = math.atan(-directionVector.y, directionVector.x)
		elseif ant.y > 159 then
			ant.y = 159
			ant.direction = math.random() * math.pi * 2 --
			-- ant.direction = math.atan(-directionVector.y, directionVector.x)
		end
		pheromones[clamp(round(ant.x), 2, 285)][clamp(round(ant.y), 2, 157)][boolToInt[ant.has_food]] = math.min(
			pheromones[clamp(round(ant.x), 2, 285)][clamp(round(ant.y), 2, 157)][boolToInt[ant.has_food]] + 0.1,
			3
		)

		if (ant.x - home.x) ^ 2 + (ant.y - home.y) ^ 2 < home.radius ^ 2 then
			if ant.has_food then
				ant.has_food = false
				ant.direction = ant.direction + math.pi + math.random() - 0.5
			end
		end
		for j = #food, 1, -1 do
			if (ant.x - food[j].x) ^ 2 + (ant.y - food[j].y) ^ 2 < food[j].hasfood ^ 2 + 1 and not ant.has_food then
				ant.has_food = true
				ant.direction = ant.direction + math.pi + math.random() - 0.5
				food[j].hasfood = food[j].hasfood - 0.02
				if food[j].hasfood < 0 then
					table.remove(food, j)
				end
				break
			end
		end
	end
	ticks = ticks + 1
	-- if os.clock() - lastTime > 2 then
	-- 	-- print(t.sample, t.food, t.all)
	-- 	-- t = { food = 0, sample = 0, all = 0 }
	-- 	fps = (ticks - lastTicks) / (os.clock() - lastTime)
	-- 	lastTicks = ticks
	-- 	lastTime = os.clock()
	-- end
	--sort ants by whether they have food
	table.sort(ants, function(a, b)
		return a.has_food and not b.has_food
	end)
end
print("derp")
timenow = os.clock()
function onDraw()
	screen.setColor(40, 30, 5)
	screen.drawClear()

	-- for i = 1, #pheromones do
	--     local pheromone = pheromones[i]
	--     screen.setColor(pheromone.type == 0 and 255 or 0, pheromone.type == 1 and 255 or 0, 0)
	--     screen.drawLine(pheromone.x, pheromone.y, pheromone.x + 1, pheromone.y + 1)
	-- end
	screen.setColor(50, 50, 125)
	screen.drawCircleF(home.x, home.y, home.radius)

	for i = 1, #food do
		local food = food[i]
		screen.setColor(255, 255, 255)
		screen.drawCircleF(food.x, food.y, food.hasfood)
	end

	-- draw the pheromones
	screen.setColor(255, 255, 255)
	-- for i = home.x - 3, home.x + 30, 4 do
	-- 	for j = home.y - 28, home.y + 30, 4 do
	-- 		local pheromoneStrength = pheromones[i][j][0]
	-- 		screen.setColor(255, 255, 255, math.min(255, pheromoneStrength * 255))
	-- 		screen.drawCircle(i, j, pheromoneStrength * 2)
	-- 	end
	-- end
	-- for i = home.x - 28, home.x + 30, 4 do
	-- 	for j = home.y-30 ,home.y + 30, 4 do
	-- 		local pheromoneStrength = pheromones[i][j][1]
	-- 		screen.setColor(0, 255, 0, math.min(255, pheromoneStrength * 255))
	-- 		screen.drawCircle(i, j, pheromoneStrength * 2)
	-- 	end
	-- end

	-- for i = home.x-30, home.x+30, 1 do
	-- 	for j = home.y-30, home.y+30, 1 do
	-- 		local pheromoneStrength = pheromones[i][j][0]
	-- 		screen.setColor(255, 255, 255, math.min(255, pheromoneStrength * 255))
	-- 		screen.drawRectF(i - 2, j - 1, 4, 4)
	-- 	end
	-- end
	if toggle then
		for i = 0, width - 1, 4 do
			for j = 0, height - 1, 4 do
				local pheromoneStrength = pheromones[i][j][1]
				screen.setColor(0, 255, 0, math.min(255, pheromoneStrength * 255))
				screen.drawRectF(i - 2, j - 1, 4, 4)
			end
		end
	end

	lastfood = true
	screen.setColor(0, 255, 0)
	for i = 1, #ants do
		local ant = ants[i]
		if not ant.has_food and lastfood then
			screen.setColor(0, 0, 0)
			lastfood = false
		end
		-- screen.drawCircle(ant.x, ant.y, ant.r)
		screen.drawLine(ant.x, ant.y, ant.x + math.cos(ant.direction) * 3, ant.y + math.sin(ant.direction) * 3)
		-- if i == 1 then
		-- 	-- screen.setColor(255, 255, 255, math.max(1, ant.c[3] * 255))
		-- 	screen.drawCircleF(
		-- 		ant.x + math.cos(ant.direction - sampleAngle) * sampleRange,
		-- 		ant.y + math.sin(ant.direction - sampleAngle) * sampleRange,
		-- 		sampleArea
		-- 	)
		-- 	-- screen.setColor(0, 0, 0)
		-- 	screen.drawCircle(
		-- 		ant.x + math.cos(ant.direction - sampleAngle) * sampleRange,
		-- 		ant.y + math.sin(ant.direction - sampleAngle) * sampleRange,
		-- 		sampleArea
		-- 	)

		-- 	-- screen.setColor(255, 255, 255, math.max(1, ant.c[1] * 255))
		-- 	screen.drawCircleF(
		-- 		ant.x + math.cos(ant.direction + sampleAngle) * sampleRange,
		-- 		ant.y + math.sin(ant.direction + sampleAngle) * sampleRange,
		-- 		sampleArea
		-- 	)
		-- 	-- screen.setColor(0, 0, 0)
		-- 	screen.drawCircle(
		-- 		ant.x + math.cos(ant.direction + sampleAngle) * sampleRange,
		-- 		ant.y + math.sin(ant.direction + sampleAngle) * sampleRange,
		-- 		sampleArea
		-- 	)

		-- 	-- screen.setColor(255, 255, 255, math.max(1, ant.c[2] * 255))
		-- 	screen.drawCircleF(
		-- 		ant.x + math.cos(ant.direction) * sampleRange,
		-- 		ant.y + math.sin(ant.direction) * sampleRange,
		-- 		sampleArea
		-- 	)
		-- 	-- screen.setColor(0, 0, 0)
		-- 	screen.drawCircle(
		-- 		ant.x + math.cos(ant.direction) * sampleRange,
		-- 		ant.y + math.sin(ant.direction) * sampleRange,
		-- 		sampleArea
		-- 	)
		-- end
	end

	-- draw the obstacles
	screen.setColor(60, 60, 60, 255)
	for i = 1, #obstacles do
		local obstacle = obstacles[i]
		screen.drawCircleF(obstacle.x, obstacle.y, obstacle.radius)
	end
	-- navy blue
	screen.setColor(0, 0, 255)
	-- screen.drawTextBox(0, 150, 288, 10, string.format("pheromones %4d  -  fps %4.1f", #pheromones, fps), 0, 0)
end
