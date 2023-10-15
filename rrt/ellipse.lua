require("_build._simulator_config")
require("LifeBoatAPI")

ticks = 0
function f(a, b, theta, phi)
	local sin, cos = { t = math.sin(theta), p = math.sin(phi) }, { t = math.cos(theta), p = math.cos(phi) }
	return { x = a * cos.t * cos.p - b * sin.t * sin.p, y = a * sin.t * cos.p + b * cos.t * sin.p }
end

function onTick()

	ticks = ticks + 1
	
end

function onDraw()
	w = screen.getWidth()
	h = screen.getHeight()
	c = { x = w / 2, y = h / 2 }
	screen.setColor(60, 60, 30)
	screen.drawClear()

	screen.setColor(255, 255, 255)
	for i = 0, math.pi*2, math.pi/10 do
		p = f(20, 20, ticks / 100, i)
		if lp then
			--print(p.x, p.y, lp.x, lp.y)
			screen.drawLine(c.x+p.x, c.y+p.y, c.y+lp.x, c.x+lp.y)
		end
		lp = p
	end

end