-- sample_rate = property.getNumber("Sample every n-th tick") or 1
sample_rate = 2
data = {}

channels = 8

colors = {{255, 0, 0}, {255, 255, 0}, {0, 255, 0}, {255, 0, 255}, {0, 255, 255}, {0, 0, 255}, {55, 0, 0}, {55, 55, 0}}

labels = {}
--smooth = property.getNumber("Smoothing (ticks)")
max_frequency = 2
tau = math.pi*2
ticks = 0
--mi,ma = 0, 0


for i = 1, channels do
	table.insert(data, {state=true, history={}})
	table.insert(labels, property.getText("Label "..i))
end

function onTick()
	history2 = {}
	width,height = 288, 160
	ticks = tonumber((ticks + 1) % sample_rate)
	click = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)
	inputX = input.getNumber(3)
	inputY = input.getNumber(4)
	
	if ticks == 0 then
    	for i = 1, channels do
    		table.insert(data[i].history, input.getNumber(9+i))
    	end
	end

	if click and isPointInRectangle(inputX, inputY, 232, 2, 288, 10+channels*16) then
		c = math.min(channels, math.max(1, math.ceil((inputY-2)/16)))
		data[c].state = not data[c].state
	end
	
    mi = nil
    ma = nil

	for freq = 0, max_frequency, max_frequency/#data[4].history do
        --print(freq)
        x_sum, y_sum = 0, 0
        for k,val in ipairs(data[1].history) do
            theta = k*100 * (freq/60) * tau
            --print(k, theta, val)
            x, y = val * math.cos(theta)*height/2, val * math.sin(theta)*height/2
            x_sum = x_sum + x
            y_sum = y_sum + y
        end
        table.insert(history2, (x_sum / #data[4].history) / 20)
    end

    for k,v in ipairs(data) do
    	if #v.history > 288 then
    		table.remove(v.history, 1)
    	end
	end
--		if v.state then
--		if #history2 > 2 then
--    		for n, d in ipairs(v.history) do
--    			mi = math.min(mi or d, d)
--    			ma = math.max(ma or d, d)
--    			span = ma-mi
--			end
--    	end
--    end
	mi = -2
	ma = 2
	span = ma - mi
	factor = 288/span

end

function onDraw()
    --w,h = screen.getWidth(), screen.getHeight()
	screen.drawText(6, 6, string.format('hei: %6.2f, %6.2f',  data[4].history[#data[4].history]*100, height))
    for i = 0, width, width/5 do
        screen.setColor(15, 5, 0, 150)
        screen.drawLine(i, 0, i, height)
        screen.setColor(35, 20, 0)
        screen.drawTextBox(i-30, 10, 30, 10, string.format('%.1f Hz', i / (288 / max_frequency)), 1, 0)
    end

    screen.setColor(160, 160, 160)
    for n = 1, #history2-1 do
        screen.drawLine(n, 240-factor*(history2[n]-mi), n+1, 240-factor*(history2[n+1]-mi))
    end
end
	

--[[function onDraw()
	screen.setColor(100, 100, 100)
	w,h = screen.getWidth(),screen.getHeight()
	if mi then
		screen.drawLine(0, h-h*(1/span)*(0-mi), 230, h-h*(1/span)*(0-mi))
		screen.drawText(0, 3, string.format('%#7.3g', ma))
		screen.drawText(0, h-7, string.format('%#7.3g', mi))
	else
		screen.drawTextBox(0, 0, 230, h, "No Channel Selected", 0, 0)
	end
	screen.drawLine(230, 0, 230, h)
	for k,v in ipairs(data) do
		if v.state then
			lsval = v.history[1]
			screen.setColor(table.unpack(colors[k]))
			for n, d in ipairs(v.history) do
				if n > 1 then
					sval = d
--					if false then
--						sval = 0
--						for i = 0, smooth do
--							sval = sval+v.history[math.min(#v.history, n+i)]
--						end
--						sval = sval/smooth
--					end
					
					screen.drawLine(n-1, h-(h/span)*(lsval-mi), n, h-(h/span)*(sval-mi))
					lsval = sval
				end
			end
		else
			screen.setColor(50, 50, 50)
		end
		if #v.history > 0 then
			screen.drawText(232, 16*k-14, labels[k])
			screen.drawText(232, 16*k-8, string.format('%11.4f', v.history[#v.history]))
		end
	end
end
--]]
function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
    return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end