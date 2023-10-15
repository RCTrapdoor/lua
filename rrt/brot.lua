agent = {pos = {x = 20, y = 20}, vel = {x = 0.5, y = 0.25}, acc = {x = 0, y = 0.01}, r = 5}

function normalize(v)
	local mag = (v.x^2 + v.y^2)^0.5
	return {x = v.x / mag, y = v.y / mag}
end

function add(v1, v2)
	return {x = v1.x + v2.x, y = v1.y + v2.y}
end

function limit(v, limit)
	local mag = math.min((v.x^2 + v.y^2)^0.5, limit)
	return mult(normalize(v), mag)
end

function sub(v1, v2)
	return {x = v1.x - v2.x, y = v1.y - v2.y}
end

function mult(v, mul)
	return {x = v.x * mul, y = v.y * mul}
end

proj = {x = 1, y = 1}
target = {x = 40, y = 60}

function onTick()
	if input.getBool(1) then
		target = {x = input.getNumber(3), y = input.getNumber(4)}
	end
	maxspeed = input.getNumber(5) ~= 0 and input.getNumber(5) or 1.5
	maxforce = input.getNumber(6) ~= 0 and input.getNumber(6) or 0.05
	look_ahead = input.getNumber(7) ~= 0 and input.getNumber(7) or 0.5
	circle = input.getNumber(8) ~= 0 and input.getNumber(8) or 30
	
	force = {x = 0, y = 0}
	desired = mult(normalize(sub(proj, agent.pos)), maxspeed)
	steer = limit(sub(desired, agent.vel), maxforce)
	agent.acc = add(agent.acc, steer)
	agent.vel = add(agent.vel, agent.acc)
	agent.vel = limit(agent.vel, maxspeed)
	agent.pos = add(agent.pos, agent.vel)
	agent.acc = mult(agent.acc, 0)
	
	theta = math.atan(agent.pos.y - target.y, agent.pos.x - target.x) + look_ahead
	proj = {x = target.x + circle * math.cos(theta), y = target.y + circle * math.sin(theta)}
end

function onDraw()
	heading = math.atan(agent.vel.y, agent.vel.x)
	screen.drawTriangle(agent.pos.x + agent.r * math.cos(heading) * 2, agent.pos.y + agent.r * math.sin(heading) * 2, 
		agent.pos.x + agent.r * math.cos(heading+2.5), agent.pos.y + agent.r * math.sin(heading+2.5),
		agent.pos.x + agent.r * math.cos(heading-2.5), agent.pos.y + agent.r * math.sin(heading-2.5))
	screen.setColor(0, 0, 100)
	--screen.drawText(agent.xPos - 12, agent.yPos - 8, string.format('%.2f', theta))
	screen.drawCircle(proj.x, proj.y, 3)
	screen.setColor(150, 150, 150)
	screen.drawCircle(target.x, target.y, circle)
end