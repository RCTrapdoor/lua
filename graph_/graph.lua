-- Author: Trapdoor
-- GitHub: Trapdoor
-- Workshop: Trapdoor

--Trapdoor--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

sample_rate = property.getNumber("Sample every n-th tick")
data = {}

notations = { "%11f", "%11e", "%11g" }

min_max_notation = property.getNumber("Min/Max Value Notation")
current_notation = property.getNumber("Current Value Notation")

channels = property.getNumber("Number of Channels")
num_samples = property.getNumber("Number of Samples")

graph_colors = { { 255, 0, 0 }, { 255, 255, 0 }, { 0, 255, 0 }, { 255, 0, 255 }, { 0, 255, 255 }, { 0, 0, 255 }, { 55, 0, 0 }, { 55, 55, 0 } }
csv_busy = false
labels = {}

csv_index = 0

ticks = 0
ttl = 0
set_coord = 0.005

function sum(t)
	local s = 0
	for i = 1, #t do
		s = s + t[i]
	end
	return s
end

for i = 1, channels do
	table.insert(data, { state = true, history = {} })
	for a = 1, num_samples do
		table.insert(data[i].history, 0)
	end
	table.insert(labels, property.getText("Label " .. i))
end

function find_span()
	mi = math.huge
	ma = -math.huge

	for k, v in ipairs(data) do

		if #v.history > num_samples then
			table.remove(v.history, 1)
		end

		if v.state then
			for history_slice = #v.history - offset, math.max(#v.history - 230 - offset, 1), -1 do
				mi = math.min(mi, v.history[history_slice])
				ma = math.max(ma, v.history[history_slice])
				span = ma - mi
			end
		end

	end
end

