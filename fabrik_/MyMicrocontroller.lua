require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

joints = {}

joints[1] = { x = 144, y = 0, z = 0 }

for i = 1, 4 do
	joints[i + 1] = { x = joints[i].x, y = joints[i].y + 20, z = joints[i].z }
end

distance = {}

for i = 1, #joints - 1 do
	distance[i] = math.sqrt(
		(joints[i + 1].x - joints[i].x) ^ 2 + (joints[i + 1].y - joints[i].y) ^ 2 + (joints[i + 1].z - joints[i].z) ^ 2
	)
end

target = { x = 144, y = 80, z = 0 }

function len(vec)
	return math.sqrt(vec.x * vec.x + vec.y * vec.y)
end

function copy(src)
	local dst = {}
	for k, v in pairs(src) do
		dst[k] = v
	end
	return dst
end

function vecAdd(a, b)
	local c = copy(a)
	c.x = a.x + b.x
	c.y = a.y + b.y
	c.z = a.z + b.z
	return c
end

function vecSub(a, b)
	local c = copy(b)
	c.x = a.x - b.x
	c.y = a.y - b.y
	c.z = a.z - b.z
	return c
end

function vecMul(a, b)
	local c = copy(a)
	c.x = a.x * b
	c.y = a.y * b
	c.z = a.z * b
	return c
end

function vecDist(a, b)
	return math.sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y) + (a.z - b.z) * (a.z - b.z))
end

function normalize(vec)
	local len = len(vec)
	if len == 0 then
		return vec
	end
	return vecMul(vec, 1 / len)
end

function sumLen(joints)
	local sum = 0
	for i = 1, #joints do
		sum = sum + len(joints[i])
	end
	return sum
end

ticks = 0

function onTick()
	ticks = ticks + 1

	isClick = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)

	if isPressed then
		target = { x = input.getNumber(3), y = input.getNumber(4), z = 0 }
	end
	-- fabrik inverse kinematics
	if len(vecSub(target, joints[1])) < sumLen(joints) then
		local origin = { x = 144, y = 0, z = 0 }
		diff = len(vecSub(target, joints[#joints]))

		if ticks % 10 == 0 then
			joints[#joints].x = target.x
			joints[#joints].y = target.y
			joints[#joints].z = 0

			for i = #joints - 1, 1, -1 do
				local dist = 20 -- vecDist(joints[i + 1], joints[i])
				local lambda = dist / distance[i]
				joints[i].x = (1 - lambda) * joints[i + 1].x + lambda * joints[i].x
				joints[i].y = (1 - lambda) * joints[i + 1].y + lambda * joints[i].y
				joints[i].z = (1 - lambda) * joints[i + 1].z + lambda * joints[i].z
			end

			joints[1].x = origin.x
			joints[1].y = origin.y
			joints[1].z = 0

			for i = 2, #joints - 1 do
				local dist = 20 -- vecDist(joints[i], joints[i - 1])
				local lambda = dist / distance[i - 1]
				joints[i + 1].x = (1 - lambda) * joints[i].x + lambda * joints[i + 1].x
				joints[i + 1].y = (1 - lambda) * joints[i].y + lambda * joints[i + 1].y
				joints[i + 1].z = (1 - lambda) * joints[i].z + lambda * joints[i + 1].z
			end
			diff = len(vecSub(target, joints[#joints]))
		end
	end
end
width, height = 288, 160
xOffset = 0

function onDraw()
	for i = 1, #joints do
		screen.setColor(255, 255, 255)
		screen.drawCircle(joints[i].x + xOffset, joints[i].y, i * 2)

		if i < #joints then
			screen.setColor(255, 255, 255)
			screen.drawLine(joints[i].x + xOffset, joints[i].y, joints[i + 1].x + xOffset, joints[i + 1].y)
		end
	end
end
