require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
-- require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library
-- local profiler = require("profiler")
-- profiler.start()
require("quadtree")
width, height = 288, 160

ants = {}

-- math.randomseed(os.time())

sampleRange = 12
sampleAngle = math.pi / 4
sampleArea = 4

coneAngle = math.atan(sampleArea / sampleRange)

antCount = 1000
types = 3

for i = 1, antCount do
	ants[i] = {
		type = math.random(types),
		x = math.random(width),
		y = math.random(height),
		direction = math.random()*2 * math.pi,
		speed = math.random()*2 + 1,
		turnSpeed = math.random()*0.5 + 0.1,
	}
end

pheromones = {}

function updatePheromones()
	for i = #pheromones, 1, -1 do
		pheromones[i].strength = pheromones[i].strength - 0.01
		if pheromones[i].strength < 0 then
			table.remove(pheromones, i)
		end
	end
end

function wrap(v, min, max)
	return (v - min) / (max - min) % 1 * (max - min) + min
end

function samplePheromones(ant)
	local pheromones = tree:query(ant.x, ant.y, sampleRange, {})
	ant.c = { 0, 0, 0 }
	
	for i = -1, 1, 1 do
		local angle = ant.direction - sampleAngle * i
		local x = ant.x + math.cos(angle) * sampleRange
		local y = ant.y + math.sin(angle) * sampleRange
		for j = 1, #pheromones do
			local pheromone = pheromones[j]
			-- if pheromone.x > (x + sampleArea) then
			-- 	break
			if pheromone.x > (x - sampleArea) and pheromone.x < (x + sampleArea) then
				if pheromone.type == ant.type then
					if (pheromone.x - x) ^ 2 + (pheromone.y - y) ^ 2 < sampleArea ^ 2 then
						ant.c[i + 2] = ant.c[i + 2] + pheromone.strength * 1.5
					end
				else
					if (pheromone.x - x) ^ 2 + (pheromone.y - y) ^ 2 < sampleArea ^ 2 then
						ant.c[i + 2] = ant.c[i + 2] - pheromone.strength
					end
				end
			end
		end
	end
	if ant.c[1] > ant.c[2] and ant.c[1] > ant.c[3] then
		ant.direction = ant.direction + ant.turnSpeed
	elseif ant.c[3] > ant.c[1] and ant.c[3] > ant.c[2] then
		ant.direction = ant.direction - ant.turnSpeed
	else
		ant.direction = ant.direction
	end
end

ticks = 0

