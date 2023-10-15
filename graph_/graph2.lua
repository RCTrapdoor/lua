-- Author: Trapdoor
-- GitHub: Trapdoor
-- Workshop: Trapdoor

--Trapdoor--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
require("LifeBoatAPI")              -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

sample_rate = property.getNumber("Sample every n-th tick") or 1

data = {}

notations = {"%11.2f", "%11.2e", "%11.2g"}

min_max_notation = property.getNumber("Min/Max Value Notation") or 1
current_notation = property.getNumber("Current Value Notation") or 1

channels = property.getNumber("Number of Channels") or 2

shades = {{255, 0, 0}, {255, 255, 0}, {0, 255, 0}, {255, 0, 255}, {0, 255, 255}, {0, 0, 255}, {55, 0, 0}, {55, 55, 0}}

labels = {}

num_samples = 1000

ticks = 0

for i = 1, channels do
	table.insert(data, {state = true, history = {}})
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
			for history_slice = math.min(#v.history), math.max(#v.history-230, 1), -1 do
				mi = math.min(mi, v.history[history_slice])
				ma = math.max(ma, v.history[history_slice])
				span = ma - mi
			end
		end
		
	end
end
offset1_button, offset2_button = 0, 0
function onTick()
	ticks = ticks + 1
	click = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)
	inputX = input.getNumber(3)
	inputY = input.getNumber(4)
	if click then
		if isPointInRectangle(inputX, inputY, 232, 1, 58, channels * 16) then
			c = math.min(channels, math.max(1, math.ceil(inputY / 16)))
			data[c].state = not data[c].state
		
		elseif isPointInRectangle(inputX, inputY, 263, 135, 22, 22) then
			cursor = nil
			offset = 0
			pause = not pause

		elseif isPointInRectangle(inputX, inputY, 0, 151, 9, 9) then -- step back
			offset = math.min(offset + 115, #data[1].history - 232)
			offset1_button = ticks + 20

		elseif isPointInRectangle(inputX, inputY, 221, 151, 9, 9) then -- step forward
			offset = math.max(offset - 115, 0)
			offset2_button = ticks + 20
		end
	end
	
	if pause then
		find_span()

		if click and isPointInRectangle(inputX, inputY, 0, 0, 230, 150) then
			cursor = inputX
		end

		return true
	end
	
	if ticks % sample_rate == 0 then
		for i = 1, channels do
			table.insert(data[i].history, input.getNumber(9 + i))
		end
	end
	
    -- if ticks % sample_rate == 0 then
    --     table.insert(data[1].history, math.cos(ticks / 30))
    -- end

	find_span()
end

offset = 0
shades = {{100, 100, 100}, {140, 140, 140}, {50, 50, 50}}
function onDraw()
    screen.drawText(2, 2, ticks)
	screen.setColor(table.unpack(shades[1]))
	
	width, height = screen.getWidth(), screen.getHeight() - 9
	display = false
	
	if #data[1].history > 1 then
		--screen.drawTextBox(232, 146, 29, 10, "Hold", 0, 0)
		for i = 0, 220, 10 do
			screen.drawLine(i, height - height * (1 / span) * (0 - mi), i + 5, height - height * (1 / span) * (0 - mi))
		end
		
		for k, v in ipairs(data) do
			if v.state then
				display = true
				screen.setColor(table.unpack(shades[k]))
				for a = 0, 230 do
                    n = num_samples - 230 + a - offset
					screen.drawLine(a - 1, height - (height / span) * (v.history[n - 1] - mi), a, height - (height / span) * (v.history[n] - mi))
				end
			else
				screen.setColor(table.unpack(shades[3]))
			end
			if #v.history > 0 then
				screen.drawText(232, 16 * k - 14, labels[k])
				screen.drawText(232, 16 * k - 8, notations[current_notation]:format(v.history[cursor and math.min(cursor, #v.history) or #v.history]))
			end
		 end
		--screen.drawLine(0, h-h*(1/span)*(0-mi), 230, h-h*(1/span)*(0-mi))
		screen.drawText(175, 3, notations[min_max_notation]:format(ma))
		screen.drawText(175, height - 15, notations[min_max_notation]:format(mi))
		
		if pause and ticks % 60 < 30 then
			screen.setColor(40, 0, 0)
		else
			screen.setColor(table.unpack(shades[3]))
		end
		
		screen.drawRectF(263, 135, 22, 22)
		-- screen.drawRect(236, 135, 22, 22)
		screen.setColor(table.unpack(shades[1]))
		screen.drawRect(263, 135, 22, 22)
		screen.drawRectF(270, 140, 3, 13)
		screen.drawRectF(276, 140, 3, 13)
		
	end
	
	if not display then
		screen.drawTextBox(0, 0, 230, height, "No Channel Selected", 0, 0)
	end
	
	if pause and cursor then
		for i = 0, height+2, 10 do
			screen.drawLine(cursor, i, cursor, i+3)
		end
			
		for n, v in ipairs(data) do
			if v.state then
				x_cursor = math.min(#v.history, cursor)
				y_cursor = math.max(3, math.min(152, height - (height / span) * (v.history[num_samples - 230 + x_cursor - offset] - mi))) // 1
				screen.setColor(20, 20, 20, 220)
				screen.drawRectF(x_cursor+1, y_cursor-3, 36, 7)
				screen.setColor(table.unpack(shades[n]))
				screen.drawText(x_cursor+2 , y_cursor-2, ("%-5.2g"):format(v.history[num_samples - 230 + x_cursor - offset]))
			end
		end
	end
		
	screen.setColor(table.unpack(shades[1]))
	screen.drawLine(230, 0, 230, height)

    for i = 0, 2 do
        screen.setColor(table.unpack(shades[ticks > offset1_button and 1 or 2]))
        screen.drawLine(3+i, 155-i, 3+i, 156+i)
        screen.setColor(table.unpack(shades[ticks > offset2_button and 1 or 2]))
        screen.drawLine(227-i, 155-i, 227-i, 156+i)
    end

    screen.setColor(table.unpack(shades[1]))
    screen.drawRect(0, 151, 230, 8)
    screen.drawLine(9, 151, 9, 160)
    screen.drawLine(221, 151, 221, 160)

    for i = -1, 100, 16 do
        screen.drawLine(230, i, 288, i)
    end

    screen.setColor(255, 255, 255)
    screen.drawLine(221 - (offset / num_samples) * 212, 155, 220 - math.min(1, (230 + offset) / num_samples) * 212, 155)
end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end