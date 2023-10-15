function mandelbrot(x, y)
	local cr = x - 0.5
	local ci = y
	local zi = 0.0
	local zr = 0.0
	local i = 0
	while true do
		local temp = zr * zi
		local zr2 = zr * zr
		local zi2 = zi * zi
		zr = zr2 - zi2 + cr
		zi = temp + temp + ci
		if zi2 + zr2 > 4.0 then
			break
		end
		i = i + 1
		if i > 1000 then
			break
		end
	end
	return i
end

screen_width = 96
screen_height = 64

x_center = 0.0
y_center = 0.0

x_scale = 3.0
y_scale = 2.0

function hsv_to_rgb(h, s, v)
	local r, g, b
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	i = i % 6
	if i == 0 then
		r, g, b = v, t, p
	elseif i == 1 then
		r, g, b = q, v, p
	elseif i == 2 then
		r, g, b = p, v, t
	elseif i == 3 then
		r, g, b = p, q, v
	elseif i == 4 then
		r, g, b = t, p, v
	elseif i == 5 then
		r, g, b = v, p, q
	end
	return r * 255, g * 255, b * 255
end

function onTick()
	if input.getBool(2) then
		touch = {x = input.getNumber(3), y = input.getNumber(4)}
		x_center = x_center + (touch.x - screen_width / 2) / screen_width * x_scale
		y_center = y_center + (touch.y - screen_height / 2) / screen_height * y_scale
		x_scale = x_scale * 2
		y_scale = y_scale * 2
	elseif input.getBool(1) then
		touch = {x = input.getNumber(3), y = input.getNumber(4)}
		x_center = x_center + (touch.x - screen_width / 2) / screen_width * x_scale
		y_center = y_center + (touch.y - screen_height / 2) / screen_height * y_scale
		x_scale = x_scale / 2
		y_scale = y_scale / 2
	end
end

function onDraw()
	for x = 0, screen_width - 1 do
		for y = 0, screen_height - 1 do
			local i = mandelbrot(x / screen_width * x_scale + x_center - x_scale / 2, y / screen_height * y_scale + y_center - y_scale / 2)
			local r, g, b = hsv_to_rgb(i / 200, 1, i < 1000 and 1 or 0)
			screen.setColor(r, g, b)
			screen.drawRectF(x, y, 1, 1)
		end
	end
end