require("_build._simulator_config")
require("LifeBoatAPI")

Graph = function()
	return {
		data = {},
		globalSpan = true,

		findSpan = function(self, step)
			local min, max
			-- local data = table.pack(self:data_iter(step, width))
			-- min = math.min(table.unpack(data))
			-- max = math.max(table.unpack(data))
			min = math.min(table.unpack(self.data))
			max = math.max(table.unpack(self.data))

			return {min = min, max = max, span = max - min}
		end,

		insert = function(self, channel)
			table.insert(self.data, input.getNumber(channel))
			if #self.data > Number_Of_Samples then
				table.remove(self.data, 1)
			end
		end,

		data_iter = function(self, step, max)
			local i = -1
			local step = step or 1
			return function()
				i = i + step
				if i <= #self.data and i/step <= max then return i/step, self.data[#self.data - i] end
			end
		end
	}
end

Ticks = 0
Paused = false
Data = {}
Channels = 1
Number_Of_Samples = 500
Horizontal_Zoom = 30

for ChID = 1, Channels do
	table.insert(Data, Graph())
	for _ = 1, Number_Of_Samples do
		Data[ChID]:insert(ChID + 22)
	end
end

function onTick()
	Horizontal_Zoom = input.getNumber(22)
	if not Paused then
		Min, Max, Span = math.huge, -math.huge, 0

		Ticks = Ticks + 1
		for ChID, Channel in ipairs(Data) do
			Channel:insert(ChID + 20)
			local span = Channel:findSpan(Horizontal_Zoom)
			Min = math.min(Min, span.min)
			Max = math.max(Max, span.max)
		end
		Span = Max - Min
	end
end

function onDraw()
	width, height = screen.getWidth(), screen.getHeight()
	screen.setColor(255, 255, 255)

	-- for CHid, Channel in ipairs(Data) do -- this works
	-- 	len = #Channel.data
	-- 	for i = 0, width do
	-- 		y = height * (Channel.data[math.max(1, (len - i * Horizontal_Zoom)) // 1] - Min) / Span
	-- 		y_ = height * (Channel.data[math.max(1, (len - (i + 1) * Horizontal_Zoom)) // 1] - Min) / Span
	-- 		screen.drawLine(width - i, y, width - i - 1, y_)
	-- 	end
	-- end

	for CHid, Channel in ipairs(Data) do
		local last_y
		for num, value in Channel:data_iter(5, width) do
			y = height * (value - Min) / Span
			if last_y then
				screen.drawLine(width - num + 1, last_y, width - num, y)
			end
			last_y = y
		end
	end
	screen.setColor(255, 0, 0, 150)
	for CHid, Channel in ipairs(Data) do
		local last_y
		for num, value in Channel:data_iter(1, width) do
			y = height * (value - Min) / Span
			if last_y then
				screen.drawLine(width - num + 1, last_y, width - num, y)
			end
			last_y = y
		end
	end
end