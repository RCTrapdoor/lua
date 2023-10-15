require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.

waypoints = { { x = 10, y = 10 }, { x = 60, y = 10 }, { x = 60, y = 60 }, { x = 10, y = 60 } }

to = waypoints[1]
from = waypoints[#waypoints]
curr = 1
agent = { pos = { x = from.x, y = from.y }, heading = 0, speed = 0.25 }
len = 30

projPointLookahead = { x = 0, y = 0 }
projPoint = { x = 0, y = 0 }

lookaheadLive = 10

lookahead_ = 15
lookahead = lookahead_

function vecSub(b, a) -- Vector from a to b
	return {x = a.x - b.x, y = a.y - b.y}
end

function vecDist(a)
	return (a.x^2+a.y^2)^0.5
end

function vecScale(a, b)
	return {x = b * (a.x / vecDist(a)), y =  b * (a.y / vecDist(a))}
end

function vecProduct(a, b)
	return a.x * b.x + a.y * b.y
end

function scalarProj(a, b)
	return vecProduct(a, b)/(vecDist(a))
end

function vecAdd(a, b)
	return {x = a.x + b.x, y = a.y + b.y}
end

function onTick()
	press = input.getBool(1)
	screenX = input.getNumber(3)
	screenY = input.getNumber(4)

	if press then
		agent.pos = {x = screenX, y = screenY}
	end

	wpVec = vecSub(from, to)

	if (len + lookahead) >= vecDist(wpVec) then
		curr = curr % #waypoints + 1
		from = to
		to = waypoints[curr]
	end

	len = vecProj(wpVec, vecSub(from, agent.pos))

	
	projPoint = vecAdd(from, vecScale(wpVec, len))
	lookahead = math.max(0, math.min(lookahead_, lookahead_ - vecDist(vecSub(agent.pos, projPoint))))
	projPointLookahead = vecAdd(from, vecScale(wpVec, len + lookahead))

	agent.heading = math.atan(agent.pos.x - projPointLookahead.x, agent.pos.y - projPointLookahead.y)
	agent.pos.x = agent.pos.x - agent.speed * math.sin(agent.heading)
	agent.pos.y = agent.pos.y - agent.speed * math.cos(agent.heading)

end

function onDraw()
	screen.setColor(0, 180, 0, 100)
	screen.drawCircleF(agent.pos.x, agent.pos.y, 3)
	screen.setColor(180, 180, 180)
	screen.drawLine(from.x, from.y, to.x, to.y)
	screen.setColor(180, 0, 0)
	screen.drawLine(agent.pos.x, agent.pos.y, projPointLookahead.x, projPointLookahead.y)
	screen.setColor(50, 120, 0)
	screen.drawLine(agent.pos.x, agent.pos.y, projPoint.x, projPoint.y)

end
