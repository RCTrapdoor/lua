centerX = 140
centerY = 70

pi = math.pi


function sum(t)
	local s = 0
	for i = 1, #t do
		s = s + t[i]
	end
	return s
end
-- color table with 20 different RGB values (0-255)
colors = {
	{0, 0, 255},
	{0, 255, 0},
	{0, 255, 255},
	{255, 0, 0},
	{255, 0, 255},
	{255, 255, 0},
	{255, 255, 255},
	{0, 0, 128},
	{0, 128, 0},
	{0, 128, 128},
	{128, 0, 0},
	{128, 0, 128},
	{128, 128, 0},
	{128, 128, 128},
	{0, 0, 64},
	{0, 64, 0},
	{0, 64, 64},
	{64, 0, 0},
	{64, 0, 64},
	{64, 64, 0},
	{64, 64, 64},
	{0, 0, 32},
	{0, 32, 0},
	{0, 32, 32},
	{32, 0, 0},
	{32, 0, 32},
	{32, 32, 0},
	{32, 32, 32},
	{0, 0, 16},
	{0, 16, 0},
	{0, 16, 16},
	{16, 0, 0},
	{16, 0, 16},
	{16, 16, 0},
	{16, 16, 16}
}

math.randomseed(os.clock())
data = {}
for i = 1, 9 do
  data[i] = math.random()
end

table.sort(data, function(a, b)
	return a > b
end)

ticks = 0

function onTick()
	ticks = ticks + 1

	data[1] = math.cos(ticks / 20) * 2 + 2
end

function onDraw()
	start = 0
	smallRadius = 30
	bigRadius = 34
	for i = 1, #data do
		dangle = 2 * pi * (data[i] / sum(data))
    	step = dangle / 10

		screen.setColor(table.unpack(colors[i]))
		for angle = start, start + dangle - 0.0001, step do
			startX = smallRadius * math.cos(angle)
			startY = smallRadius * math.sin(angle)

			startX2 = smallRadius * math.cos(angle + step)
			startY2 = smallRadius * math.sin(angle + step)

			endX = bigRadius * math.cos(angle)
			endY = bigRadius * math.sin(angle)

			endX2 = bigRadius * math.cos(angle + step)
			endY2 = bigRadius * math.sin(angle + step)

			screen.drawTriangleF(
				centerX + startX,
				centerY + startY,
				centerX + endX,
				centerY + endY,
				centerX + endX2,
				centerY + endY2
			)
			screen.drawTriangleF(
				centerX + startX2,
				centerY + startY2,
				centerX + endX2,
				centerY + endY2,
				centerX + startX,
				centerY + startY
			)
		end
		start = start + dangle
		-- print(data[i], sum(data))
	end
end

-- explanation of the code above
-- dangle should not be used as a variable name, because it is a function
-- instead of math.cos, use angle