-- require("_build._simulator_config")
require("LifeBoatAPI")

-- math.randomseed(os.time())

w = 288
h = 160
c = { x = w / 2, y = h / 2 }

function ellipse(a, b, theta, phi)
	local sin, cos = { t = math.sin(theta), p = math.sin(phi) }, { t = math.cos(theta), p = math.cos(phi) }
	return { x = a * cos.t * cos.p - b * sin.t * sin.p, y = a * sin.t * cos.p + b * cos.t * sin.p }
end

function pointInEllipse(x, y, xp, yp, d, D, angle)
	local cosa, sina, dd, DD, a, b, ellipse
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
	return { x = b.x + a.x, y = b.y + a.y}
end
function angle(a)
	return math.atan(a.y, a.x)
end
function vecScale(a, b)
	return { x = b * (a.x / vecDist(a)), y = b * (a.y / vecDist(a)) }
end
function vecDot(a, b)
	return a.x * b.x + a.y * b.y
end
function scalarRejection(a, b)
	return (a.y*b.x-a.x*b.y)/vecDist(b)
end

function moveNode(node, newParent) -- update cost and parent recursively
	local nodeKey = findKey(node.parent.nodes, node.id)	
	table.remove(node.parent.nodes, nodeKey)
	node.parent = newParent
	node.cost = newParent.cost + vecDist(vecSub(node, newParent))
	for i, child in ipairs(node.nodes) do
		moveNode(child, node)
	end
	table.insert(newParent.nodes, node)
end
-- 	local oldParent = node.parent
-- 	if oldParent then
-- 		oldParent.nodes[node.id] = nil
-- 	end
-- 	node.parent = newParent
-- 	if newParent then
-- 		newParent.nodes[node.id] = node
-- 	end
-- end

-- find value in table where id matches
function findKey(t, id)
	for i, node in ipairs(t) do
		if node.id == id then
			return i
		end
	end
	return nil
end

-- function findMin(branch, newNode, shortestNode)
-- 	shortestNode = shortestNode or branch
-- 	for i = 1, #branch.nodes do
-- 		if vecDist(vecSub(branch.nodes[i], newNode)) < vecDist(vecSub(shortestNode, newNode)) then
-- 			shortestNode = branch.nodes[i]
-- 		end
-- 		shortestNode = findMin(branch.nodes[i], newNode, shortestNode)
-- 	end
-- 	return shortestNode
-- end

-- function to find the lowest cost node in a neighborhood
function findMin(branch, newNode, shortestNode)
	local nearby = findNodes(branch, newNode, 20)
	shortestNode = shortestNode or nearby[1]
	for i = 1, #nearby do
		if nearby[i].cost < shortestNode.cost then
			shortestNode = nearby[i]
		end
	end
	return shortestNode
end





