-- Author: Trapdoor
-- GitHub: Trapdoor
-- Workshop: Trapdoor

--Trapdoor--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

---@section Simulator
__simulator.config:configureScreen(1, "9x5", true, false)

sample_rate = property.getNumber("Sample every n-th tick") or 1

data = {}

notations = {"%11.2f", "%11.2e", "%11.2g"}

min_max_notation = property.getNumber("Min/Max Value Notation") or 1
current_notation = property.getNumber("Current Value Notation") or 1

channels = property.getNumber("Number of Channels") or 1

colors = {{255, 0, 0}, {255, 255, 0}, {0, 255, 0}, {255, 0, 255}, {0, 255, 255}, {0, 0, 255}, {55, 0, 0}, {55, 55, 0}}

labels = {}

ticks = 0
mi, ma = 0, 0
for i = 1, channels do
	table.insert(data, {state = true, history = {}})
	--table.insert(labels, property.getText("Label " .. i))
end

function find_span()
	mi = math.huge
	ma = -math.huge
	
	for k, v in ipairs(data) do
	
		if #v.history > 230 then
			table.remove(v.history, 1)
		end
		
		if v.state then
			for n, d in ipairs(v.history) do
				mi = math.min(mi or d, d)
				ma = math.max(ma or d, d)
				span = ma - mi
			end
		end
		
	end
end

function onTick()
	ticks = ticks + 1
	click = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)
	inputX = input.getNumber(3)
	inputY = input.getNumber(4)
	
	if click and isPointInRectangle(inputX, inputY, 232, 2, 288, channels * 16) then
		c = math.min(channels, math.max(1, math.ceil(inputY / 16)))
		data[c].state = not data[c].state
	end
	
	if click and isPointInRectangle(inputX, inputY, 263, 135, 22, 22) then
		cursor = nil
		pause = not pause
	end
	
	if pause then
		find_span()
		if click and isPointInRectangle(inputX, inputY, 0, 0, 230, 160) then
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

function onDraw()
	screen.setColor(100, 100, 100)
	
	w, h = screen.getWidth(), screen.getHeight() - 1
	state = false
	
	if #data[1].history > 1 then
		--screen.drawTextBox(232, 146, 29, 10, "Hold", 0, 0)
		for i = 0, 220, 10 do
			screen.drawLine(i, h - h * (1 / span) * (0 - mi), i + 5, h - h * (1 / span) * (0 - mi))
		end
		
		for k, v in ipairs(data) do
			if v.state then
				state = true
				screen.setColor(table.unpack(colors[k]))
				for n = 2, #v.history do
					screen.drawLine(n - 1, h - (h / span) * (v.history[n - 1] - mi), n, h - (h / span) * (v.history[n] - mi))
				end
			else
				screen.setColor(50, 50, 50)
			end
			if #v.history > 0 then
				screen.drawText(232, 16 * k - 14, labels[k])
				screen.drawText(232, 16 * k - 8, notations[current_notation]:format(v.history[cursor and math.min(cursor, #v.history) or #v.history]))
			end
		end
		--screen.drawLine(0, h-h*(1/span)*(0-mi), 230, h-h*(1/span)*(0-mi))
		screen.drawText(175, 3, notations[min_max_notation]:format(ma))
		screen.drawText(175, h - 7, notations[min_max_notation]:format(mi))
		
		if pause and ticks % 60 < 30 then
			screen.setColor(40, 0, 0)
		else
			screen.setColor(30, 30, 30)
		end
		
		screen.drawRectF(263, 135, 22, 22)
		-- screen.drawRect(236, 135, 22, 22)
		screen.setColor(100, 100, 100)
		screen.drawRect(263, 135, 22, 22)
		screen.drawRectF(270, 140, 3, 13)
		screen.drawRectF(276, 140, 3, 13)
		
	end
	
	if not state then
		screen.drawTextBox(0, 0, 230, h, "No Channel Selected", 0, 0)
	end
	
	if pause and cursor then
		for i = 0, h+2, 10 do
			screen.drawLine(cursor, i, cursor, i+3)
		end
			
		for n, v in ipairs(data) do
			if v.state then
				x_cursor = math.min(#v.history, cursor)
				y_cursor = math.max(3, math.min(152, h - (h / span) * (v.history[x_cursor] - mi))) // 1
				screen.setColor(20, 20, 20, 220)
				screen.drawRectF(x_cursor+1, y_cursor-3, 36, 7)
				screen.setColor(table.unpack(colors[n]))
				screen.drawText(x_cursor+2 , y_cursor-2, ("%-5.2g"):format(v.history[x_cursor]))
			end
		end
	end
		
	screen.setColor(100, 100, 100)
	screen.drawLine(230, 0, 230, h)
end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end