lastTime = os.clock()
lastTicks = 0
fps = 0
function onTick()
	updatePheromones()
	-- sort pheromones by x for sweep and prune
	-- table.sort(pheromones, function(a, b)
	-- 	return a.x < b.x
	-- end)
	tree = QuadTree(0, 0, 288, 160, 1)
	for i = 1, #pheromones do
		local pheromone = pheromones[i]
		tree:insert(pheromone)
	end

	for i = 1, #ants do
		local ant = ants[i]
		samplePheromones(ant)
		ant.direction = (ant.direction + (math.random() - 0.5) / 15) % (math.pi * 2)
		ant.x = ant.x + math.cos(ant.direction) * ant.speed
		ant.y = ant.y + math.sin(ant.direction) * ant.speed

		-- local directionVector = { x = math.cos(ant.direction), y = math.sin(ant.direction) }

		if ant.x < 0 then
			ant.x = 288
		elseif ant.x > 288 then
			ant.x = 0
		end
		if ant.y < 0 then
			ant.y = 160
		elseif ant.y > 160 then
			ant.y = 0
		end

		if (ticks % #ants) + 1 == i then
		-- if ticks % 60 == 0 then
			table.insert(pheromones, { x = ant.x, y = ant.y, strength = 5, type = ant.type })
		end
	end
	ticks = ticks + 1
	if os.clock() - lastTime > 1 then
		if profiler then
			profiler.report("profiler.log") -- exampleConsolePrint will now be called from this
			profiler.stop()
		end
		fps = (ticks - lastTicks) / (os.clock() - lastTime)
		lastTicks = ticks
		lastTime = os.clock()
	end
end
timenow = os.clock()
colors = {
	{ 0, 0, 0 },
	{ 255, 0, 0 },
	{ 0, 255, 0 },
	{ 0, 0, 255 },
	{ 255, 255, 0 },
	{ 255, 0, 255 },
	{ 0, 255, 255 },
	{ 255, 255, 255 },
	{ 128, 128, 128 }
}
function onDraw()
	screen.setColor(40, 30, 5)
	screen.drawClear()

	-- screen.setColor(0, 0, 0, 100)
	-- tree:drawTree()

	lasttype = nil
	screen.setColor(table.unpack(colors[3]))
	table.sort(ants, function(a, b) return a.type < b.type end)
	for i = 1, #ants do
		local ant = ants[i]
		if ant.type ~= lasttype then
			screen.setColor(table.unpack(colors[ant.type]))
			lasttype = ant.type
		end
		screen.drawLine(ant.x, ant.y, ant.x + math.cos(ant.direction) * 3, ant.y + math.sin(ant.direction) * 3)

	-- 	-- if i == 1 then
	-- 	-- 	-- screen.setColor(255, 255, 255, math.max(1, ant.c[3] * 255))
	-- 	-- 	screen.drawCircleF(
	-- 	-- 		ant.x + math.cos(ant.direction - sampleAngle) * sampleRange,
	-- 	-- 		ant.y + math.sin(ant.direction - sampleAngle) * sampleRange,
	-- 	-- 		sampleArea
	-- 	-- 	)
	-- 	-- 	-- screen.setColor(0, 0, 0)
	-- 	-- 	screen.drawCircle(
	-- 	-- 		ant.x + math.cos(ant.direction - sampleAngle) * sampleRange,
	-- 	-- 		ant.y + math.sin(ant.direction - sampleAngle) * sampleRange,
	-- 	-- 		sampleArea
	-- 	-- 	)

	-- 	-- 	-- screen.setColor(255, 255, 255, math.max(1, ant.c[1] * 255))
	-- 	-- 	screen.drawCircleF(
	-- 	-- 		ant.x + math.cos(ant.direction + sampleAngle) * sampleRange,
	-- 	-- 		ant.y + math.sin(ant.direction + sampleAngle) * sampleRange,
	-- 	-- 		sampleArea
	-- 	-- 	)
	-- 	-- 	-- screen.setColor(0, 0, 0)
	-- 	-- 	screen.drawCircle(
	-- 	-- 		ant.x + math.cos(ant.direction + sampleAngle) * sampleRange,
	-- 	-- 		ant.y + math.sin(ant.direction + sampleAngle) * sampleRange,
	-- 	-- 		sampleArea
	-- 	-- 	)

	-- 	-- 	-- screen.setColor(255, 255, 255, math.max(1, ant.c[2] * 255))
	-- 	-- 	screen.drawCircleF(
	-- 	-- 		ant.x + math.cos(ant.direction) * sampleRange,
	-- 	-- 		ant.y + math.sin(ant.direction) * sampleRange,
	-- 	-- 		sampleArea
	-- 	-- 	)
	-- 	-- 	-- screen.setColor(0, 0, 0)
	-- 	-- 	screen.drawCircle(
	-- 	-- 		ant.x + math.cos(ant.direction) * sampleRange,
	-- 	-- 		ant.y + math.sin(ant.direction) * sampleRange,
	-- 	-- 		sampleArea
	-- 	-- 	)
	-- 	-- end
	end
	screen.drawTextBox(0, 150, 288, 10, string.format("pheromones %4d  -  fps %4.1f - ants %4d", #pheromones, fps, #ants), 0, 0)
end