offset1_button, offset2_button = 0, 0
click = 0
function onTick()
	ticks = ticks + 1
	click = input.getBool(1) and click + 1 or 0
	inputX = input.getNumber(3)
	inputY = input.getNumber(4)
	if click == 1 then
		if isPointInRectangle(inputX, inputY, 232, 1, 58, channels * 16) then
			c = math.min(channels, math.max(1, math.ceil(inputY / 16)))
			data[c].state = not data[c].state

		elseif isPointInRectangle(inputX, inputY, 263, 135, 22, 22) and not csv_busy then
			cursor = nil
			offset = 0
			pause = not pause
		elseif isPointInRectangle(inputX, inputY, 235, 135, 22, 22) then
			waiting = true
			csv_index = 0
			csv_busy = true
			ttl = ticks
			pause = true
			async.httpGet(25735, ("/start?c=%d&r=%d"):format(channels, sample_rate))
		end
	end
	if click > 0 then
		if isPointInRectangle(inputX, inputY, 0, 151, 9, 9) then
			offset = math.min(offset + click // 5 + 1, #data[1].history - 232)
			offset1_button = ticks + 5

		elseif isPointInRectangle(inputX, inputY, 221, 151, 9, 9) then
			offset = math.max(offset - click // 5 - 1, 0)
			offset2_button = ticks + 5
		end
	end

	if ticks - ttl > 120 then
		csv_busy = false
	elseif csv_busy and not waiting then
		query_text = ""
		while true do
			-- if (csv_offset + 1) >= #data[1].history then
			-- 	csv_busy = false
			-- 	pause = false
			-- 	break
			-- end
			query_text_temp = ""
			csv_index = csv_index + 1
			for a = 1, #data do
				query_text_temp = query_text_temp .. data[a].history[csv_index] .. ","
			end
			if (#query_text + #query_text_temp) >= 3800 or csv_index >= #data[1].history then
				waiting = true
				async.httpGet(25735, "/data?d=" .. query_text)
				csv_index = csv_index - 1
				if (csv_index + 1) >= #data[1].history then
					async.httpGet(25735, "/done")
					csv_busy = false
					pause = false
					ttl = ticks
				end
				break
			else
				query_text = query_text .. query_text_temp
			end
		end
	end

	if pause then
		find_span()

		if click == 1 and isPointInRectangle(inputX, inputY, 0, 0, 230, 150) then
			cursor = inputX
		end

		return true
	end

	if ticks % sample_rate == 0 then
		for i = 1, channels do
			table.insert(data[i].history, input.getNumber(9 + i))
		end
	end

	find_span()
end

function httpReply(port, request, reply)
	if reply:find("OK") then
		waiting = false
	end
end

offset = 0
shades = { { 100, 100, 100 }, { 140, 140, 140 }, { 55, 55, 55 }, { 0, 0, 0 }, {5, 5, 5}}
function onDraw()
	
	for i = 170, 0, -60 do
		screen.setColor(table.unpack(shades[5]))
		screen.drawLine(i, 0, i, 151)
		screen.setColor(table.unpack(shades[3]))
		screen.drawText(i+3, 145, string.format("%d s", (230-i)//(60/sample_rate)))
	end

	screen.setColor(table.unpack(shades[1]))

	width, height = screen.getWidth(), screen.getHeight() - 10
	display = false

	if #data[1].history > 1 then
		--screen.drawTextBox(232, 146, 29, 10, "Hold", 0, 0)
		for i = pause and 0 or -(ticks // sample_rate) % 10, 230, 10 do
			screen.drawLine(i, height - height * (1 / span) * (0 - mi), math.min(230, i + 5), height - height * (1 / span) * (0 - mi))
		end

		for k, v in ipairs(data) do
			if v.state then
				display = true
				screen.setColor(table.unpack(graph_colors[k]))
				for a = 1, 230 do
					n = num_samples - 230 + a - offset
					screen.drawLine(a - 1, height - (height / span) * (v.history[n - 1] - mi), a, height - (height / span) * (v.history[n] - mi))
				end
			else
				screen.setColor(table.unpack(shades[3]))
			end
			if #v.history > 0 then
				screen.drawText(232, 16 * k - 14, labels[k])
				screen.drawText(232, 16 * k - 8, notations[current_notation]:format(v.history[cursor and math.min(#v.history - 230 + cursor - offset, #v.history) or #v.history]))
				screen.setColor(table.unpack(shades[3]))
				screen.drawLine(230, 16 * k - 17, 288, 16 * k - 17)
			end
		end
		--screen.setColor(table.unpack(shades[3]))
		-- screen.drawLine(0, height-height*(1/span)*(0-mi), 230, height-height*(1/span)*(0-mi))
		--screen.drawText(175, 3, notations[min_max_notation]:format(ma))
		--screen.drawText(175, height - 9, notations[min_max_notation]:format(mi))

		if pause and ticks % 60 < 30 then
			screen.setColor(40, 0, 0)
		else
			screen.setColor(table.unpack(shades[3]))
		end

		screen.drawRectF(263, 135, 22, 22)
		-- screen.drawRect(236, 135, 22, 22)
		if csv_busy and ticks % 60 < 30 then
			screen.setColor(0, 40, 0)
		else
			screen.setColor(table.unpack(shades[3]))
		end
		screen.drawRectF(235, 135, 22, 22)
		screen.setColor(table.unpack(shades[1]))
		screen.drawText(240, 144, "CSV")
		screen.drawRect(235, 135, 22, 22)
		screen.drawRect(263, 135, 22, 22)

		screen.drawRectF(270, 140, 3, 13)
		screen.drawRectF(276, 140, 3, 13)
	end

	if not display then
		screen.drawTextBox(0, 0, 230, height, "No Channel Selected", 0, 0)
	end

	if pause and cursor then
		for i = 0, height + 2, 7 do
			screen.drawLine(cursor, i, cursor, i + 2)
		end

		local yc = {}
		for n, v in ipairs(data) do
			if v.state then
				x = math.min(#v.history, cursor)
				value = v.history[num_samples - 230 + x - offset]
				table.insert(yc, { n = n, x = x, y = math.max(4, math.min(146, height - (height / span) * (value - mi))) // 1, value = value })
			end
		end
		yc_done = false
		while not yc_done do
			yc_done = true
			table.sort(yc, function(a, b) return a.y < b.y end)
			for k = 1, #yc - 1 do
				if math.abs(yc[k].y - yc[k + 1].y) < 8 then
					yc_done = false
					yc[k].y = math.max(yc[k].y - 1, 4)
					yc[k + 1].y = math.min(yc[k + 1].y + 1, 143)
				end
			end
		end
		for n, v in ipairs(yc) do
			screen.setColor(50, 50, 50, 240)
			screen.drawRectF(v.x + 3, v.y - 3, 41, 7)
			screen.setColor(table.unpack(graph_colors[v.n]))
			screen.drawText(v.x + 4, v.y - 2, ("%-6.2g"):format(v.value):sub(1, 8))
		end
		-- for n, v in ipairs(data) do
		-- 	if v.state then
		-- 		x_cursor = math.min(#v.history, cursor)
		-- 		y_cursor = math.max(4, math.min(146, height - (height / span) * (v.history[num_samples - 230 + x_cursor - offset] - mi))) // 1
		-- 		screen.setColor(20, 20, 20, 220)
		-- 		screen.drawRectF(x_cursor+3, y_cursor-3, 36, 7)
		-- 		screen.setColor(table.unpack(graph_colors[n]))
		-- 		screen.drawText(x_cursor+4 , y_cursor-2, ("%-5.2g"):format(v.history[num_samples - 230 + x_cursor - offset]))
		-- 	end
		-- end
	end

	screen.setColor(table.unpack(shades[1]))
	screen.drawLine(230, 0, 230, 160)

	screen.setColor(table.unpack(shades[4]))
	screen.drawRectF(0, 151, 230, 8)
	for i = 0, 2 do
		screen.setColor(table.unpack(shades[ticks > offset1_button and 3 or 2]))
		screen.drawLine(3 + i, 155 - i, 3 + i, 156 + i)
		screen.setColor(table.unpack(shades[ticks > offset2_button and 3 or 2]))
		screen.drawLine(227 - i, 155 - i, 227 - i, 156 + i)
	end


	screen.setColor(table.unpack(shades[1]))
	screen.drawRect(0, 151, 230, 8)
	screen.drawLine(9, 151, 9, 160)
	screen.drawLine(221, 151, 221, 160)

	screen.setColor(255, 255, 255)
	screen.drawLine(221 - (offset / num_samples) * 212, 155, 220 - math.min(1, (230 + offset) / num_samples) * 212, 155)
end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end