-- function to shallow merge two tables
function shallowMerge(t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end
	return t1
end

-- generate a random point within 20 pixels of existing nodes
function generateRandomPoint(distance)
	local x, y
	repeat
		x = math.random(0, w)
		y = math.random(0, h)
		nearby = findNodes(tree, { x = x, y = y}, distance)
	until #nearby > 0
	return { x = x, y = y }
end


-- function to find nodes within a certain distance of a point
function findNodes(branch, newNode, distance)
	local nodes = {}
	for i = 1, #branch.nodes do
		if vecDist(vecSub(branch.nodes[i], newNode)) < distance then
			table.insert(nodes, branch.nodes[i])
		end
		nodes = shallowMerge(nodes, findNodes(branch.nodes[i], newNode, distance))
	end
	return nodes
end

function drawbranch(branch)
	if #branch.nodes == 0 or not branch.parent then
		screen.drawCircle(branch.x, branch.y, 2)
	end
	for i = 1, #branch.nodes do
		screen.drawLine(branch.x, branch.y, branch.nodes[i].x, branch.nodes[i].y)
		drawbranch(branch.nodes[i])
	end
end

-- function hypot2(a,b)
-- 	return vecDot(vecSub(a, b), vecSub(a, b))
-- end

start = { x = 5, y = 5, r = 5 }
goal = { x = 280, y = 150, r = 5 }

tree = { nodes = {} }
tree.nodes[1] = { x = start.x, y = start.y, cost = 0, parent = nil, nodes = {}, id = 1 }
obstacles = {}
idTemp = 1
done = false

while true do
	p = { x = math.random(0, 287), y = math.random(0, 159), r = math.abs(math.random() * 20)}
	if vecDist(vecSub(p, start)) > p.r and vecDist(vecSub(p, goal)) > p.r then
		table.insert(obstacles, p)
		if #obstacles > 30 then
			break
		end
	end
end

-- circle line-segment intersection
function lineCircleIntersect(a, b, c, r)
	local dx, dy, A, B, C, det, t, x, y
	dx = b.x - a.x
	dy = b.y - a.y
	A = dx * dx + dy * dy
	B = 2 * (dx * (a.x - c.x) + dy * (a.y - c.y))
	C = (a.x - c.x) * (a.x - c.x) + (a.y - c.y) * (a.y - c.y) - r * r
	det = B * B - 4 * A * C
	if det < 0 then
		return false
	end
	t = (-B - math.sqrt(det)) / (2 * A)
	if t < 0 or t > 1 then
		return false
	end
	x = a.x + t * dx
	y = a.y + t * dy
	return { x = x, y = y }
end

function pointInCircle(a, obstacle)
	return vecDist(vecSub(a, obstacle)) < obstacle.r
end

function drawDashedCircle(x, y, r, n)
	local angle = 2 * math.pi / n
	for i = 0, n do
		local a = { x = x + r * math.cos(i * angle), y = y + r * math.sin(i * angle) }
		local b = { x = x + r * math.cos((i + 1) * angle), y = y + r * math.sin((i + 1) * angle) }
		screen.drawLine(a.x, a.y, b.x, b.y)
	end
end


ticks = 0
midPoint = { x = 0, y = 0 }
node = tree.nodes[1]

function onTick()
	if ticks == 0 then
		tree = { nodes = {} }
		tree.nodes[1] = { x = start.x, y = start.y, nodes = {}, cost = 0, parent = nil, id = 1 }
		done = false
	end
	ticks = ticks + 1
	click = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)
	if click then
		goal = { x = input.getNumber(3), y = input.getNumber(4) }
		tree = { nodes = {} }
		tree.nodes[1] = { x = start.x, y = start.y, nodes = {}, cost = 0, parent = nil, id = 1 }
		minVec = nil
		done = false
		ticks = 0
	end

	if not done and ticks % 1 == 0 then
		newNode = generateRandomPoint(15)
		if ticks % 60 == 0 then
			--newNode = { x = goal.x, y = goal.y }
			shortestNode = findMin(tree, newNode)
		else
			shortestNode = findMin(tree, newNode)
		end
		minVec = vecSub(newNode, shortestNode)
		for i = 1, #obstacles do
			obstacle = obstacles[i]
			if lineCircleIntersect(newNode, shortestNode, obstacle, obstacle.r) or pointInCircle(newNode, obstacle) then
				goto skip
				break
			end
		end
		idTemp = idTemp + 1
		table.insert(shortestNode.nodes, { x = newNode.x, y = newNode.y, nodes = {}, cost = shortestNode.cost + vecDist(minVec), parent = shortestNode, id = idTemp })
		noMore = false
		newNode = shortestNode.nodes[#shortestNode.nodes]
		nearby = findNodes(tree.nodes[1], newNode, 20)

		for i = 1, #nearby do
			local nearbyNode = nearby[i]
			if nearbyNode.cost + vecDist(vecSub(nearbyNode, newNode)) > newNode.cost then
				newNode.cost = nearbyNode.cost + vecDist(vecSub(nearbyNode, newNode))
				moveNode(newNode, nearbyNode)
			end
		end

		if vecDist(vecSub(newNode, goal)) < 5 then
			midPoint = {x = (goal.x - start.x) / 2 + start.x, y = (goal.y - start.y) / 2 + start.y}
			midPointAngle = math.atan(goal.y - start.y, goal.x - start.x)
			done = shortestNode.nodes[#shortestNode.nodes]
			distance = 0
			p = done
			while p.parent do
				p = p.parent
				d_temp = math.abs(scalarRejection(vecSub(p, start), vecSub(start, goal)))
				p.d = d_temp
				if d_temp > distance then
					distance = d_temp
					print(distance)
				end
			end
		end
		::skip::
	end
end

function onDraw()
	screen.setColor(60, 60, 30)
	screen.drawClear()

	screen.setColor(5, 5, 5)
	for i = 1, #obstacles do
		local v = obstacles[i]
		screen.drawCircleF(v.x, v.y, v.r)
	end
	if minVec then
		screen.setColor(10, 10, 140)
		screen.drawCircle(node.x, node.y, 2)
		screen.setColor(25, 25, 25)
		screen.drawLine(minVec.x, minVec.y, node.x, node.y)
	end
	drawbranch(tree.nodes[1])



	if done then
		l = done
		while l.parent do
			screen.setColor(0, 160, 0)
			screen.drawCircle(l.x, l.y, 2)
			screen.drawLine(l.x, l.y, l.parent.x, l.parent.y)
			if l.d then
				screen.setColor(255, 0, 0)
				screen.drawText(l.x - 5, l.y - 5, string.format("%.2f", l.d))
			end
			l = l.parent
		end
		-- draw an ellipse at the goal
		screen.setColor(0, 160, 0)
	
		for i = 0, math.pi*2, math.pi/20 do
			
			p = ellipse(1.1*vecDist(vecSub(goal, start)) / 2, distance, midPointAngle, i)
			if lp then
				screen.drawLine(midPoint.x+p.x, midPoint.y+p.y, midPoint.x+lp.x, midPoint.y+lp.y)
			end
			lp = p
		end
	end

	-- draw dashed circle around newNode
	if newNode then
		screen.setColor(0, 160, 0)
		drawDashedCircle(newNode.x, newNode.y, 20, 20)
	end

	screen.setColor(0, 140, 0)
	screen.drawCircle(start.x, start.y, 2)
	screen.setColor(140, 0, 0)
	screen.drawCircle(goal.x, goal.y, 2)

	if nearby then
		for i = 1, #nearby do
			local v = nearby[i]
			screen.setColor(10, 10, 140)
			screen.drawCircle(v.x, v.y, 2)
		end
	end
end