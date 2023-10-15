require("_build._simulator_config")
require("LifeBoatAPI")

-- math.randomseed(os.time())

function f(a, b, theta, phi)
	local sin, cos = { t = math.sin(theta), p = math.sin(phi) }, { t = math.cos(theta), p = math.cos(phi) }
	return { x = a * cos.t * cos.p - b * sin.t * sin.p, y = a * sin.t * cos.p + b * cos.t * sin.p }
end
function pointInEllipse(x, y, xp, yp, d, D, angle)
	cosa = math.cos(angle)
	sina = math.sin(angle)
	dd = d * d
	DD = D * D
	a = (cosa * (xp - x) + sina * (yp - y)) ^ 2
	b = (sina * (xp - x) - cosa * (yp - y)) ^ 2
	ellipse = (a / dd) + (b / DD)

	if ellipse <= 1 then
		return true
	end
	return false
end
function vecDist(a)
	return (a.x ^ 2 + a.y ^ 2) ^ 0.5
end
function vecSub(a, b) -- Vector from a to b
	return { x = b.x - a.x, y = b.y - a.y }
end
function vecAdd(a, b)
	return { x = b.x + a.x, y = b.y + a.y }
end
function angle(a)
	return math.atan(a.y, a.x)
end
function vecScale(a, b)
	return { x = b * (a.x / vecDist(a)), y = b * (a.y / vecDist(a)) }
end
function vecProd(a, b)
	return a.x * b.x + a.y * b.y
end
function drawDashedCircle(x, y, r, n)
	local angle = 2 * math.pi / n
	for i = 0, n - 1 do
		local p1 = f(x, y, i * angle, 0)
		local p2 = f(x, y, (i + 1) * angle, 0)
		screen.drawLine(p1.x, p1.y, p2.x, p2.y)
	end
end

function findMin(branch, newNode, shortestNode)
	shortestNode = shortestNode or branch
	for i = 1, #branch.nodes do
		if vecDist(vecSub(branch.nodes[i], newNode)) < vecDist(vecSub(shortestNode, newNode)) then
			shortestNode = branch.nodes[i]
		end
		shortestNode = findMin(branch.nodes[i], newNode, shortestNode)
	end
	return shortestNode
end

function drawbranch(branch)
	screen.drawCircle(branch.x, branch.y, 2)
	for i = 1, #branch.nodes do
		screen.drawLine(branch.x, branch.y, branch.nodes[i].x, branch.nodes[i].y)
		drawbranch(branch.nodes[i])
	end
end

start = { x = 5, y = 5 }
goal = { x = 280, y = 150 }

tree = { nodes = {} }
tree.nodes[1] = { x = start.x, y = start.y, nodes = {} }
obstacles = {}

done = false

while true do
	r = math.abs(math.random() * 20)
	p = { x = math.random(0, 287), y = math.random(0, 159) }

	if vecDist(vecSub(p, start)) > (r + 2) and vecDist(vecSub(p, goal)) > (r + 2) then
		table.insert(obstacles, { p = p, r = r })
		if #obstacles > 30 then
			break
		end
	end
end

ticks = 0

--node = { x = math.random(0, 95), y = math.random(0, 95) }

function onTick()
	if ticks == 0 then
		tree = { nodes = {} }
		tree.nodes[1] = { x = start.x, y = start.y, nodes = {} }
	end
	ticks = ticks + 1
	if click then
		goal = { x = input.getNumber(3), y = input.getNumber(4) }
		tree = { nodes = {} }
		tree.nodes[1] = { x = start.x, y = start.y, nodes = {} }
		minVec = nil
		done = false
		ticks = 0
	end
	click = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)

	if not done then
		if ticks % 20 == 0 then
			node = goal
		else
			node = { x = math.random(0, 287), y = math.random(0, 159) }
		end
		minVec = findMin(tree.nodes[1], node)
		v = vecSub(minVec, node)
		dr = math.min(vecDist(v), 20)
		vec = vecScale(v, dr)
		--det = minVec.x * vec.y - minVec.y * vec.x
		for i = 1, #obstacles do
			local v = obstacles[i]
			dx, dy = vec.x, vec.y
			--print(vec.x, minVec.x, dx, vec.y, minVec.y, dy)
			A = dx * dx + dy * dy
			B = 2 * (dx * (minVec.x - v.p.x) + dy * (minVec.y - v.p.y))
			C = (minVec.x - v.p.x) * (minVec.x - v.p.x) + (minVec.y - v.p.y) * (minVec.y - v.p.y) - v.r * v.r
			det = B * B - 4 * A * C
			--print(det)
			if det == 0 then
				t = -B / (2 * A)
				if vecDist(vecSub(minVec, { x = minVec.x + t * dx, y = minVec.y + t * dy })) < 18 then
					--print("Fuck you")
					goto skip
				end
			elseif det > 0 then
				t = (-B + det ^ 0.5) / (2 * A)
				if vecDist(vecSub(minVec, { x = minVec.x + t * dx, y = minVec.y + t * dy })) < 18 then
					--print("Fuck you")
					goto skip
				end
				t = (-B - det ^ 0.5) / (2 * A)
				if vecDist(vecSub(minVec, { x = minVec.x + t * dx, y = minVec.y + t * dy })) < 18 then
					--print("Fuck you")
					goto skip
				end
			end
		end
		table.insert(minVec.nodes, { x = minVec.x + vec.x, y = minVec.y + vec.y, nodes = {}, parent = minVec })
		if vecDist(vecSub(goal, vecAdd(minVec, vec))) < 1 then
			--print("We're done here!")
			done = findMin(tree.nodes[1], goal)
			print(done.x, done.y)
		end
		::skip::
	end
end

function onDraw()
	w = screen.getWidth()
	h = screen.getHeight()
	c = { x = w / 2, y = h / 2 }
	screen.setColor(60, 60, 30)
	screen.drawClear()

	screen.setColor(5, 5, 5)
	for i = 1, #obstacles do
		local v = obstacles[i]
		screen.drawCircleF(v.p.x, v.p.y, v.r)
	end
	if minVec then
		screen.setColor(10, 10, 140)
		screen.drawCircle(node.x, node.y, 2)
		screen.setColor(25, 25, 25)
		screen.drawLine(minVec.x, minVec.y, node.x, node.y)
	end
	drawbranch(tree.nodes[1])

	if done then
		screen.setColor(0, 160, 0)
		l = done
		while l.parent do
			screen.drawLine(l.x, l.y, l.parent.x, l.parent.y)
			l = l.parent
		end
	end
	
	screen.setColor(0, 140, 0)
	screen.drawCircle(start.x, start.y, 2)
	screen.setColor(140, 0, 0)
	screen.drawCircle(goal.x, goal.y, 2)
end

-- for i = 0, math.pi*2, math.pi/10 do
--     p = f(40, 10, ticks / 100, i)
--     if lp then
--         screen.drawLine(c.x+p.x, c.y+p.y, c.y+lp.x, c.x+lp.y)
--     end
--     lp = p
-- end
